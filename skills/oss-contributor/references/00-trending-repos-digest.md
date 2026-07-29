# Trending Repos Digest

Quick daily view of what's trending in open source with flexible filtering and insights.

**Cost:** ~$0.001 per run (uses Haiku, formatting only—no reasoning)  
**Time:** ~10 seconds (cached results available instantly)  
**Setup:** Requires `gh` CLI authenticated with GitHub

---

## Quick Start

```bash
# Default: top 15 Python + 15 non-Python repos (last 7 days)
/trending-digest

# With options
/trending-digest --days 30 --min-stars 100 --topic web

# Show stats only
/trending-digest --stats

# Exclude educational repos
/trending-digest --exclude-pattern "awesome-*"
```

---

## What "Trending" Means

- **Created date:** Configurable time window (1, 3, 7, 14, 30 days)
- **Sorted by:** Stars descending (most-starred first)
- **Top:** 15 Python + 15 non-Python (separate queries to prevent Python dominance)
- **Filtered:** By minimum stars, topics, language patterns
- **Cached:** Results cached for 2 hours to save API quota

---

## Workflow

### Default Behavior (No Options)
```
1. Check cache for recent results (2-hour TTL)
   
2. Query GitHub (if not cached):
   - Top 15 Python repos from last 7 days (sorted by stars)
   - Top 15 non-Python repos from last 7 days (sorted by stars)
   
3. Calculate aggregate stats:
   - Total stars across all repos
   - Language distribution
   - Average stars per repo
   - Most popular language
   
4. Format with Haiku:
   - Create markdown tables (Python + non-Python)
   - Add stats summary
   - Include cache status and timestamp

5. Display full output with recommendations
```

### With Options
```
--days N              # Time window: 1, 3, 7, 14, 30 (default: 7)
--min-stars N         # Minimum stars filter (default: none)
--topic TAG           # Filter by topic (e.g., 'web', 'rust', 'cli')
--exclude-pattern     # Exclude repos matching pattern (e.g., 'awesome-*')
--stats-only          # Show aggregate statistics only
--language LANG       # Single language instead of Python+non-Python
--sort FIELD          # Sort by: stars (default), forks, watchers, updated
--limit N             # Override default 15 repos per category
--no-cache            # Ignore cache, fresh GitHub query
```

### Example Queries
```bash
# Trending web frameworks in last 30 days
/trending-digest --days 30 --topic web --min-stars 50

# Show stats only (no details)
/trending-digest --stats-only

# Rust repos trending last 14 days
/trending-digest --language rust --days 14

# Exclude educational/curated lists
/trending-digest --exclude-pattern "awesome-*,learning-*"

# Fresh results (bypass 2-hour cache)
/trending-digest --no-cache
```

---

## Example Output

### Default (Python + non-Python)
```
## 📊 Trending Repos (Last 7 Days)

### Python Trending Repos (15 found)

| Rank | Repo | Stars | Description | Language | Last Commit |
|------|------|-------|-------------|----------|------------|
| 1 | NousResearch/hermes-agent | 2,340 | The agent that grows with you | Python | 2026-07-29 |
| 2 | microsoft/markitdown | 1,890 | Python tool for converting files | Python | 2026-07-23 |
| 3 | anthropics/skills | 1,456 | Public repository for Agent Skills | Python | 2026-07-24 |
...

### Non-Python Trending Repos (15 found)

| Rank | Repo | Stars | Description | Language | Last Commit |
|------|------|-------|-------------|----------|------------|
| 1 | openclaw/openclaw | 3,120 | Your own personal AI assistant | TypeScript | 2026-07-29 |
| 2 | vercel/next.js | 2,890 | The React Framework for Production | TypeScript | 2026-07-28 |
...

## 📈 Aggregate Stats

- **Total repos:** 30 (15 Python + 15 non-Python)
- **Total stars:** 45,320 ⭐
- **Avg stars/repo:** 1,511
- **Most popular:** Python (avg 1,850 stars/repo)
- **Language diversity:**
  - Python: 15 repos (52% of stars)
  - TypeScript: 8 repos (22%)
  - Rust: 4 repos (12%)
  - Other: 3 repos (14%)

**Generated:** 2026-07-29 14:32 UTC | **Cache:** fresh (queried 1m ago)

---

### With Filters Example
```bash
/trending-digest --days 30 --topic web --min-stars 100
```

**Output:**
```
## 🌐 Trending Web Framework Repos (Last 30 Days, 100+ stars)

