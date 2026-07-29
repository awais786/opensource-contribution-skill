# Find Trending Open Source Repos

Two commands to discover trending repositories and the issues on them you can actually take.

## Commands

```bash
/find-repos                      # Today's trending Python repos + their open issues
/find-repos --language rust      # A different language
/find-repos --no-cache           # Re-scrape instead of using the 2-hour cache

/repo-details owner/repo         # Stats, description, and available issues for one repo
```

## What It Does

`/find-repos` scrapes GitHub's own trending page for a language, takes the top 10
in GitHub's ranking order, then fetches each repo's open issues in parallel. The
issue list is filtered down to work that is genuinely available: unassigned, and
not a pull request.

`/repo-details` does the same issue filtering for a single repo, and adds
metadata (stars, forks, language, description) plus each issue's labels.

There is no search query and no quality filter — GitHub's trending page is
already ranked and already scoped to the last day.

## Options

| Option | Values | Default | Purpose |
|--------|--------|---------|---------|
| `--language` | python, rust, javascript, go, etc. | python | Which trending page to scrape |
| `--no-cache` | (flag) | false | Skip cache, scrape GitHub now |

These are the only options `/find-repos` accepts. `/repo-details` takes exactly
one argument: a plain `owner/repo` slug (a URL is rejected).

## Example Output

```
## 📊 Trending Rust Repositories (Daily)

| Rank | Repo Link |
|------|-----------|
| 1 | [atuinsh/atuin](https://github.com/atuinsh/atuin) |
| 2 | [astral-sh/uv](https://github.com/astral-sh/uv) |
| 3 | [zed-industries/zed](https://github.com/zed-industries/zed) |

## 📋 Top 10 Open Issues by Repository
(Unassigned issues only - no pull requests)

### 1. atuinsh/atuin

- [Option for relative line numbers in the diff gutter](https://github.com/atuinsh/atuin/issues/509)
- [`jj` integration breaks when color output is enabled](https://github.com/atuinsh/atuin/issues/508)

## 📊 Statistics
- **Repos found:** 10
- **Generated:** 2026-07-29 23:20 UTC
- **Cache:** fresh (just scraped)
```

## How the Issue Filter Works

GitHub's `/repos/{owner}/{repo}/issues` endpoint returns pull requests in the
same list as issues. Both scripts therefore:

1. Request `assignee=none` so the API drops assigned issues server-side
2. Request 50 items rather than 10
3. Discard anything carrying a `pull_request` key
4. Show the first 10 of whatever survives

Step 2 is what makes this work. Filtering a 10-item page would leave a
high-velocity repo showing one or two issues — or none — because its ten
most-recently-updated items are usually all PRs.

Three distinct outcomes are reported differently, so you can tell them apart:

| Output | Meaning |
|--------|---------|
| A list of issues | Available work |
| `No open, unassigned issues found` | Fetch succeeded; every open issue is claimed |
| `(Could not fetch issues: ...)` | The API call failed; the error text says why |

## Common Workflows

### "Show me what's trending right now"
```bash
/find-repos
```

### "What's hot in Rust?"
```bash
/find-repos --language rust
```

### "I looked an hour ago, give me fresh data"
```bash
/find-repos --no-cache
```

### "Which of these issues can I take?"
```bash
/repo-details astral-sh/uv
```
Every issue listed is unassigned, so nothing shown is already someone else's.

## Caching

- **Duration:** 2 hours
- **Key:** one file per language, at `~/.oss-contributor/cache/trending/trending-{language}.json`
- **Scope:** the repo list only — issues are always fetched fresh
- **Override:** `--no-cache` (which also skips writing the cache)

## Setup

None required. Python 3 is the only dependency and both commands work
unauthenticated at GitHub's 60 requests/hour limit.

**Optional — raise that to 5000/hour:**

```bash
brew install gh        # macOS
sudo apt install gh    # Linux
choco install gh       # Windows

gh auth login          # Auto-detected by both scripts
```

Or `export GITHUB_TOKEN="ghp_..."` directly.

## Cost & Performance

- **Fresh query:** free; ~5-15s (scrape + 10 parallel issue fetches)
- **Cached repo list:** skips the scrape; issues still take a few seconds
- **No model is invoked** — the scripts emit markdown directly

## Troubleshooting

| Problem | Solution |
|---------|----------|
| "No repos found" | No trending entries for that language today; try another or `--no-cache` |
| "No open, unassigned issues found" | Not an error — every open issue there is claimed |
| "Could not fetch issues: HTTP Error 403" | Rate limited; run `gh auth login` |
| "repo must be in owner/repo form" | `/repo-details` takes a slug, not a URL |
| "Getting stale cached results" | Use `--no-cache` |
| "Multiple `--language` filters don't work" | Only ONE language at a time is supported |

## Next Steps

1. **Run `/find-repos`** — See what's trending
2. **Pick a repo** — Look for one that interests you
3. **Run `/repo-details owner/repo`** — See its unclaimed issues and their labels
4. **Pick an issue** — "good first issue" and "help wanted" labels are shown
5. **Start contributing** — Fork and submit your first PR!

That's it. Simple workflow, real results. 🚀
