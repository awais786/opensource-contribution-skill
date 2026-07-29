# Find Trending Open Source Repos

One command to discover trending repositories where you can contribute.

## Command

```bash
/find-issues
/find-issues --days 30 --topic web --min-stars 100
/find-issues --language rust --days 14
```

## What It Does

Queries GitHub for trending repositories created in the last N days, filters by quality signals (stars, language, topics), and shows results ranked by activity. All with smart 2-hour caching to save API quota.

## Options

| Option | Values | Default | Purpose |
|--------|--------|---------|---------|
| `--days` | 1, 3, 7, 14, 30 | 7 | Time window for trending repos |
| `--min-stars` | Non-negative integer | 0 | Minimum stars (quality filter) |
| `--topic` | web, rust, cli, database, etc. | (none) | GitHub topic to focus on |
| `--language` | python, rust, javascript, go, etc. | (none) | Single language (one only) |
| `--no-cache` | (flag) | false | Skip cache, query GitHub now |
| `--exclude-pattern` | Pattern string | (none) | Skip repos matching pattern |

## Example Output

```
## 📊 Trending Repos (Last 7 Days)

| Rank | Repo | Stars | Description | Language | Last Commit |
|------|------|-------|-------------|----------|------------|
| 1 | anthropic/anthropic-sdk-python | 2,340 | Python SDK for Anthropic API | Python | 2026-07-29 |
| 2 | vercel/next.js | 890 | React framework with routing | TypeScript | 2026-07-28 |
| 3 | rust-lang/rust | 750 | Rust programming language | Rust | 2026-07-28 |

## 📈 Statistics

- **Repos found:** 15
- **Total stars:** 17,581 ⭐
- **Avg stars/repo:** 1,172
- **Languages:** TypeScript, Python, Rust, Go, Java

**Generated:** 2026-07-29 13:10 UTC | **Cache:** fresh
```

## Common Workflows

### "Show me what's trending right now"
```bash
/find-issues
```
Last 7 days, all languages, all quality levels.

### "Find quality projects to learn from"
```bash
/find-issues --min-stars 100 --days 30
```
Established, actively-maintained projects.

### "Show me trending web frameworks"
```bash
/find-issues --topic web --min-stars 100 --days 30
```

### "What's hot in Rust?"
```bash
/find-issues --language rust --days 14
```

### "Find brand new cutting-edge projects"
```bash
/find-issues --days 1 --min-stars 50
```

## Options Explained

**--days:** Time window for trending
- `--days 1` = Brand new projects (highest risk, most cutting-edge)
- `--days 7` = Good balance (default)
- `--days 14` = 2 weeks of trends
- `--days 30` = Broad landscape (lower risk)

**--min-stars:** Quality filter
- `--min-stars 100` = Established projects
- `--min-stars 50` = Sweet spot (active + quality)
- `--min-stars 0` = Accept all trending (default)

**--topic:** Focus area
- Common: web, rust, cli, database, javascript, python
- Use GitHub's topic system (case-sensitive)

**--language:** Single language
- One language at a time only
- Use `--topic` for broader categories

**--no-cache:** Bypass caching
- 2-hour cache is default
- Use `--no-cache` for immediate fresh data

## Setup Required

```bash
# Install GitHub CLI
brew install gh        # macOS
sudo apt install gh    # Linux
choco install gh       # Windows

# Authenticate
gh auth login
gh auth status  # Verify
```

## Cost & Performance

- Fresh query: ~$0.001 (Haiku model for formatting)
- Cached results: Free & instant (2-hour TTL)
- Speed: Instant for cached; ~2-3s for fresh queries

## Troubleshooting

| Problem | Solution |
|---------|----------|
| "gh command not found" | Install GitHub CLI (see Setup Required above) |
| "Not authenticated" | Run `gh auth login` then `gh auth status` |
| "No repos found" | Try `--days 30` (broader window) or remove `--min-stars` filter |
| "Getting stale cached results" | Use `--no-cache` for immediate fresh data |
| "GitHub API rate limit" | Wait 1 hour or authenticate with `gh auth login` |
| "Multiple `--language` filters don't work" | Only ONE language at a time supported |

## Next Steps

1. **Run the command** — See what's trending
2. **Pick a repo** — Look for one that interests you
3. **Visit the repo** — Click the repo name to visit GitHub
4. **Browse issues** — Look for "good first issue" label
5. **Start contributing** — Fork and submit your first PR!

That's it. Simple workflow, real results. 🚀
