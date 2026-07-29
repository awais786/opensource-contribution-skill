---
name: oss-contributor
description: Use when finding open source repos with good issues to work on—searches trending projects, filters for quality, and shows community activity.
---

# oss-contributor

Find trending open source repositories where you can start contributing.

## Status: ✅ Production Ready

All features implemented and tested:
- Multi-language and topic filtering
- Smart 2-hour caching
- Cross-platform support (macOS/Linux)
- Input validation and error handling

## Quick Start

```bash
# Find trending repos from last 7 days
/find-issues

# With filters
/find-issues --days 30 --topic web --min-stars 100
/find-issues --language rust --days 14
```

## Routes

| Task | Command | Docs |
|---|---|---|
| Find trending repos by activity | `/find-issues` | `.claude/commands/find-issues.md` |
| Filter by language | `/find-issues --language python` | Same |
| Filter by topic | `/find-issues --topic web` | Same |
| Filter by stars (quality) | `/find-issues --min-stars 100` | Same |
| Get fresh data (skip cache) | `/find-issues --no-cache` | Same |

## Setup Required

```bash
# Install GitHub CLI
brew install gh        # macOS
sudo apt install gh    # Linux
choco install gh       # Windows

# Authenticate
gh auth login
gh auth status  # Verify it works
```

## Configuration

- **Model:** Claude Haiku for output formatting (~$0.001 per fresh query)
- **Caching:** Smart 2-hour TTL at `~/.oss-contributor/cache/`
- **Cost:** ~$0.001 per fresh query; cached results free
- **Speed:** Instant for cached; ~2-3s for fresh queries

## Testing

✅ All features tested and verified:
- Repo trending and sorting
- Language filtering
- Topic filtering  
- Star count filtering
- Cache functionality
- Input validation
- Cross-platform (macOS/Linux)
- Python 3.12+ compatibility