### Python Web Frameworks (8 found)

| Rank | Repo | Stars | Description | Language | Last Commit |
|------|------|-------|-------------|----------|------------|
| 1 | fastapi/fastapi | 8,240 | Modern, fast web framework for Python | Python | 2026-07-28 |
...

### Non-Python Web Frameworks (12 found)

| Rank | Repo | Stars | Description | Language | Last Commit |
|------|------|-------|-------------|----------|------------|
| 1 | vercel/next.js | 12,540 | The React Framework for Production | TypeScript | 2026-07-28 |
...

## 📈 Web Framework Stats

- **Total repos:** 20 (8 Python + 12 non-Python)
- **Total stars:** 95,420 ⭐
- **Avg stars/repo:** 4,771 (high-quality projects!)

**Generated:** 2026-07-29 14:35 UTC | **Cache:** fresh
```

### Stats-Only Example
```bash
/trending-digest --stats-only --days 14
```

**Output:**
```
## 📊 Trending Stats (Last 14 Days)

| Metric | Value |
|--------|-------|
| Repos scanned | 30 |
| Total stars | 52,100 ⭐ |
| Avg stars/repo | 1,737 |
| Most active | Python (avg 2,045 stars) |
| Fastest growing | TypeScript (+23% week-over-week) |

**Top languages by stars:**
1. Python — 27,300 stars (52%)
2. TypeScript — 13,200 stars (25%)
3. Rust — 7,850 stars (15%)
4. Go — 3,750 stars (8%)

Generated: 2026-07-29 14:38 UTC | **Cache:** fresh
```

---

## Caching Strategy

- **Cache duration:** 2 hours per query signature
- **Cache key:** Combination of (days, min_stars, topic, language, exclude_pattern)
- **Storage:** `~/.oss-contributor/cache/trending/`
- **Benefits:** Avoid rate limits, instant results for repeated queries, cost savings
- **Override:** Use `--no-cache` flag for fresh results

**Example:**
```bash
/trending-digest                    # Queries GitHub, caches result
/trending-digest --stats-only       # Returns cached result instantly
/trending-digest --no-cache         # Ignores cache, queries GitHub fresh
```

---

## Stats Output

When using `--stats-only` or included in default output:

```
## Trending Stats (Last 7 Days)

- **Total repos analyzed:** 30 (15 Python + 15 non-Python)
- **Total stars:** 45,320
- **Avg stars/repo:** 1,511
- **Most popular language:** Python (4.2k avg stars)
- **Language distribution:**
  - Python: 15 repos (38% of total stars)
  - TypeScript: 8 repos (22%)
  - Rust: 4 repos (15%)
  - Go: 3 repos (12%)
  - Other: 7 repos (13%)
