---
name: find-repos
description: Use when looking for open source projects to contribute to, not knowing which ones are active or trending
---

# Find Trending Repositories

Discover active open source repositories where you can start contributing.

## Quick Start

```bash
# Find trending repos from last 7 days
/find-repos

# With filters
/find-repos --days 30 --topic web --min-stars 100
/find-repos --language rust
/find-repos --language python --min-stars 50 --days 14

# Then explore a specific repo
/repo-details owner/repo
```

## Command Options

| Option | Values | Default | Purpose |
|--------|--------|---------|---------|
| `--days` | 1, 3, 7, 14, 30 | 7 | Time window for trending repos |
| `--min-stars` | Any number | 0 | Minimum stars (quality filter) |
| `--topic` | web, rust, cli, database, etc. | (none) | GitHub topic to focus on |
| `--language` | python, rust, javascript, go, etc. | (none) | Single language filter |
| `--no-cache` | (flag) | false | Skip 2-hour cache, get fresh data |

## What You Get

- **15 Trending Repos** — Clickable links for each repository
- **Top 10 Issues per Repo** — Recent issues with direct GitHub links
- **Project Stats** — Stars, forks, language, open issue count
- **Cached Results** — Fast, repeatable queries with 2-hour TTL

## Common Workflows

### "Show me what's trending right now"
```bash
/find-repos
```
Last 7 days, all languages, all quality levels.

### "Find quality projects to learn from"
```bash
/find-repos --min-stars 100 --days 30
```
Established projects with active development.

### "What's hot in web development?"
```bash
/find-repos --topic web --min-stars 100 --days 14
```

### "Find Rust projects"
```bash
/find-repos --language rust --days 30
```

## Performance

- **Cached results:** <1 second (instant)
- **Fresh query:** ~2-3 seconds
- **GitHub token:** Makes it 4-5x faster

## Next Steps

1. Run `/find-repos --language python` to discover repos
2. Find one that interests you
3. Run `/repo-details owner/repo` to explore it deeper
4. Click an issue link to read full details
5. Start contributing!

## Setup

No setup needed! Python 3 works out of the box.

**Optional: Add GitHub token for faster performance**
```bash
gh auth login
```
