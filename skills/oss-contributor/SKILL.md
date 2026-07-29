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
- Seeing which issues are actually unclaimed before you start
- Exploring a specific repo's issues before contributing

## Quick Start

```bash
# Today's trending repos for a language
/find-repos --language python
/find-repos --language rust

# Fresh data, bypassing the 2-hour cache
/find-repos --no-cache

# Deep dive into a specific repo
/repo-details owner/repo
```

`--language` and `--no-cache` are the only options.

## What It Does

- 🔥 **Scrapes GitHub's trending page** — Fast, reliable trending data
- 📋 **Shows up to 10 available issues per repo** — Open, unassigned, and not pull requests
- ⚡ **Caches results** — 2-hour TTL for speed, keyed per language
- 🔗 **Clickable links** — Direct repo and issue links for instant navigation

## Setup

**No setup required** — works out of the box with Python 3.

**Optional: Add a GitHub token to raise the API rate limit**

Without token: 60 API requests/hour — enough for a handful of runs before 403s
With token: 5000 API requests/hour

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

| Setup | Fresh query | Issue detail |
|-------|-------------|--------------|
| No token | ~5-15s | ✅ Works, until the 60/hr limit is hit |
| With GitHub token | ~5-15s | ✅ Works, 5000/hr limit |
| Cached repo list | ~2-10s | ✅ Skips the scrape, still fetches issues |

## Configuration

- **Method:** GitHub trending page web scraping (fast, no API key needed initially)
- **Caching:** Smart 2-hour TTL at `~/.oss-contributor/cache/`
- **Cost:** Free (no API calls for scraping; optional GitHub token for issues)
- **Speed:** Instant for cached; 4-20s for fresh queries (depends on token)

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| "No repos found" | That language has no trending entries today; try another, or `--no-cache` |
| "Issues show as (Could not fetch)" | Usually rate limiting — run `gh auth login` |
| "No open, unassigned issues found" | Not an error: every open issue there is already claimed |
| "Repos are old/stale" | Use `--no-cache` to bypass 2-hour cache and get fresh data |
| "Want to find good first issues" | Run `/repo-details owner/repo` — it shows each issue's labels |

## Related Skills

- **`repo-details`** — Deep dive into a specific repo: stats, description, and top 10 issues
- Use `/find-repos` to discover trending projects, then `/repo-details owner/repo` to explore
