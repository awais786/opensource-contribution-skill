# Find Good Repos & Top Issues

One command to find trending repos and see their top 10 issues.

## Command

```bash
/find-issues
/find-issues --days 30 --topic web --min-stars 100
```

## What It Does

**Step 1: Find Good Repos**
- Trending repos (last 7-30 days)
- Quality filters: stars, activity, language
- Smart caching (2 hours)

**Step 2: Show Top 10 Issues**
- Lists issues by update date (most recent)
- Shows labels, comments count, complexity hints
- Ready to click and start work

## Options

```bash
--days N              # 1, 3, 7, 14, 30 (default: 7)
--min-stars N         # Minimum stars (default: 0)
--topic TAG           # Focus area: web, rust, cli, etc.
--language LANG       # Single language (default: Python + non-Python)
--exclude-pattern     # Skip repos (e.g., "awesome-*")
```

## Example Output

```
## 📊 Top Trending Repos (Last 7 Days)

| Rank | Repo | Stars | Language |
|------|------|-------|----------|
| 1 | anthropics/skills | 1,200 | Python |
| 2 | vercel/next.js | 890 | TypeScript |
| 3 | rust-lang/rust | 750 | Rust |

## 🎯 Top 10 Issues: anthropics/skills

| # | Title | Labels | Updated |
|---|-------|--------|---------|
| 1 | Add support for .doc files | enhancement, help-wanted | 2 days ago |
| 2 | Fix async error handling | bug | 5 days ago |
| 3 | Improve CLI performance | performance | 1 week ago |
...
| 10 | Update documentation | docs | 2 weeks ago |

**To get issues from another repo:**
/find-issues owner/repo
```

## Common Workflows

### "Show me trending web frameworks"
```bash
/find-issues --topic web --min-stars 100 --days 30
```

### "What's hot in Rust?"
```bash
/find-issues --language rust --days 14
```

### "Find easy starter issues"
```bash
/find-issues
# Look for "good first issue" label in output
```

## Options Explained

**--days:** Time window
- `--days 1` = Brand new projects (risky but cutting-edge)
- `--days 7` = Good balance (default)
- `--days 30` = Broad landscape

**--min-stars:** Quality filter
- `--min-stars 100` = Established projects
- `--min-stars 50` = Sweet spot (active + quality)
- No minimum = Accept all trending

**--topic:** Focus area
- Common: web, rust, cli, database, javascript, python
- Check GitHub topics for more

## Cost & Performance

- ~$0.001 per fresh query (Haiku model)
- Cached results: free & instant
- 2-hour cache per query

## Troubleshooting

**No repos found?**
- Use `--days 30` instead of 7
- Remove `--min-stars` filter
- Check topic name

**No issues shown?**
- Repo may have zero open issues
- Try another repo
- Run `/find-issues owner/repo` directly

**"gh command not found"**
```bash
# Install GitHub CLI
brew install gh        # macOS
sudo apt install gh    # Linux
choco install gh       # Windows
```

**Cached results?**
Use `--no-cache` for fresh data immediately:
```bash
/find-issues --no-cache
```

## Next Steps

1. **Run the command** — See trending repos
2. **Pick a repo** — Look for good first issues
3. **Click and contribute** — Start your PR!

That's it. Simple workflow, real results. 🚀
