---
name: Find Trending Open Source Repos
description: Discover trending repositories where you can contribute—filter by language, stars, and topics
---

# Find Trending Open Source Repositories

Use this skill when you want to discover open source projects to contribute to. Shows trending repos ranked by activity and community engagement.

## Main Command

**`/find-repos`** — Find trending repos and show their top 10 issues

## Usage Examples

```bash
# Basic: Show trending repos & their top issues
/find-repos

# Filter by time window
/find-repos --days 30

# Filter by stars (quality)
/find-repos --min-stars 100

# Filter by topic
/find-repos --topic web

# Filter by language
/find-repos --language rust

# Combine filters
/find-repos --topic web --min-stars 50 --days 14

# Get issues from specific repo
/find-repos owner/repo

# Skip cache (fresh data)
/find-repos --no-cache
```

## How It Works

### Step 1: Find Trending Repos
- Searches GitHub for repos created in the last N days
- Filters by stars, language, and topics
- Returns top 10 results, ranked by stars

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
## 📊 Trending Python Repositories (Daily)

| Rank | Repo Link |
|------|-----------|
| 1 | [polarsource/polar](https://github.com/polarsource/polar) |
| 2 | [huggingface/speech-to-speech](https://github.com/huggingface/speech-to-speech) |

## 📋 Issues by Repository

### 1. polarsource/polar

- [chore: remove dead FileRepository.get_all_by_organization method](https://github.com/polarsource/polar/pull/13442)
- [chore: remove dead ResourceNotModified exception and handler](https://github.com/polarsource/polar/pull/13441)
- [chore: remove unused publish_members eventstream function](https://github.com/polarsource/polar/pull/13440)
...
```

## Workflow Tips

### Find easy starter issues
```bash
/find-repos
# Look for "good first issue" label in the output
```

### Explore trending in your favorite tech
```bash
/find-repos --language rust --days 14
/find-repos --topic web --min-stars 100
```

### Get established, active projects
```bash
/find-repos --min-stars 100 --days 30
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
- Try a different repo with `/find-repos owner/repo`

**"Getting old/cached results"**
- Use `--no-cache` for fresh data

## Related References

- `references/00-repo-and-issues.md` — Complete usage guide
- `references/00-trending-repos-digest.md` — Trending repos details
- `references/thresholds.yaml` — Default filter thresholds

## Next Steps

1. Run `/find-repos` to see trending repos
2. Pick a repo from the output
3. Find an issue labeled "good first issue" or "help-wanted"
4. Click the link and read the issue
5. Start contributing!

That's it. Simple workflow, real results. 🚀
