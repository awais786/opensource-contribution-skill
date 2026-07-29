# opensource-contribution-skill

**Find trending open source repositories where you can start contributing. Discover quality projects ranked by activity and community engagement.**

## Status: ✅ Production Ready

The `/find-issues` skill is fully tested and operational. All features working:
- ✅ GitHub API integration with smart caching
- ✅ Multi-language and topic filtering
- ✅ Cross-platform support (macOS/Linux)
- ✅ Input validation and error handling
- ✅ Comprehensive command documentation

## Quick Start

### 1. Setup (one-time)

```bash
# Install GitHub CLI if you don't have it
brew install gh        # macOS
sudo apt install gh    # Linux
choco install gh       # Windows

# Authenticate with GitHub
gh auth login
gh auth status  # Verify it works
```

### 2. Use the Skill

```bash
# Find trending repos from the last 7 days
/find-issues

# With filters
/find-issues --days 30 --topic web --min-stars 100
/find-issues --language rust
/find-issues --language python --min-stars 50 --days 14
```

## What You Get

**Trending Repos Table:**
```
| Rank | Repo | Stars | Description | Language | Last Commit |
|------|------|-------|-------------|----------|------------|
| 1 | owner/repo-name | 2,340 | Brief description... | Python | 2026-07-29 |
| 2 | owner/another-repo | 890 | Feature-rich library | TypeScript | 2026-07-28 |
| ... | ... | ... | ... | ... | ... |

📈 Statistics
- Repos found: 15
- Total stars: 17,581 ⭐
- Avg stars/repo: 1,172
- Languages: TypeScript, Python, Rust, Go, Java
```

## Command Options

| Option | Values | Default | Purpose |
|--------|--------|---------|---------|
| `--days` | 1, 3, 7, 14, 30 | 7 | Time window for trending repos |
| `--min-stars` | Any number | 0 | Minimum stars (quality filter) |
| `--topic` | web, rust, cli, database, javascript, python, etc. | (none) | GitHub topic to focus on |
| `--language` | python, javascript, rust, go, java, etc. | (none) | Single language filter |
| `--no-cache` | (flag) | false | Skip 2-hour cache, get fresh data |
| `--exclude-pattern` | Pattern string | (none) | Skip repos matching pattern |

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
Established projects with active development.

### "What's hot in web development?"
```bash
/find-issues --topic web --min-stars 100 --days 14
```
Trending web frameworks and tools.

### "Find Rust projects"
```bash
/find-issues --language rust --days 30
```
All trending Rust repos with established activity.

### "Get cutting-edge projects"
```bash
/find-issues --days 1 --min-stars 50
```
Brand new projects trending today (higher risk, but cutting-edge).

### "Skip cache for fresh data"
```bash
/find-issues --no-cache
```
Query GitHub API immediately instead of using 2-hour cache.

## Cost & Performance

- **Fresh query:** ~$0.001 per run (uses Claude Haiku for formatting)
- **Cached results:** Free & instant (2-hour TTL)
- **GitHub API:** No cost, rate limited by authentication
- **Speed:** Cached results return instantly; fresh queries take ~2-3 seconds

## Troubleshooting

| Problem | Solution |
|---------|----------|
| **"gh command not found"** | Install GitHub CLI (see Setup above) |
| **"Not authenticated"** | Run `gh auth login` then `gh auth status` to verify |
| **"No repos found"** | Try `--days 30` (broader window) or remove `--min-stars` filter |
| **"Getting stale cached results"** | Use `--no-cache` to bypass cache and query GitHub immediately |
| **"GitHub API rate limit"** | Wait 1 hour or authenticate with `gh auth login` |
| **"Multiple `--language` filters don't work"** | Only ONE language at a time supported; use `--topic` for broader categories |

## Next Steps

1. **Run the command** — `"/find-issues"` to see what's trending
2. **Pick a repo** — Look for one that interests you
3. **Visit the repo** — Click the repo link to explore
4. **Browse issues** — Find issues labeled "good first issue" or "help-wanted"
5. **Start contributing** — Fork the repo and submit your first PR!

## Project Structure

```
opensource-contribution-skill/
├── .claude/
│   ├── commands/
│   │   └── find-issues.md          # Command definition & documentation
│   └── settings.local.json          # Project settings
├── skills/
│   └── oss-contributor/
│       ├── SKILL.md                 # Skill metadata
│       ├── CLAUDE.md                # Usage guide
│       ├── scripts/
│       │   ├── trending-digest.sh   # Main implementation
│       │   ├── collect.py           # Data collection helpers
│       │   ├── store.py             # Cache management
│       │   └── preflight.py         # Setup verification
│       └── references/              # Additional docs
├── README.md                        # This file
└── SKILL-REVIEW-FORMAL.md          # Formal skill review

```

## How It Works

1. **Queries GitHub** — Searches for repos created in the last N days using `gh search repos`
2. **Filters by quality** — Uses stars, activity, language, and topics as signals
3. **Formats output** — Claude Haiku formats results as clean, scannable markdown
4. **Caches results** — Saves for 2 hours to avoid unnecessary API calls
5. **Provides stats** — Shows aggregates: total repos, total stars, language distribution

## Implementation Details

- **Language:** Bash (trending-digest.sh) + Python (formatting)
- **Dependencies:** GitHub CLI (`gh`), Python 3.6+
- **Cache location:** `~/.oss-contributor/cache/`
- **Cache TTL:** 2 hours (7200 seconds)
- **Model:** Claude Haiku for output formatting
- **API:** GitHub REST API via `gh search repos`

## Testing

All functionality has been tested and verified:
- ✅ Basic repo trending
- ✅ Language filtering (single language)
- ✅ Topic filtering
- ✅ Star count filtering
- ✅ Cache functionality (2-hour TTL)
- ✅ Input validation (non-negative integers)
- ✅ Cross-platform support (macOS/Linux)
- ✅ Python 3.12+ compatibility

## Contributing

To improve this skill:
1. Test edge cases with different filters
2. Report issues or suggestions in discussions
3. PRs welcome for bug fixes and enhancements

**Happy contributing!** 🚀
