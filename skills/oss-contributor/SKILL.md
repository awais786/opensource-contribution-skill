---
name: oss-contributor
description: Use when finding open source repos with good issues to work on—searches trending projects, filters for quality, and shows community activity.
---

# oss-contributor

Find trending open source repositories where you can start contributing.

## Status: ✅ Production Ready

All features implemented and tested:
- Web scraping for fast, reliable trending data
- Optional GitHub token for issue fetching
- Smart 2-hour caching
- Cross-platform support (macOS/Linux)
- No external dependencies (Python 3 built-in)

## Quick Start

```bash
# Find trending repos from last 7 days with issues
/find-issues --language python

# With filters
/find-issues --language rust --days 30
/find-issues --no-cache  # Fresh data
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
| With GitHub token | 4-5s | ✅ Shows all 5 issues |
| Cached results | <1s | ✅ Instant |

## Configuration

- **Method:** GitHub trending page web scraping (fast, no API key needed initially)
- **Caching:** Smart 2-hour TTL at `~/.oss-contributor/cache/`
- **Cost:** Free (no API calls for scraping; optional GitHub token for issues)
- **Speed:** Instant for cached; 4-20s for fresh queries (depends on token)