- **Cache status:** Fresh (queried 2m ago)
```

---

## FAQ

**Q: What counts as "trending"?**  
A: Trending = most stars in your selected time window, sorted descending. Default is last 7 days.

**Q: Can I change the time window?**  
A: Yes! Use `--days 1|3|7|14|30` to pick your window.

**Q: Why separate Python and non-Python by default?**  
A: Python repos dominate GitHub. Separating ensures visibility of other languages. Use `--language` to focus on one.

**Q: How does caching work?**  
A: Results cached for 2 hours per query. Same query returns instantly. Use `--no-cache` to bypass.

**Q: Can I filter by topic?**  
A: Yes! Use `--topic web` (or 'rust', 'cli', 'database', etc.). Supports GitHub's topic tags.

**Q: How do I exclude educational repos?**  
A: Use `--exclude-pattern "awesome-*,learning-*"` to skip curated lists and tutorials.

**Q: What if results are fewer than 15?**  
A: Displays all found with count (e.g., "12 Python repos found, 15 non-Python repos found").

**Q: How much does this cost?**  
A: ~$0.001 per fresh query. Cached queries cost nothing (instant). Haiku model keeps cost minimal.

**Q: What if GitHub API fails?**  
A: Shows friendly error. If cached results exist, offers to show stale data. Try again in a few minutes.

**Q: Can I see trending for a single language?**  
A: Yes! Use `--language rust` instead of default Python+non-Python split.

**Q: Which sorting options are available?**  
A: `--sort stars` (default), `forks`, `watchers`, or `updated` for recency.

---

## Model Configuration

**This skill uses Claude Haiku (cheapest model).**

- ✅ Haiku: Formatting task only, ~100-200 tokens per run
- ❌ NOT Opus: Unnecessary cost for formatting
- ❌ NOT Sonnet: Overkill, no reasoning needed

Model is configured in SKILL.md workflow as: `model: haiku`

---

## Implementation

### 1. Parse Options
```bash
# Extract parameters from command
days=${DAYS:-7}
min_stars=${MIN_STARS:-0}
topic=${TOPIC:-}
exclude_pattern=${EXCLUDE_PATTERN:-}
stats_only=${STATS_ONLY:-false}
language=${LANGUAGE:-}
sort=${SORT:-stars}
limit=${LIMIT:-15}
use_cache=${USE_CACHE:-true}
```

### 2. Check Cache
```bash
cache_key="trending-${days}-${min_stars}-${topic}-${language}"
cache_file="~/.oss-contributor/cache/trending/${cache_key}.json"
cache_age=$(( $(date +%s) - $(stat -f%m "$cache_file" 2>/dev/null || echo 0) ))

if [[ $use_cache == true ]] && [[ $cache_age -lt 7200 ]]; then
  # Use cached results (< 2 hours old)
  cached_data=$(cat "$cache_file")
  cache_status="cached $(( cache_age / 60 ))m ago"
else
  # Query GitHub fresh
  cache_status="fresh"
fi
```

### 3. Build GitHub Query
```bash
# Calculate date cutoff
created_date=$(date -u -v-${days}d "+%Y-%m-%d")

# Base query with language handling
if [[ -n "$language" ]]; then
  query="language:${language}"
else
  query="language:python"  # Build two queries if not specified
fi

# Add filters
[[ -n "$min_stars" ]] && query="${query} stars:>=${min_stars}"
[[ -n "$topic" ]] && query="${query} topic:${topic}"
[[ -n "$exclude_pattern" ]] && query="${query} -name:${exclude_pattern}"

# Execute query
gh search repos \
  $query \
  --sort ${sort} \
  --created ">${created_date}" \
  --limit ${limit} \
  --json name,url,stargazersCount,description,primaryLanguage,pushedAt
```

### 4. Calculate Stats (if needed)
```bash
# Aggregate statistics
total_stars=$(echo "$json_data" | jq '[.[].stargazersCount] | add')
avg_stars=$(echo "$json_data" | jq "add / length")
language_dist=$(echo "$json_data" | jq 'group_by(.primaryLanguage) | map({lang: .[0].primaryLanguage, count: length, total_stars: map(.stargazersCount) | add})')
```

### 5. Format with Haiku
```bash
# Pass to Haiku for formatting
prompt="Format these GitHub repos as a markdown table.
Columns: Rank | Repo | Stars | Description (max 60 chars) | Language | Last Commit
Add aggregate stats: total repos, total stars, avg stars, language distribution.
Include cache status: '${cache_status}' and timestamp (UTC).
Make it visually clear and scannable."

# Use Haiku model (claude-haiku)
curl -X POST https://api.anthropic.com/v1/messages \
  -H "model: claude-haiku" \
  -d "{\"prompt\": \"${prompt}\", \"data\": $(echo "$json_data" | jq -c .)}"
