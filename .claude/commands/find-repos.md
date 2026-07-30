---
name: find-repos
description: Use when looking for open source projects to contribute to, not knowing which ones are active or trending
argument-hint: "[--language <lang>] [--no-cache]"
allowed-tools: Bash(bash skills/oss-contributor/scripts/find-repos.sh:*)
---

# Find Trending Repositories

Discover active open source repositories where you can start contributing.

## Result

! bash skills/oss-contributor/scripts/find-repos.sh $ARGUMENTS

Present the output above to the user as-is, preserving the markdown tables and
links. Do not re-fetch anything from GitHub yourself — the script is the source
of truth. If the script reported a fetch error for a repo, say so plainly rather
than substituting your own guess at its issues.

## Quick Start

```bash
# Trending Python repos (the default)
/find-repos

# A different language
/find-repos --language rust

# Skip the 2-hour cache
/find-repos --no-cache
```

## Command Options

| Option | Values | Default | Purpose |
|--------|--------|---------|---------|
| `--language` | python, rust, javascript, go, etc. | python | Which GitHub trending page to scrape |
| `--no-cache` | (flag) | false | Skip the 2-hour cache, re-scrape now |

There are no other options. Trending data comes from GitHub's own trending page,
which is already ranked and scoped to the last day, so there is nothing to filter
by stars, topic, or time window.

## What You Get

- **10 Trending Repos** — Clickable links, in GitHub's trending order
- **Up to 10 Issues per Repo** — Open, unassigned, and not pull requests
- **Cached Results** — Fast, repeatable queries with a 2-hour TTL per language

Issues are filtered so what you see is genuinely available work: pull requests
are excluded, and so is anything already assigned to someone.

## Common Workflows

### "Show me what's trending right now"
```bash
/find-repos
```

### "Find Rust projects"
```bash
/find-repos --language rust
```

### "I looked an hour ago, give me fresh data"
```bash
/find-repos --no-cache
```

## Performance

- **Cached results:** <1 second (instant)
- **Fresh query:** ~5-15 seconds (scrape + 10 parallel issue fetches)
- **GitHub token:** Raises the API rate limit from 60/hr to 5000/hr

## Next Steps

1. Run `/find-repos --language python` to discover repos
2. Find one that interests you
3. Run `/repo-details owner/repo` to explore it deeper
4. Click an issue link to read full details
5. Start contributing!

## Setup

No setup needed! Python 3 works out of the box.

**Optional: add a GitHub token to avoid rate limits**
```bash
gh auth login
```
