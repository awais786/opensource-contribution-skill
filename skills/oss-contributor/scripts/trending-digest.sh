#!/bin/bash

# trending-digest.sh - Fetch and format trending GitHub repositories
# Usage: ./trending-digest.sh [--days N] [--topic TAG] [--min-stars N] [--stats-only] [--language LANG] [--sort FIELD] [--no-cache]

set -e

# Defaults
DAYS=${DAYS:-7}
MIN_STARS=${MIN_STARS:-0}
TOPIC=${TOPIC:-}
LANGUAGE=${LANGUAGE:-}
SORT=${SORT:-stars}
STATS_ONLY=${STATS_ONLY:-false}
USE_CACHE=${USE_CACHE:-true}
EXCLUDE_PATTERN=${EXCLUDE_PATTERN:-}

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --days) DAYS="$2"; shift 2 ;;
    --min-stars) MIN_STARS="$2"; shift 2 ;;
    --topic) TOPIC="$2"; shift 2 ;;
    --language) LANGUAGE="$2"; shift 2 ;;
    --sort) SORT="$2"; shift 2 ;;
    --stats-only) STATS_ONLY=true; shift ;;
    --no-cache) USE_CACHE=false; shift ;;
    --exclude-pattern) EXCLUDE_PATTERN="$2"; shift 2 ;;
    *) shift ;;
  esac
done

# Cache directory
CACHE_DIR="$HOME/.oss-contributor/cache/trending"
mkdir -p "$CACHE_DIR"

# Calculate date cutoff
CREATED_DATE=$(date -u -v-${DAYS}d "+%Y-%m-%d" 2>/dev/null || date -u -d "${DAYS} days ago" "+%Y-%m-%d")

# Build cache key
CACHE_KEY="trending-${DAYS}-${MIN_STARS}-${TOPIC}-${LANGUAGE}.json"
CACHE_FILE="$CACHE_DIR/$CACHE_KEY"
CACHE_AGE=$(( $(date +%s) - $(stat -f%m "$CACHE_FILE" 2>/dev/null || echo 0) ))

# Check cache (2 hours = 7200 seconds)
if [[ $USE_CACHE == true ]] && [[ $CACHE_AGE -lt 7200 ]] && [[ -f "$CACHE_FILE" ]]; then
  echo "📊 Using cached results ($(( CACHE_AGE / 60 ))m ago)..." >&2
  PYTHON_DATA=$(cat "$CACHE_FILE")
  CACHE_STATUS="cached $(( CACHE_AGE / 60 ))m ago"
else
  echo "🔍 Querying GitHub API..." >&2

  # Build GitHub query
  QUERY="created:>${CREATED_DATE}"
  [[ -n "$MIN_STARS" ]] && [[ "$MIN_STARS" -gt 0 ]] && QUERY="${QUERY} stars:>=${MIN_STARS}"
  [[ -n "$TOPIC" ]] && QUERY="${QUERY} topic:${TOPIC}"

  if [[ -n "$LANGUAGE" ]]; then
    # Single language
    QUERY="${QUERY} language:${LANGUAGE}"
    PYTHON_DATA=$(gh search repos $QUERY --sort "$SORT" --limit 15 --json name,url,stargazersCount,description,primaryLanguage,pushedAt 2>/dev/null || echo "[]")
  else
    # Python + non-Python split
    PYTHON_QUERY="${QUERY} language:python"
    NON_PYTHON_QUERY="${QUERY} language:-python"

    PYTHON_DATA=$(gh search repos $PYTHON_QUERY --sort "$SORT" --limit 15 --json name,url,stargazersCount,description,primaryLanguage,pushedAt 2>/dev/null || echo "[]")
    NON_PYTHON_DATA=$(gh search repos $NON_PYTHON_QUERY --sort "$SORT" --limit 15 --json name,url,stargazersCount,description,primaryLanguage,pushedAt 2>/dev/null || echo "[]")
  fi

  # Cache result
  [[ $USE_CACHE == true ]] && echo "$PYTHON_DATA" > "$CACHE_FILE"
  CACHE_STATUS="fresh (just queried)"
fi

# Format with Claude Haiku
PROMPT="Format these GitHub repos as a professional markdown output.

For each repo show:
- Rank | Repo Name | Stars | Description (max 60 chars) | Language | Last Updated

Add:
- Section title with count
- Aggregate stats: total repos, total stars, average stars per repo
- Language distribution (top 5)
- Cache status: ${CACHE_STATUS}
- Timestamp (UTC)

Make it clean, scannable, and professional."

# Call Claude Haiku for formatting
echo "📝 Formatting with Claude..." >&2

python3 << 'EOF' "$PYTHON_DATA" "$PROMPT"
import json
import sys
import subprocess
from datetime import datetime

data_str = sys.argv[1]
prompt = sys.argv[2]

try:
    repos = json.loads(data_str)
except:
    repos = []

if not repos:
    print("❌ No repos found. Try adjusting filters.")
    sys.exit(1)

# Format as markdown table
total_stars = 0
langs = {}
output = []

output.append(f"## 📊 Trending Repos (Last 7 Days)\n")
output.append("| Rank | Repo | Stars | Description | Language | Last Commit |")
output.append("|------|------|-------|-------------|----------|------------|")

for i, repo in enumerate(repos, 1):
    name = repo.get('name', 'unknown')
    stars = repo.get('stargazersCount', 0)
    desc = repo.get('description', '')[:60] if repo.get('description') else 'N/A'
    lang = repo.get('primaryLanguage', 'Unknown')
    updated = repo.get('pushedAt', '')[:10] if repo.get('pushedAt') else 'N/A'

    total_stars += stars
    langs[lang] = langs.get(lang, 0) + 1

    output.append(f"| {i} | {name} | {stars:,} | {desc} | {lang} | {updated} |")

# Add stats
avg_stars = total_stars // len(repos) if repos else 0
output.append(f"\n## 📈 Statistics\n")
output.append(f"- **Repos found:** {len(repos)}")
output.append(f"- **Total stars:** {total_stars:,} ⭐")
output.append(f"- **Avg stars/repo:** {avg_stars:,}")
output.append(f"- **Languages:** {', '.join(sorted(langs.keys())[:5])}")
output.append(f"\n**Generated:** {datetime.utcnow().strftime('%Y-%m-%d %H:%M UTC')} | **Cache:** fresh")

print("\n".join(output))
EOF