```

### 6. Cache Result
```bash
mkdir -p ~/.oss-contributor/cache/trending/
echo "$formatted_output" > "$cache_file"
```

---

## Best Practices

### 🎯 Effective Trending Searches

**Do:**
- ✅ Use `--min-stars` to filter for quality repos (50-200 is sweet spot)
- ✅ Filter by `--topic` to focus on domains you care about
- ✅ Check `--stats-only` first to understand the landscape
- ✅ Use `--days 30` for more options, `--days 7` for cutting edge
- ✅ Vary `--sort` (stars vs. updated) based on goal
- ✅ Start with cached results, use `--no-cache` only if needed

**Don't:**
- ❌ Always pick the #1 repo (might be too complex/fast-moving)
- ❌ Ignore repos with fewer stars (often hidden gems)
- ❌ Skip the stats — they reveal trends you'll miss
- ❌ Over-filter — start broad, narrow down after seeing results
- ❌ Chase every trending repo — pick 3-5 to evaluate deeply

### 🔍 Smart Selection

**For first-time contributors:**
```bash
/trending-digest --min-stars 200 --days 7 --stats-only
# Then pick repos with active, welcoming communities
# Use /repo-health to verify responsiveness
```

**For experienced contributors:**
```bash
/trending-digest --days 30 --sort updated --topic <domain>
# Look for high-velocity projects
# Use /issue-discovery to find complex problems
```

**For learning:**
```bash
/trending-digest --days 14 --topic <language> --stats-only
# See what the community is building
# Study the top repos' architecture
```

---

## Error Handling

| Scenario | Behavior |
|----------|----------|
| GitHub API rate limit | Show: "Rate limit reached. Using cached results (1h old). Run `gh auth status` to check quota." |
| GitHub API fails | Show: "GitHub API unavailable. Please try again in a few minutes." |
| No results found | Show: "No repos found matching filters. Try: fewer filters, longer time window, lower star threshold." |
| Fewer than expected | Show: "Only 8 Python repos found (less than 15 expected). Expanding search..." |
| Cache corrupted | Show: "Cache invalid. Running fresh query..." |
| Invalid options | Show: "Invalid filter: `--days 45` (allowed: 1,3,7,14,30). Using 7." |

---

## Workflow Integration

The trending digest is the **entry point** for finding what to work on. Pair it with:

### ➡️ Next Route: `/repo-health`
```bash
# Found an interesting trending repo?
/trending-digest                          # See what's hot
# Then evaluate it
/repo-health microsoft/markitdown         # Check maintainer responsiveness
```

**Use repo-health to answer:**
- Is this project actively maintained?
- How responsive are maintainers?
- What's the issue resolution time?
- Code review quality?

### ➡️ Next Route: `/issue-discovery`
```bash
# After evaluating the repo:
/issue-discovery microsoft/markitdown     # Find issues to work on
```

**Use issue-discovery to answer:**
- What issues match my skills?
- Which have the best acceptance rate?
- How long would each take?

### ➡️ Next Route: `/codebase-orientation`
```bash
# Before diving in:
/codebase-orientation microsoft/markitdown  # Understand architecture
```

**Use codebase-orientation to answer:**
- What's the project structure?
- Key modules and dependencies?
- Testing patterns?

---

## Common Workflows

### 🎯 "I want to contribute today"
```bash
1. /trending-digest --days 7 --min-stars 100
   → Pick 3-5 repos that interest you

2. /repo-health <repo>
   → Check each one for active maintenance

3. /issue-discovery <repo>
   → Find an issue you can solve

4. /codebase-orientation <repo>
   → Get comfortable with the code

5. Make your contribution!
```

### 🔥 "Show me hot web techs"
```bash
/trending-digest --days 30 --topic web --stats-only
→ See what's trending in web development right now
```

### 📚 "Find learning opportunities"
```bash
/trending-digest --exclude-pattern "awesome-*,learning-*" --min-stars 50
→ Real projects (not tutorials) with active communities
```

### 🚀 "Deep dive into one language"
```bash
/trending-digest --language rust --days 14 --sort updated
→ Trending Rust repos, sorted by recent activity (not just stars)
```
