# /find-repos Implementation Details

Technical reference for how the `/find-repos` command discovers trending repositories.

**Script:** `skills/oss-contributor/scripts/find-repos.sh` (Bash + inline Python 3)
**Cost:** free — no model is invoked; the script emits markdown directly
**Speed:** ~5-15s for a fresh run; the 2-hour cache skips the scrape step
**Requirements:** Python 3. GitHub CLI (`gh`) is optional, for the API token only

---

## Quick Start

```bash
# Today's trending Python repos (the default)
/find-repos

# A different language
/find-repos --language rust

# Fresh data (skip the 2-hour cache)
/find-repos --no-cache
```

`--language` and `--no-cache` are the only options.

---

## What "Trending" Means

- **Source:** GitHub's own trending page, `https://github.com/trending/{language}?since=daily`
- **Window:** daily — fixed by GitHub, not configurable here
- **Order:** GitHub's ranking, preserved as scraped
- **Limit:** top 10 repos
- **Cached:** the repo list is cached for 2 hours, per language

There is no star, topic, or date filter. GitHub has already applied its own
ranking; this script does not re-sort or re-filter it.

---

## How It Works

### Step 1: Parse arguments
Arguments are parsed **before** the cache path is computed. `CACHE_KEY` derives
from `$LANGUAGE`, so reading `--language` afterwards would send every request to
the default `python` cache file regardless of the flag.

### Step 2: Check cache
```
If --no-cache:
  → Skip the cache entirely (and do not write one afterwards)

Otherwise:
  → Look for ~/.oss-contributor/cache/trending/trending-{language}.json
  → If it exists and its mtime is < 2 hours old → use it
  → Otherwise → scrape
```

The mtime lookup tries BSD `stat -f%m` then GNU `stat -c%Y`, so the cache works
on both macOS and Linux.

### Step 3: Scrape the trending page
```
1. GET https://github.com/trending/{language}?since=daily
2. Regex out href="/owner/repo" links
3. Drop non-repo paths (sponsors, topics, issues, pulls, settings, apps)
4. Dedupe with dict.fromkeys(), which PRESERVES order, then take the first 10
5. Emit [{owner, name, url}, ...] as JSON
```

Step 4 must not use `set()`. Python randomises string hashing per process, so
`list(set(repos))` returns a different subset in a different order on every run —
which would make the `Rank` column meaningless and silently drop genuinely
top-ranked repos.

### Step 4: Fetch issues in parallel
```
ThreadPoolExecutor(max_workers=5) over the 10 repos:

  GET /repos/{owner}/{repo}/issues
      ?per_page=50&state=open&sort=updated&direction=desc&assignee=none

  → drop every item carrying a `pull_request` key
  → return (repo_path, issues, None) on success
  → return (repo_path, None,   error) on failure
```

Two details matter:

- **`assignee=none`** filters assigned issues server-side, so what's shown is
  work nobody has claimed.
- **`per_page=50`, not 10.** The issues endpoint returns pull requests in the
  same list. Requesting 10 and then filtering would leave a busy repo showing
  one or two issues — often none — because its ten most-recently-updated items
  are usually all PRs. Over-fetching and filtering down to 10 is the fix.

The third tuple element separates "fetch failed" from "nothing to show". Both
would otherwise arrive as an empty list, and a healthy repo with zero unclaimed
issues would be reported as a broken API call.

### Step 5: Render
```
1. Repo table:   | Rank | Repo Link |
2. Per repo:     up to 10 issue titles (truncated to 75 chars) as markdown links
3. Statistics:   repos found, generation timestamp, cache status
4. Token hint:   shown only when no GITHUB_TOKEN was found
```

Per-repo output is one of three things, and they are distinguishable:

| Output | Meaning |
|--------|---------|
| A list of issues | Available work |
| `No open, unassigned issues found` | Fetch succeeded; every open issue is claimed |
| `(Could not fetch issues: ...)` | The API call failed; the error text says why |

### Step 6: Cache the repo list
```
If --no-cache was not set:
  → write the scraped JSON to trending-{language}.json
```

Only the repo list is cached. Issues are always fetched fresh, so a cached run
still reflects today's issue state.

---

## Shell/Python Boundary

Both scripts pass values into Python through the **environment**, with a quoted
heredoc (`<< 'PYTHONEOF'`):

```bash
REPOS_JSON="$REPOS_JSON" GITHUB_TOKEN="$GITHUB_TOKEN" python3 << 'PYTHONEOF'
repos = json.loads(os.environ.get('REPOS_JSON') or '[]')
PYTHONEOF
```

An *unquoted* heredoc would let the shell expand `$REPO` and friends directly
into the Python source. A repo argument containing a quote character would then
be a syntax error at best, and arbitrary code execution at worst. Keep the
delimiter quoted and keep the values in `os.environ`.

`repo-details.sh` additionally rejects anything that is not a bare
`owner/repo` slug before making a request:

```bash
if [[ ! "$REPO" =~ ^[A-Za-z0-9._-]+/[A-Za-z0-9._-]+$ ]]; then
  echo "Error: repo must be in owner/repo form (got: $REPO)" >&2
  exit 1
fi
```

---

## Caching Strategy

- **Duration:** 2 hours (7200s)
- **Key:** the language, slugified into `trending-{language}.json`
- **Storage:** `~/.oss-contributor/cache/trending/`
- **Scope:** the repo list only
- **Override:** `--no-cache` — bypasses the read *and* skips the write

---

## Rate Limits

| Auth | Limit | Notes |
|------|-------|-------|
| None | 60 requests/hour | One `/find-repos` run costs 10 |
| Token | 5000 requests/hour | Auto-detected from `gh auth token`, or `$GITHUB_TOKEN` |

A token does not make an individual request faster; it raises the ceiling on how
many runs you get per hour before the API starts returning 403.

---

## Error Handling

| Scenario | Behaviour |
|----------|-----------|
| Trending page unreachable | Scrape returns `[]`; the repo table is empty |
| Issue fetch fails (403, 404, timeout) | That repo prints `(Could not fetch issues: <error>)`; others still render |
| Repo has no unclaimed issues | Prints `No open, unassigned issues found` |
| Cache file missing or unreadable | mtime falls back to 0, so the cache reads as stale and the script re-scrapes |
| `--language` with no trending entries | Empty repo table; try another language or `--no-cache` |

A failure on one repo never aborts the run — the executor collects each result
independently.

---

## Related

- `00-repo-and-issues.md` — user-facing usage guide for both commands
- `EXAMPLE-trending-digest-output.md` — a full captured run
- `../scripts/find-repos.sh` — the implementation described here
- `../scripts/repo-details.sh` — the single-repo variant
