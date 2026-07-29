---
name: oss-contributor
description: Use when looking for open source projects to contribute to, not knowing which ones are active or trending
---

# oss-contributor

Discover active open source repositories and explore their issues to find contribution opportunities.

## When to Use

**Triggering symptoms:**
- "I want to contribute to open source but don't know which repos"
- "What's trending in Python/Rust/[language]?"
- "Show me repos with good first issues"
- "I found a repo—what are the top issues there?"

**Perfect for:**
- Discovering active projects (trending, not abandoned)
- Finding repos in your favorite tech stack
- Filtering by quality (stars, activity level)
- Exploring a specific repo's issues before contributing

## Quick Start

```bash
# Find trending repos from last 7 days
/find-repos --language python

# With filters
/find-repos --language rust --days 30
/find-repos --no-cache  # Fresh data

# Deep dive into a specific repo
/repo-details owner/repo
```

## What It Does

- 🔥 **Scrapes GitHub's trending page** — Fast, reliable trending data
- 📋 **Shows top 10 recent issues per repo** — Real issues you can work on
- ⚡ **Caches results** — 2-hour TTL for speed
- 🔗 **Clickable links** — Direct repo and issue links for instant navigation

## Setup

**No setup required** — works out of the box with Python 3.

**Optional: Add GitHub token for 4-5x faster performance**

Without token: ~18-20s (API rate-limited, no issue details)
With token: ~4-5s (full issue data fetched in parallel)

### How to Add Token

**Option 1: Auto-detect from GitHub CLI** (recommended)
```bash
gh auth login   # If not already authenticated
# Command auto-detects token from gh CLI
```

**Option 2: Export token manually**
```bash
export GITHUB_TOKEN="ghp_your_token_here"
```

Get a token: https://github.com/settings/tokens (scope: `repo`, `read:org`)

## Performance

| Setup | Time | Issues Detail |
|-------|------|---------------|
| No token (rate-limited) | 18-20s | ❌ Fails to load |
| With GitHub token | 4-5s | ✅ Shows all 10 issues |
| Cached results | <1s | ✅ Instant |

## Configuration

- **Method:** GitHub trending page web scraping (fast, no API key needed initially)
- **Caching:** Smart 2-hour TTL at `~/.oss-contributor/cache/`
- **Cost:** Free (no API calls for scraping; optional GitHub token for issues)
- **Speed:** Instant for cached; 4-20s for fresh queries (depends on token)

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| "No repos found" | Try `--days 30` instead of 7, or remove `--min-stars` filter |
| "Issues show as (Could not fetch)" | Add GitHub token with `gh auth login` for full issue data |
| "Repos are old/stale" | Use `--no-cache` to bypass 2-hour cache and get fresh data |
| "Want to find good first issues" | Run `/repo-details owner/repo` after finding trending repos |

## Related Skills

- **`repo-details`** — Deep dive into a specific repo: stats, description, and top 10 issues
- Use `/find-repos` to discover trending projects, then `/repo-details owner/repo` to explore
