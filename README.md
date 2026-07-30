# opensource-contribution-skill

**Find and explore open source repositories where you can start contributing.**

Two complementary skills:
- **`/find-repos`** — Discover trending repositories (language, stars, activity)
- **`/repo-details owner/repo`** — Deep dive into a specific repo (stats, top 10 issues, getting started)

## Status: ✅ Production Ready

All skills fully tested and operational:
- ✅ `/find-repos` command working — discover trending repos by language
- ✅ `/repo-details owner/repo` command working — explore specific repos
- ✅ GitHub trending page scraping (fast, reliable)
- ✅ Repository details with GitHub API
- ✅ Smart 2-hour caching per language
- ✅ Unassigned-only issue filtering (50-item fetch → 10 shown)
- ✅ Cross-platform support (macOS/Linux)
- ✅ Security: quoted heredocs, argument validation
- ✅ Comprehensive documentation and examples

## Quick Start

### 1. Setup (optional)

Nothing is required — Python 3 is the only dependency and both commands work
unauthenticated. A GitHub token only raises the API rate limit from 60
requests/hour to 5000:

```bash
# Install GitHub CLI if you don't have it
brew install gh        # macOS
sudo apt install gh    # Linux
choco install gh       # Windows

# Authenticate — the scripts auto-detect this token
gh auth login
gh auth status  # Verify it works
```

### 2. Use the Commands

**Step 1: Find Trending Repos**
```bash
# Today's trending Python repos
/find-repos

# A different language
/find-repos --language rust

# Skip the 2-hour cache
/find-repos --no-cache
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

## Top 10 Open Issues by Repository
(Unassigned issues only - no pull requests)
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
(Unassigned issues only - no pull requests - with labels and direct GitHub links)

## Getting Started
1. Clone and explore
2. Find issues to work on
3. Setup development environment
4. Submit your first PR
```

## Command Options

| Option | Values | Default | Purpose |
|--------|--------|---------|---------|
| `--language` | python, javascript, rust, go, java, etc. | python | Which GitHub trending page to scrape |
| `--no-cache` | (flag) | false | Skip 2-hour cache, get fresh data |

These are the only options. GitHub's trending page is already ranked and scoped
to the last day, so there is nothing to filter by stars, topic, or time window.

## Common Workflows

### "Show me what's trending right now"
```bash
/find-repos
```
Today's trending Python repos.

### "Find Rust projects"
```bash
/find-repos --language rust
```

### "Skip cache for fresh data"
```bash
/find-repos --no-cache
```
Re-scrape now instead of using the 2-hour cache.

### "Which issues can I actually take?"
```bash
/repo-details owner/repo
```
Only open, unassigned, non-PR issues are listed — so nothing you see is
already claimed by someone else.

## Cost & Performance

- **Fresh query:** free; ~5-15s (scrape + 10 parallel issue fetches)
- **Cached repo list:** 2-hour TTL, per language
- **GitHub API:** No cost. 60 requests/hour unauthenticated, 5000 authenticated

## Troubleshooting

| Problem | Solution |
|---------|----------|
| **"No repos found"** | That language has no trending entries today; try another or `--no-cache` |
| **"No open, unassigned issues found"** | Not an error — every open issue there is already claimed |
| **"Could not fetch issues: HTTP Error 403"** | Rate limited; run `gh auth login` for the 5000/hr limit |
| **"repo must be in owner/repo form"** | `/repo-details` takes a slug, not a URL |
| **"Getting stale cached results"** | Use `--no-cache` to bypass cache and query GitHub immediately |
| **"Multiple `--language` filters don't work"** | Only ONE language at a time is supported |

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
1. **Scrapes GitHub trending** — Gets the top 10 repos for the chosen language, in GitHub's own order
2. **Fetches issues in parallel** — 5 concurrent requests across the 10 repos
3. **Filters to available work** — Asks the API for `assignee=none`, then drops pull requests
4. **Caches the repo list** — 2-hour TTL, keyed per language
5. **Shows stats** — Repos found, generation time, cache status

### /repo-details Command
1. **Fetches repo metadata** — GitHub API: stars, forks, language, description
2. **Retrieves up to 10 issues** — Open, unassigned, non-PR, sorted by update time
3. **Shows labels** — Quick filtering: `bug`, `enhancement`, `good first issue`, etc.
4. **Provides setup guide** — Clone, develop, and contribute instructions
5. **Direct GitHub links** — Click any issue to read full details

## Implementation Details

### find-repos Command
- **Script:** `find-repos.sh` (Bash + Python)
- **Method:** Web scraping GitHub's trending page (no API key needed)
- **Cache:** 2-hour TTL at `~/.oss-contributor/cache/trending/`
- **Optional:** GitHub token raises the issue-fetch rate limit

### repo-details Command
- **Script:** `repo-details.sh` (Bash + Python)
- **API:** GitHub REST API (works unauthenticated)
- **Speed:** ~2-3 seconds per query (not cached)
- **Input:** a plain `owner/repo` slug; anything else is rejected

### Common
- **Dependencies:** Python 3.6+. GitHub CLI (`gh`) optional, for the token only
- **Cache location:** `~/.oss-contributor/cache/`
- **Platforms:** macOS, Linux
- **Issue filter:** open + unassigned + not a pull request

The scripts request 50 issues and filter down to 10, rather than requesting 10
and filtering those — GitHub's issues endpoint returns pull requests in the same
list, so filtering a 10-item page would leave a busy repo showing almost nothing.

## Testing

Verified manually against live GitHub:
- ✅ Basic repo trending
- ✅ Language selection (`--language rust` scrapes and caches Rust separately)
- ✅ Cache functionality (2-hour TTL, per-language cache files)
- ✅ Issue filtering (PRs and assigned issues excluded)
- ✅ Empty results distinguished from fetch failures
- ✅ Input validation (`owner/repo` slug enforced)
- ✅ Cross-platform support (macOS/Linux `stat`)
- ✅ Python 3.12+ compatibility

## Contributing

To improve this skill:
1. Test edge cases with different filters
2. Report issues or suggestions in discussions
3. PRs welcome for bug fixes and enhancements

**Happy contributing!** 🚀
