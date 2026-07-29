---
name: Find Trending Open Source Repos
description: Discover trending repositories where you can contribute—filter by language, and see the open issues nobody has claimed
---

# Find Trending Open Source Repositories

Use this skill when you want to discover open source projects to contribute to. Shows trending repos and the open issues on them that nobody has claimed yet.

## Main Command

**`/find-repos`** — Find trending repos and show up to 10 available issues each

## Usage Examples

```bash
# Basic: trending Python repos & their available issues
/find-repos

# Pick a different language
/find-repos --language rust

# Skip cache (fresh data)
/find-repos --no-cache

# Deep dive into one repo
/repo-details owner/repo
```

## How It Works

### Step 1: Find Trending Repos
- Scrapes GitHub's own trending page for the chosen language (daily window)
- Keeps GitHub's ranking order and takes the top 10
- Caches the list for 2 hours, per language

### Step 2: Show Available Issues
- Fetches open issues for each repo in parallel
- Asks the API for unassigned issues only (`assignee=none`)
- Drops pull requests, which GitHub's issues endpoint returns alongside issues
- Shows up to 10 of what's left, most recently updated first

The over-fetch matters: the issues endpoint mixes PRs into the same list, so the
script requests 50 items and filters down to 10 rather than requesting 10 and
filtering those — otherwise a busy repo would show almost nothing.

## Options

| Option | Values | Default | Purpose |
|--------|--------|---------|---------|
| `--language` | python, rust, javascript, go, etc. | python | Which trending page to scrape |
| `--no-cache` | (flag) | false | Skip the 2-hour cache, get fresh data |

There are no other options. GitHub's trending page is already ranked and scoped
to the last day, so there is nothing to filter by stars, topic, or time window.

## Output Example

```
## 📊 Trending Python Repositories (Daily)

| Rank | Repo Link |
|------|-----------|
| 1 | [polarsource/polar](https://github.com/polarsource/polar) |
| 2 | [huggingface/speech-to-speech](https://github.com/huggingface/speech-to-speech) |

## 📋 Top 10 Open Issues by Repository
(Unassigned issues only - no pull requests)

### 1. polarsource/polar

- [Invariant checks hit Postgres statement timeout](https://github.com/polarsource/polar/issues/13433)
- [Benefit grant task not rolled back when sync payment fails](https://github.com/polarsource/polar/issues/13409)
...
```

## Workflow Tips

### Find easy starter issues
```bash
/find-repos
# Then run /repo-details on a repo you like — it shows labels such as
# "good first issue" and "help wanted"
```

### Explore trending in your favorite tech
```bash
/find-repos --language rust
/find-repos --language typescript
```

## Performance & Cost

- **Fresh query:** ~5-15s (scrape + 10 parallel issue fetches)
- **Cached results:** Free & instant (2-hour TTL)
- **GitHub API:** Works unauthenticated; a token raises the limit from 60/hr to 5000/hr

## Setup

None required. Python 3 is the only dependency.

**Optional — raise the API rate limit:**

```bash
# Install GitHub CLI if not present
brew install gh        # macOS
sudo apt install gh    # Linux
choco install gh       # Windows

gh auth login          # The scripts auto-detect this token
```

Or export one directly: `export GITHUB_TOKEN="ghp_..."`.

## Troubleshooting

**"No repos found"**
- GitHub's trending page may have no entries for that language; try another
- Use `--no-cache` in case a bad scrape was cached

**"No open, unassigned issues found"**
- Real result, not an error: every open issue on that repo is already claimed
- Try another repo from the list

**"(Could not fetch issues: HTTP Error 403)"**
- Rate limited. Run `gh auth login` for the authenticated limit

**"Getting old/cached results"**
- Use `--no-cache` for fresh data

## Related References

- `references/00-repo-and-issues.md` — Complete usage guide for both commands
- `references/00-trending-repos-digest.md` — How `find-repos.sh` works internally
- `references/EXAMPLE-trending-digest-output.md` — A captured real run
- `references/thresholds.yaml` — Repo-health scoring thresholds for a separate,
  not-yet-implemented design. Neither command reads this file.

## Next Steps

1. Run `/find-repos` to see trending repos
2. Pick a repo from the output
3. Run `/repo-details owner/repo` to see its available issues and labels
4. Click the link and read the issue
5. Start contributing!

That's it. Simple workflow, real results. 🚀
