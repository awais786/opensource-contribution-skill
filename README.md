# opensource-contribution-skill

**Find and explore open source repositories where you can start contributing.**

Two complementary skills:
- **`/find-repos`** — Discover trending repositories (language, stars, activity)
- **`/repo-details owner/repo`** — Deep dive into a specific repo (stats, top 10 issues, getting started)

## Status: ✅ Production Ready

All skills fully tested and operational:
- ✅ GitHub trending page scraping (fast, reliable)
- ✅ Repository details with GitHub API
- ✅ Smart 2-hour caching
- ✅ Multi-language and topic filtering
- ✅ Cross-platform support (macOS/Linux)
- ✅ Comprehensive documentation
- ✅ Professional skill documentation (SDO-compliant)

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

### 2. Use the Commands

**Step 1: Find Trending Repos**
```bash
# Find trending repos from the last 7 days
/find-repos

# With filters
/find-repos --days 30 --topic web --min-stars 100
/find-repos --language rust
/find-repos --language python --min-stars 50 --days 14
```

**Step 2: Explore a Specific Repo**
```bash
# Get detailed info for a repo you found
/repo-details sgl-project/sglang
/repo-details fastapi/fastapi
/repo-details owner/repo-name
```

## What You Get

### From `/find-repos` Command

**Trending Repos List with Clickable Links:**
```
## Trending Python Repositories (Daily)

| Rank | Repo Link |
|------|-----------|
| 1 | [polarsource/polar](https://github.com/polarsource/polar) |
| 2 | [huggingface/speech-to-speech](https://github.com/huggingface/speech-to-speech) |
| 3 | [fastapi/fastapi](https://github.com/fastapi/fastapi) |
| ... | ... |

## Top 10 Issues per Repo
(Shows 10 recent issues with direct links for each trending repo)
```

### From `/repo-details owner/repo` Command

**Detailed Repository Information:**
```
# sglang
📍 [sgl-project/sglang](https://github.com/sgl-project/sglang)

## Project Stats:
- ⭐ 30,926 stars | 📁 7,495 forks | 🐍 Python
- 📋 4,701 open issues (active development)

## Top 10 Issues to Work On
(Recent issues with labels and direct GitHub links)

## Getting Started
1. Clone and explore
2. Find issues to work on
3. Setup development environment
4. Submit your first PR
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
Trending web frameworks and tools.

### "Find Rust projects"
```bash
/find-repos --language rust --days 30
```
All trending Rust repos with established activity.

### "Get cutting-edge projects"
```bash
/find-repos --days 1 --min-stars 50
```
Brand new projects trending today (higher risk, but cutting-edge).

### "Skip cache for fresh data"
```bash
/find-repos --no-cache
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

## Contribution Workflow

1. **Discover** — Run `/find-repos --language python` to see trending repos
2. **Explore** — Find a repo in the output that interests you
3. **Deep Dive** — Run `/repo-details owner/repo` to see details and top 10 issues
4. **Pick Issue** — Click an issue link to read full details on GitHub
5. **Contribute** — Fork the repo, code, and submit your first PR!

## Project Structure

```
opensource-contribution-skill/
├── .claude/
│   ├── commands/
│   │   ├── find-repos.md            # /find-repos command definition
│   │   └── repo-details.md          # /repo-details command definition
│   └── settings.local.json           # Project settings
├── skills/
│   └── oss-contributor/
│       ├── SKILL.md                  # find-repos skill metadata
│       ├── repo-details-SKILL.md     # repo-details skill metadata
│       ├── CLAUDE.md                 # Usage guide
│       └── scripts/
│           ├── find-repos.sh         # Find trending repositories
│           └── repo-details.sh       # Get details for specific repo
├── README.md                         # This file
└── CONTRIBUTING.md                   # Contribution guidelines (optional)
```

## How It Works

### /find-repos Command
1. **Scrapes GitHub trending** — Gets trending repos from GitHub's trending page
2. **Filters by criteria** — Language, stars, topic, activity level
3. **Fetches top 10 issues** — Shows recent issues for each repo with links
4. **Caches results** — 2-hour TTL to avoid rate limits
5. **Shows stats** — Total repos found, stars distribution

### /repo-details Command
1. **Fetches repo metadata** — GitHub API: stars, forks, language, description
2. **Retrieves top 10 issues** — Recent, open issues sorted by update time
3. **Shows labels** — Quick filtering: `bug`, `enhancement`, `good first issue`, etc.
4. **Provides setup guide** — Clone, develop, and contribute instructions
5. **Direct GitHub links** — Click any issue to read full details

## Implementation Details

### find-repos Command
- **Script:** `find-repos.sh` (Bash + Python)
- **Method:** Web scraping GitHub's trending page (no API key needed)
- **Cache:** 2-hour TTL at `~/.oss-contributor/cache/trending/`
- **Optional:** GitHub token speeds up issue fetching 4-5x

### repo-details Command
- **Script:** `repo-details.sh` (Bash + Python)
- **API:** GitHub REST API (requires authentication)
- **Speed:** ~2-3 seconds per query (not cached)
- **Requirements:** `gh auth login` for GitHub CLI token

### Common
- **Dependencies:** GitHub CLI (`gh`), Python 3.6+
- **Cache location:** `~/.oss-contributor/cache/`
- **Platforms:** macOS, Linux
- **Model:** Claude Haiku for formatting

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
