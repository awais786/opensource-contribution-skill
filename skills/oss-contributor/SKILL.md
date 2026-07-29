---
name: oss-contributor
description: Use when finding open source repos with good issues to work on—searches trending projects, filters for quality, and shows top 10 issues.
---

# oss-contributor

Find good open source repos and their top 10 issues in one command.

## Quick Start

```bash
# Find trending repos + show top 10 issues
/find-issues

# With filters
/find-issues --days 30 --topic web --min-stars 100
```

## Routes

| Ask | Command | Reference |
|---|---|---|
| Find trending repos & their top 10 issues | find-issues | `references/00-repo-and-issues.md` |

## Setup

```bash
gh auth login
gh auth status  # Verify
```

## Model Configuration

Uses Claude Haiku for formatting (~$0.001 per run, cached results free).

## State

Cache: `~/.oss-contributor/cache/` (2-hour TTL)
