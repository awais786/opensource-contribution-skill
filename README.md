# opensource-contribution-skill

Find trending open source projects and make smarter contributions with Claude Code.

## Installation

```bash
# 1. Copy skill to Claude Code
cp -r skills/oss-contributor ~/.claude/skills/

# 2. Authenticate with GitHub
gh auth login
gh auth status  # Verify

# 3. Use in Claude Code (CLI, IDE extension, or claude.ai/code)
```

## How to Use

**In Claude Code terminal/chat:**

```
/trending-digest

/trending-digest --days 30 --topic web --min-stars 100 --stats-only
```

Or ask Claude directly:
```
Show me trending repos
Show me trending web frameworks
What's hot in Python right now?
```

## `/trending-digest` Command

**Options:**
- `--days N` — Time window (1, 3, 7, 14, 30) — default: 7
- `--min-stars N` — Minimum stars filter
- `--topic TAG` — Filter by topic (web, rust, cli, etc.)
- `--language LANG` — Single language (default: Python + non-Python)
- `--exclude-pattern` — Exclude repos (e.g., "awesome-*")
- `--sort FIELD` — Sort by stars, forks, watchers, or updated
- `--stats-only` — Show statistics only
- `--no-cache` — Fresh query (skip 2-hour cache)

**Examples:**

```bash
# Trending web frameworks
/trending-digest --topic web --days 30 --min-stars 100

# Show stats only
/trending-digest --stats-only

# Trending Rust sorted by recent activity
/trending-digest --language rust --sort updated

# Skip educational repos
/trending-digest --exclude-pattern "awesome-*"
```

## Typical Workflow

1. Find interesting projects
   ```bash
   /trending-digest --days 7 --min-stars 100
   ```

2. Evaluate project quality
   ```bash
   /repo-health microsoft/markitdown
   ```

3. Find issues to work on
   ```bash
   /issue-discovery microsoft/markitdown
   ```

4. Understand the codebase
   ```bash
   /codebase-orientation microsoft/markitdown
   ```

## Features

- **Smart filtering** — Time, topic, stars, language, patterns
- **Statistics** — Trending languages, average stars, distribution
- **Caching** — 2-hour cache for efficiency
- **Cost-effective** — Uses Claude Haiku (~$0.001 per query)
- **Rate limit safe** — Well under GitHub's API limits

## Setup Requirements

- GitHub CLI (`gh`) — [Install](https://cli.github.com/)
- GitHub authentication — `gh auth login`
- Claude Code

## Troubleshooting

**"No repos found"**
- Increase time window: `--days 30` instead of `--days 7`
- Remove or loosen filters
- Check topic name exists on GitHub

**"gh command not found"**
```bash
# macOS
brew install gh

# Linux
sudo apt install gh

# Windows
choco install gh
```

**"GitHub API unavailable"**
```bash
gh auth status
gh api rate_limit  # Check remaining quota
```

## Use Cases

- **Learning:** `--language rust --days 14 --sort updated`
- **Portfolio:** `--min-stars 200 --days 7` (established projects)
- **Trending:** `--days 30 --stats-only` (see landscape)
- **Hidden gems:** `--min-stars 50 --sort forks` (quality signals)

## FAQ

**How often to use this?**  
Weekly or as needed. Trending changes every few days.

**Does it cost money?**  
~$0.001 per fresh query. Cached results are free.

**How long is cache?**  
2 hours. Use `--no-cache` for fresh results immediately.

**Can I filter multiple topics?**  
Not yet. Run separate commands for each.

## Contributing

Ideas or bugs? Open an issue or PR.

## License

MIT

---

Built for open source developers. Happy contributing! 🚀
