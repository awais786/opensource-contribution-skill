---
name: find-issues
description: Use when looking for open source repos with good issues to work on
---

# Find Trending Open Source Repositories

Find trending GitHub repositories where you can contribute. Shows repos ranked by activity and quality.

## Quick Start

```bash
/find-issues                                  # Show trending repos from last 7 days
/find-issues --days 30 --topic web            # Filter by recency and topic
/find-issues --language rust --min-stars 100  # Focus on Rust, established projects
```

## Command Options

| Option | Values | Default | Purpose |
|--------|--------|---------|---------|
| `--days` | 1, 3, 7, 14, 30 | 7 | Time window for trending repos |
| `--min-stars` | Any number | 0 | Minimum stars (quality filter) |
| `--topic` | web, rust, cli, database, etc. | (none) | GitHub topic to focus on |
| `--language` | python, rust, javascript, go, etc. | (none) | Single language filter |
| `--no-cache` | (flag) | false | Skip 2-hour cache, get fresh data |
| `--exclude-pattern` | Pattern string | (none) | Skip repos matching pattern |

## Common Workflows

### "Show me what's trending right now"
```bash
/find-issues
```
Shows trending repos from the last 7 days with their top 10 issues.

### "Find easy starter projects"
```bash
/find-issues --days 30 --min-stars 50
```
Established, active projects (good for learning).

### "What's hot in web development?"
```bash
/find-issues --topic web --days 14 --min-stars 100
```
Top web frameworks and tools from the last 2 weeks.

### "Find trending Rust projects"
```bash
/find-issues --language rust --days 30
```
All trending Rust repos with established activity.

### "Get fresh data immediately"
```bash
/find-issues --no-cache
```
Skip the 2-hour cache, query GitHub API right now.

## What You'll See

### Trending Repos Table
| Rank | Repo | Stars | Description | Language | Last Commit |
|------|------|-------|-------------|----------|------------|
| 1 | anthropic/anthropic-sdk-python | 2,340 | Python SDK for Anthropic API | Python | 2026-07-29 |
| 2 | vercel/next.js | 890 | React framework with routing | TypeScript | 2026-07-28 |
| 3 | rust-lang/rust | 750 | Rust programming language | Rust | 2026-07-28 |

### Statistics Section
- **Total repos found:** 15
- **Total stars:** 45,230 ⭐
- **Average stars/repo:** 3,015
- **Languages:** TypeScript, Python, Rust, Go, Java
- **Generated:** 2026-07-29 12:45 UTC
- **Cache:** fresh (just queried)

## How It Works

1. **Queries GitHub** — Searches for repos created in the last N days
2. **Filters by quality** — Uses stars, activity, language as signals
3. **Lists top issues** — Shows recently updated issues with labels like "good first issue"
4. **Caches results** — 2-hour TTL for speed; use `--no-cache` for fresh data
5. **Formats for readability** — Claude Haiku formats output as clean markdown

## Performance

- **Fresh query:** ~$0.001 per run (uses Claude Haiku for formatting)
- **Cached results:** Free & instant (2-hour TTL)
- **GitHub API:** Requires `gh` CLI installed and authenticated

## Setup Required

```bash
# Install GitHub CLI if not present
brew install gh        # macOS
sudo apt install gh    # Linux
choco install gh       # Windows

# Authenticate with GitHub
gh auth login
gh auth status  # Verify it's working
```

## Examples by Use Case

### 🚀 "I want to contribute to cutting-edge projects"
```bash
/find-issues --days 1 --min-stars 50
```
Brand new projects trending today (risky but cutting-edge).

### 🎯 "I want to start with good first issues"
```bash
/find-issues --days 7
# Look for "good first issue" label in the output
```
Trending repos with explicitly easy entry points.

### 📚 "I want to learn from active projects"
```bash
/find-issues --min-stars 100 --days 30
```
Established, actively-maintained projects good for learning.

### 🔗 "I want to work in my favorite tech stack"
```bash
/find-issues --language python --days 14
/find-issues --language rust --days 30
/find-issues --topic database --min-stars 75
```
Focus on technology you know.

### 🔄 "I want fresh trending data"
```bash
/find-issues --no-cache
```
Latest from GitHub, no cached results.

## Important Notes

### ⚠️ Setup is REQUIRED

**This command will fail without GitHub CLI:**
```bash
gh auth login
gh auth status  # Verify authentication works
```

**No setup = No results.** The command cannot work without `gh` and valid authentication.

### 🎯 What Each Filter Does

| Filter | Effect | Example |
|--------|--------|---------|
| `--days 7` | Only repos created in last 7 days | Newer repos, faster-moving trends |
| `--min-stars 100` | Only repos with 100+ stars | Established projects, lower discovery risk |
| `--topic web` | Only repos tagged with "web" topic | Focused domain area |
| `--language python` | Only Python repos | Single language only |
| `--no-cache` | Fresh GitHub query right now | Skip the 2-hour cache |

### ❓ Common Misunderstandings

| Misconception | Reality |
|---|---|
| "It shows issues from repos" | No. It shows trending repos with stats. Visit the repo links to browse issues. |
| "Lower --min-stars = easier to contribute" | Not true. Low stars = less mature code. Use `--min-stars 50+` for quality. |
| "--days 1 finds the hottest projects" | Yes, but they're new/risky. Use `--days 7+` for stability. |
| "I don't need `gh` installed" | Wrong. Command requires GitHub CLI and authentication. |
| "Cached results are stale" | 2-hour cache is fresh enough for most use cases. Use `--no-cache` only if needed. |
| "Multiple `--language` filters work" | No. Only ONE language at a time. Use `--topic` for broader categories. |

## Troubleshooting

| Problem | Solution |
|---------|----------|
| **"gh command not found"** | Install GitHub CLI (see Setup Required above) |
| **"Not authenticated"** | Run `gh auth login` then `gh auth status` to verify |
| **"No repos found"** | Try `--days 30` (broader window) or remove `--min-stars` filter |
| **"No issues shown"** | Repo may have zero open issues; try `--no-cache` for fresh data |
| **"Getting stale cached results"** | Use `--no-cache` to bypass 2-hour cache immediately |
| **"GitHub API rate limit exceeded"** | Wait 1 hour or authenticate with `gh auth login` |
| **"Only one repo's issues shown"** | This is correct behavior. Use `--exclude-pattern` to skip repos and get the next top result |

## Red Flags — STOP and Check Setup

If you see any of these, something is wrong:

- **"Command not found: /find-issues"** → Command file not created; ask for `/find-issues` to be wired up
- **"gh not found"** → GitHub CLI not installed; run `brew install gh` or equivalent
- **"Not authenticated"** → Run `gh auth login` before trying again
- **"Empty results every time"** → Check GitHub CLI is working with `gh auth status`
- **"Same results after hours"** → Cache is working correctly; use `--no-cache` to refresh
- **"Trying multiple `--language` filters"** → Only one language at a time supported

## Next Steps

1. **Run the command** — See what's trending
2. **Pick a repo** — Look for "good first issue" or "help-wanted" labels
3. **Click the link** — Read the issue description
4. **Start contributing** — Fork and submit your PR!

---

**Cache location:** `~/.oss-contributor/cache/` (2-hour TTL)  
**Source script:** `skills/oss-contributor/scripts/trending-digest.sh`  
**Reference:** See `superpowers:writing-skills` for skill authoring
