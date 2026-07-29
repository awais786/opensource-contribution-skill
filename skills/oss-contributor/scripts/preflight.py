#!/usr/bin/env python3
"""Verify prerequisites and rate-limit budget before an area runs.

Checks, in order: gh installed, gh authenticated, and enough GraphQL budget
for the requested area. Exits non-zero with setup instructions on failure
rather than letting an area degrade silently.

Per-area cost estimates come from design D5. They are estimates; task 11.7
replaces them with measured values.
"""

import argparse
import json
import shutil
import subprocess
import sys
from datetime import datetime, timezone

# Estimated GraphQL point cost per area (design D5).
AREA_COSTS = {
    "profile": 0,          # no GitHub access
    "targets": 80,         # verify one repository
    "health": 80,          # one repository
    "orientation": 30,     # one repository, local clone preferred
    "pr-quality": 20,      # reuses health collection via cache
    "collaboration": 20,   # reuses health collection via cache
    "issues-watchlist": 200,   # bounded: ~N targets
    "issues-unscoped": 600,    # unbounded in principle; this is a floor
    "discovery": 600,      # search + health on top 10
    "portfolio": 150,      # user's own events feed
    "resources": 200,      # verification of curated repositories
}
DEFAULT_COST = 200


def fail(message, code=1):
    print(message, file=sys.stderr)
    return code


def check_gh_installed():
    if shutil.which("gh"):
        return None
    return fail(
        "error: the gh CLI is not installed.\n\n"
        "  macOS    brew install gh\n"
        "  Linux    https://github.com/cli/cli#installation\n"
        "  Windows  winget install --id GitHub.cli\n\n"
        "Then authenticate with:  gh auth login"
    )


def check_gh_authenticated():
    proc = subprocess.run(["gh", "auth", "status"], capture_output=True, text=True)
    if proc.returncode == 0:
        return None
    return fail(
        "error: gh is installed but not authenticated.\n\n"
        "Run:  gh auth login\n\n"
        "An authenticated token is required. The unauthenticated limit of\n"
        "60 requests/hour cannot support any area of this skill."
    )


def read_budget():
    proc = subprocess.run(["gh", "api", "rate_limit"], capture_output=True, text=True)
    if proc.returncode != 0:
        return None, None, proc.stderr.strip()
    try:
        data = json.loads(proc.stdout)
    except json.JSONDecodeError as exc:
        return None, None, str(exc)
    graphql = data.get("resources", {}).get("graphql", {})
    return graphql.get("remaining"), graphql.get("reset"), None


def main():
    ap = argparse.ArgumentParser(description="Verify prerequisites for an area.")
    ap.add_argument("--area", default=None,
                    help=f"one of: {', '.join(sorted(AREA_COSTS))}")
    ap.add_argument("--json", action="store_true", help="emit machine-readable output")
    args = ap.parse_args()

    if args.area == "profile":
        # The profile area touches no GitHub API; gh is not required for it.
        result = {"ok": True, "area": "profile", "requires_github": False}
        print(json.dumps(result) if args.json else "preflight ok: profile area needs no GitHub access")
        return 0

    for check in (check_gh_installed, check_gh_authenticated):
        code = check()
        if code:
            return code

    remaining, reset, err = read_budget()
    if err or remaining is None:
        return fail(f"error: could not read rate limit status from the GitHub API.\n  {err or ''}")

    required = AREA_COSTS.get(args.area, DEFAULT_COST)
    reset_human = (
        datetime.fromtimestamp(reset, tz=timezone.utc).astimezone().strftime("%Y-%m-%d %H:%M:%S")
        if reset else "unknown"
    )

    if remaining < required:
        return fail(
            "error: insufficient GitHub GraphQL rate-limit budget.\n\n"
            f"  area:      {args.area or 'unspecified'}\n"
            f"  remaining: {remaining}\n"
            f"  required:  ~{required}\n"
            f"  resets at: {reset_human}\n\n"
            "Wait for the reset, or reduce the sample size:\n"
            "  python3 scripts/collect.py <owner/repo> --merged 20 --unmerged 10",
            code=2,
        )

    if args.json:
        print(json.dumps({
            "ok": True, "area": args.area, "requires_github": True,
            "remaining": remaining, "required": required, "reset_at": reset_human,
        }))
    else:
        print(f"preflight ok: gh authenticated, graphql budget {remaining} "
              f"(area '{args.area or 'unspecified'}' needs ~{required})")
    return 0


if __name__ == "__main__":
    sys.exit(main())
