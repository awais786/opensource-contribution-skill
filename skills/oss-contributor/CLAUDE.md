---
name: Find Open Source Issues
description: Discover trending repos and their top 10 issues to contribute to
---

# Find Good Repos & Issues to Contribute

Use this skill when you want to find open source repositories with good issues to work on.

## Main Command

**`/find-issues`** — Find trending repos and show their top 10 issues

## Usage Examples

```bash
# Basic: Show trending repos & their top issues
/find-issues

# Filter by time window
/find-issues --days 30

# Filter by stars (quality)
/find-issues --min-stars 100

# Filter by topic
/find-issues --topic web

# Filter by language
/find-issues --language rust

# Combine filters
/find-issues --topic web --min-stars 50 --days 14

# Get issues from specific repo
/find-issues owner/repo

# Skip cache (fresh data)
/find-issues --no-cache
```

## How It Works

### Step 1: Find Trending Repos
- Searches GitHub for repos created in the last N days
- Filters by stars, language, and topics
- Returns top 10-15 results, ranked by stars

### Step 2: Show Top 10 Issues
- Lists the most recently updated issues
- Shows labels (help-wanted, good first issue, etc.)
- Displays comment counts and complexity hints
- Ready to click and contribute

## Options

| Option | Values | Default | Purpose |
|--------|--------|---------|---------|
| `--days` | 1, 3, 7, 14, 30 | 7 | Time window for trending repos |
| `--min-stars` | Any number | 0 | Minimum stars (quality filter) |
| `--topic` | web, rust, cli, database, etc. | (none) | Focus area (GitHub topics) |
| `--language` | python, rust, javascript, etc. | (none) | Single language filter |
| `--no-cache` | (flag) | false | Skip 2-hour cache, get fresh data |

## Output Example

```
## 📊 Trending Repos (Last 7 Days)

| Rank | Repo | Stars | Description | Language | Last Commit |
|------|------|-------|-------------|----------|------------|
| 1 | anthropics/skills | 1,200 | Python library for AI... | Python | 2026-07-29 |
| 2 | vercel/next.js | 890 | React framework | TypeScript | 2026-07-28 |

## 🎯 Top 10 Issues: anthropics/skills

| # | Title | Labels | Updated |
|---|-------|--------|---------|
| 1 | Add support for .doc files | enhancement, help-wanted | 2 days ago |
| 2 | Fix async error handling | bug | 5 days ago |
...
```

## Workflow Tips

### Find easy starter issues
```bash
/find-issues
# Look for "good first issue" label in the output
```

### Explore trending in your favorite tech
```bash
/find-issues --language rust --days 14
/find-issues --topic web --min-stars 100
```

### Get established, active projects
```bash
/find-issues --min-stars 100 --days 30
```

## Performance & Cost

- **Fresh query:** ~$0.001 per run (uses Claude Haiku for formatting)
- **Cached results:** Free & instant (2-hour TTL)
- **GitHub API:** Requires `gh` CLI installed and authenticated

## Setup Required

```bash
# Install GitHub CLI if not present
brew install gh        # macOS
sudo apt install gh    # Linux
choco install gh       # Windows

# Authenticate
gh auth login
gh auth status  # Verify
```

## Troubleshooting

**"gh command not found"**
- Install GitHub CLI (see Setup Required above)

**"No repos found"**
- Try `--days 30` instead of 7
- Remove `--min-stars` filter
- Check topic name spelling

**"No issues shown"**
- Repo may have zero open issues
- Try a different repo with `/find-issues owner/repo`

**"Getting old/cached results"**
- Use `--no-cache` for fresh data

## Related References

- `references/00-repo-and-issues.md` — Complete usage guide
- `references/00-trending-repos-digest.md` — Trending repos details
- `references/thresholds.yaml` — Default filter thresholds

## Next Steps

1. Run `/find-issues` to see trending repos
2. Pick a repo from the output
3. Find an issue labeled "good first issue" or "help-wanted"
4. Click the link and read the issue
5. Start contributing!

That's it. Simple workflow, real results. 🚀
