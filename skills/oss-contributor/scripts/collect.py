#!/usr/bin/env python3
"""Shared GitHub collection layer (design D2, D3, D4).

One collector serves every area. Fetches a bounded, recency-ordered sample of
pull requests with their review threads, plus policy files and release
metadata, using batched GraphQL through the gh CLI.

Makes no judgments and computes no metrics. Metrics are computed by
metrics.py; conventions are proposed by the model and checked by verify.py.

Read-only by construction (design D9): every query here is a GraphQL `query`,
never a `mutation`. No code path in this file can post, assign, or open
anything.
"""

import argparse
import json
import subprocess
import sys
from datetime import datetime, timezone

SCHEMA_VERSION = 1

# Associations marking a pull request author as a project insider (design D6).
INSIDER_ASSOCIATIONS = {"OWNER", "MEMBER", "COLLABORATOR"}

# Page size well under the 100 maximum. Each PR pulls up to 30 nested nodes,
# so 20 per page keeps query complexity inside GitHub's scoring limits even on
# repositories with very long review threads (task 2.3).
PAGE_SIZE = 20

# Candidate locations for contribution policy documents (task 2.5).
POLICY_PATHS = [
    "CONTRIBUTING.md",
    ".github/CONTRIBUTING.md",
    "docs/CONTRIBUTING.md",
    "CONTRIBUTING.rst",
    "AGENTS.md",
    ".github/AGENTS.md",
    "CLAUDE.md",
    ".github/PULL_REQUEST_TEMPLATE.md",
    ".github/pull_request_template.md",
    "DCO",
]

PR_QUERY = """
query($owner:String!, $name:String!, $states:[PullRequestState!], $first:Int!, $after:String) {
  rateLimit { remaining resetAt cost }
  repository(owner:$owner, name:$name) {
    pullRequests(states:$states, first:$first, after:$after,
                 orderBy:{field:UPDATED_AT, direction:DESC}) {
      pageInfo { hasNextPage endCursor }
      nodes {
        number title bodyText url
        createdAt mergedAt closedAt
        additions deletions changedFiles
        authorAssociation
        author { login }
        mergedBy { login }
        reviews(first:10) {
          nodes { authorAssociation createdAt bodyText state author { login } }
        }
        comments(first:20) {
          nodes { authorAssociation createdAt bodyText author { login } }
        }
      }
    }
  }
}
"""

META_QUERY = """
query($owner:String!, $name:String!) {
  rateLimit { remaining resetAt cost }
  repository(owner:$owner, name:$name) {
    nameWithOwner description isArchived isFork stargazerCount
    primaryLanguage { name }
    repositoryTopics(first:20) { nodes { topic { name } } }
    licenseInfo { spdxId name url }
    defaultBranchRef { name target { ... on Commit { committedDate history(first:1) { totalCount } } } }
    releases(first:1, orderBy:{field:CREATED_AT, direction:DESC}) {
      nodes { publishedAt tagName url }
    }
  }
}
"""


class Inaccessible(Exception):
    """Repository absent or unreadable with this credential (task 2.7)."""


class RateLimited(Exception):
    """GraphQL budget exhausted mid-collection (task 2.8)."""


def gh_graphql(query, variables):
    if "mutation" in query.split("{", 1)[0].lower():
        raise RuntimeError("refusing to run a mutation: this skill is read-only")

    cmd = ["gh", "api", "graphql", "-f", f"query={query}"]
    for key, value in variables.items():
        if value is None:
            continue
        if isinstance(value, list):
            # gh expects one repeated `key[]=item` flag per element. Passing a
            # JSON array string is rejected by the GraphQL enum coercer.
            for item in value:
                cmd += ["-f", f"{key}[]={item}"]
        elif isinstance(value, int):
            cmd += ["-F", f"{key}={value}"]
        else:
            cmd += ["-f", f"{key}={value}"]

    proc = subprocess.run(cmd, capture_output=True, text=True)
    if proc.returncode != 0:
        err = proc.stderr.strip()
        if "Could not resolve to a Repository" in err or "NOT_FOUND" in err:
            raise Inaccessible(err)
        if "RATE_LIMITED" in err or "rate limit" in err.lower():
            raise RateLimited(err)
        raise RuntimeError(f"gh graphql failed: {err}")

    payload = json.loads(proc.stdout)
    if "errors" in payload:
        messages = "; ".join(e.get("message", "") for e in payload["errors"])
        if "Could not resolve to a Repository" in messages:
            raise Inaccessible(messages)
        if "rate limit" in messages.lower():
            raise RateLimited(messages)
        raise RuntimeError(f"graphql errors: {messages}")
    return payload["data"]


def fetch_prs(owner, name, states, limit):
    """Fetch up to `limit` pull requests, most recently updated first.

    Returns (nodes, truncation_note, budget). A rate-limit hit mid-collection
    yields a partial result with a note rather than an exception, so the caller
    can report what was skipped instead of truncating silently (task 2.8).
    """
    collected, cursor, truncated = [], None, None
    budget = {"remaining": None, "reset_at": None}

    while len(collected) < limit:
        want = min(PAGE_SIZE, limit - len(collected))
        try:
            data = gh_graphql(PR_QUERY, {
                "owner": owner, "name": name, "states": states,
                "first": want, "after": cursor,
            })
        except RateLimited as exc:
            truncated = (f"rate limit exhausted after {len(collected)} of {limit} "
                         f"requested; resets per API: {exc}")
            break

        budget["remaining"] = data["rateLimit"]["remaining"]
        budget["reset_at"] = data["rateLimit"]["resetAt"]

        conn = data["repository"]["pullRequests"]
        collected.extend(conn["nodes"])
        if not conn["pageInfo"]["hasNextPage"]:
            break
        cursor = conn["pageInfo"]["endCursor"]

    return collected[:limit], truncated, budget


def fetch_policy_files(owner, name):
    """Fetch all candidate policy documents in one batched, aliased query."""
    fields, alias_map = [], {}
    for idx, path in enumerate(POLICY_PATHS):
        alias = f"f{idx}"
        alias_map[alias] = path
        fields.append(f'{alias}: object(expression: "HEAD:{path}") '
                      f'{{ ... on Blob {{ text byteSize }} }}')

    query = ("query($owner:String!, $name:String!) { "
             "repository(owner:$owner, name:$name) { " + " ".join(fields) + " } }")
    repo = gh_graphql(query, {"owner": owner, "name": name})["repository"]

    return {
        path: repo[alias]["text"]
        for alias, path in alias_map.items()
        if repo.get(alias) and repo[alias].get("text")
    }


def collect(owner, name, merged_limit, unmerged_limit):
    collected_at = datetime.now(timezone.utc)
    notes = []

    meta = gh_graphql(META_QUERY, {"owner": owner, "name": name})["repository"]

    if meta.get("isArchived"):
        notes.append("repository is archived and accepts no contributions")

    merged, merged_trunc, budget = fetch_prs(owner, name, ["MERGED"], merged_limit)
    if merged_trunc:
        notes.append(f"merged sample truncated: {merged_trunc}")

    unmerged, unmerged_trunc, budget2 = fetch_prs(owner, name, ["CLOSED"], unmerged_limit)
    if unmerged_trunc:
        notes.append(f"closed-unmerged sample truncated: {unmerged_trunc}")
    if budget2.get("remaining") is not None:
        budget = budget2

    # `states: CLOSED` can include merged PRs; filter so the rejection signal
    # is not diluted (task 2.2).
    unmerged = [pr for pr in unmerged if not pr.get("mergedAt")]

    try:
        policy_files = fetch_policy_files(owner, name)
    except RateLimited as exc:
        policy_files = {}
        notes.append(f"policy files not fetched (rate limit): {exc}")

    # Release date, falling back to last default-branch commit (task 2.6).
    releases = (meta.get("releases") or {}).get("nodes") or []
    branch = meta.get("defaultBranchRef") or {}
    target = branch.get("target") or {}
    if releases:
        activity_date = releases[0]["publishedAt"]
        activity_basis = "latest_release"
        activity_label = releases[0].get("tagName")
    else:
        activity_date = target.get("committedDate")
        activity_basis = "last_default_branch_commit"
        activity_label = branch.get("name")
        notes.append("no releases; last default-branch commit substituted for release date")

    return {
        "schema_version": SCHEMA_VERSION,
        "repository": f"{owner}/{name}",
        "collected_at": collected_at.isoformat(),
        "sample": {
            "merged_requested": merged_limit,
            "merged_actual": len(merged),
            "unmerged_requested": unmerged_limit,
            "unmerged_actual": len(unmerged),
        },
        "metadata": {
            "description": meta.get("description"),
            "is_archived": meta.get("isArchived"),
            "is_fork": meta.get("isFork"),
            "stargazer_count": meta.get("stargazerCount"),
            "primary_language": (meta.get("primaryLanguage") or {}).get("name"),
            "topics": [n["topic"]["name"]
                       for n in ((meta.get("repositoryTopics") or {}).get("nodes") or [])],
            "license": meta.get("licenseInfo"),
            "default_branch": branch.get("name"),
            "total_commits": ((target.get("history") or {}).get("totalCount")),
            "activity_date": activity_date,
            "activity_basis": activity_basis,
            "activity_label": activity_label,
        },
        "policy_files": policy_files,
        "merged_prs": merged,
        "unmerged_prs": unmerged,
        "rate_limit": budget,
        "notes": notes,
    }


def parse_slug(value):
    slug = value.strip().rstrip("/")
    if "github.com" in slug:
        slug = slug.split("github.com/", 1)[1]
    parts = [p for p in slug.split("/") if p]
    if len(parts) < 2:
        raise ValueError(f"expected owner/name, got {value!r}")
    return parts[0], parts[1]


def main():
    ap = argparse.ArgumentParser(description="Collect repository contribution data.")
    ap.add_argument("repo", help="owner/name or a GitHub URL")
    ap.add_argument("--merged", type=int, default=40, help="merged sample size (design D3)")
    ap.add_argument("--unmerged", type=int, default=20, help="closed-unmerged sample size")
    ap.add_argument("--out", help="write JSON here instead of stdout")
    args = ap.parse_args()

    try:
        owner, name = parse_slug(args.repo)
    except ValueError as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 1

    try:
        result = collect(owner, name, args.merged, args.unmerged)
    except Inaccessible as exc:
        print(f"error: {owner}/{name} is inaccessible with the current credential.\n"
              f"  Collection halted; no further requests made.\n  detail: {exc}",
              file=sys.stderr)
        return 3
    except RateLimited as exc:
        print(f"error: rate limit exhausted before collection began: {exc}", file=sys.stderr)
        return 2

    text = json.dumps(result, indent=2)
    if args.out:
        open(args.out, "w").write(text)
        s = result["sample"]
        print(f"collected {s['merged_actual']}/{s['merged_requested']} merged, "
              f"{s['unmerged_actual']}/{s['unmerged_requested']} unmerged -> {args.out}")
        for note in result["notes"]:
            print(f"  note: {note}")
    else:
        print(text)
    return 0


if __name__ == "__main__":
    sys.exit(main())
