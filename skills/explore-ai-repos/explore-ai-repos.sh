#!/bin/bash

# explore-ai-repos.sh - Search GitHub repositories by AI topic
# Shows up to 10 open, unassigned, non-PR issues per repo with contribution readiness

set -e

TOPIC=${TOPIC:-}
MIN_STARS=${MIN_STARS:-500}
MAX_STARS=${MAX_STARS:-15000}
USE_CACHE=${USE_CACHE:-true}

# Parse arguments before anything derives state from $TOPIC
while [[ $# -gt 0 ]]; do
  case $1 in
    --topic) TOPIC="$2"; shift 2 ;;
    --min-stars) MIN_STARS="$2"; shift 2 ;;
    --max-stars) MAX_STARS="$2"; shift 2 ;;
    --no-cache) USE_CACHE=false; shift ;;
    *) shift ;;
  esac
done

# Validate topic (required)
if [[ -z "$TOPIC" ]]; then
  echo "❌ --topic is required" >&2
  echo "" >&2
  echo "Available AI topics: rag, agent, llm, vector-database, embeddings, inference, fine-tune, prompt-engineering, semantic-search" >&2
  exit 1
fi

# Auto-detect GitHub token from environment or gh CLI
if [[ -z "$GITHUB_TOKEN" ]]; then
  if command -v gh &> /dev/null; then
    GITHUB_TOKEN=$(gh auth token 2>/dev/null || echo "")
  fi
fi

# Use project-wide cache location (consistent with find-repos.sh)
CACHE_DIR="$HOME/.oss-contributor/cache/topics"
mkdir -p "$CACHE_DIR"

# Normalize topic for cache filename
CACHE_SLUG=$(printf '%s' "$TOPIC" | tr '[:upper:]' '[:lower:]' | tr -c 'a-z0-9._-' '-')
CACHE_KEY="topic-${CACHE_SLUG}-${MIN_STARS}-${MAX_STARS}.json"
CACHE_FILE="$CACHE_DIR/$CACHE_KEY"

# stat(1) differs between BSD (macOS) and GNU (Linux)
file_mtime() {
  stat -f%m "$1" 2>/dev/null || stat -c%Y "$1" 2>/dev/null || echo 0
}
CACHE_AGE=$(( $(date +%s) - $(file_mtime "$CACHE_FILE") ))

# Check cache (2 hours = 7200 seconds)
if [[ $USE_CACHE == true ]] && [[ -f "$CACHE_FILE" ]] && [[ $CACHE_AGE -lt 7200 ]]; then
  echo "📦 Using cached results ($(( CACHE_AGE / 60 ))m ago)..." >&2
  cat "$CACHE_FILE"
  exit 0
fi

echo "🔍 Searching GitHub for Python AI repos (topic: $TOPIC)..." >&2

# Build GitHub API query with topic filter
QUERY="language:python topic:$TOPIC stars:$MIN_STARS..$MAX_STARS"

# Fetch repos from GitHub API
API_URL="https://api.github.com/search/repositories?q=$(printf '%s' "$QUERY" | jq -sRr @uri)&sort=stars&order=desc&per_page=10"
CURL_OPTS=(-s -H "Accept: application/vnd.github.v3+json")
[[ -n "$GITHUB_TOKEN" ]] && CURL_OPTS+=(-H "Authorization: token $GITHUB_TOKEN")

RESPONSE=$(curl "${CURL_OPTS[@]}" "$API_URL")

# Check for API errors
if echo "$RESPONSE" | grep -q "\"message\""; then
  ERROR_MSG=$(echo "$RESPONSE" | grep -o '"message":"[^"]*"' | cut -d'"' -f4 | head -1)
  echo "❌ GitHub API error: $ERROR_MSG" >&2
  exit 1
fi

# Extract repos (using proper JSON parsing would be better, but staying consistent with find-repos.sh style)
REPOS=$(echo "$RESPONSE" | grep -o '"full_name":"[^"]*"' | cut -d'"' -f4)
REPO_COUNT=$(echo "$REPOS" | wc -l)

if [[ $REPO_COUNT -eq 0 ]]; then
  echo "❌ No repositories found for topic: $TOPIC with $MIN_STARS-$MAX_STARS stars" >&2
  exit 1
fi

echo ""
echo "## 🤖 Python AI Repositories (topic: $TOPIC, stars: $MIN_STARS-$MAX_STARS)"
echo ""
echo "| Repo | Stars | Link |"
echo "|------|-------|------|"

# Fetch repo details in parallel (similar to find-repos.sh pattern)
for REPO in $REPOS; do
  REPO_DATA=$(curl -s \
    -H "Accept: application/vnd.github.v3+json" \
    ${GITHUB_TOKEN:+-H "Authorization: token $GITHUB_TOKEN"} \
    "https://api.github.com/repos/$REPO")

  STARS=$(echo "$REPO_DATA" | grep -o '"stargazers_count":[0-9]*' | cut -d':' -f2)
  echo "| $REPO | ⭐ $STARS | [View](https://github.com/$REPO) |"
done

echo ""
echo "## 📋 Top 10 Open Issues by Repository"
echo "(Unassigned issues only - no pull requests)"
echo ""

# Fetch issues for each repo
for REPO in $REPOS; do
  echo "### $REPO"
  echo ""

  ISSUES=$(curl -s \
    -H "Accept: application/vnd.github.v3+json" \
    ${GITHUB_TOKEN:+-H "Authorization: token $GITHUB_TOKEN"} \
    "https://api.github.com/repos/$REPO/issues?state=open&assignee=none&per_page=10")

  ISSUE_COUNT=$(echo "$ISSUES" | grep -c '"number"' || true)

  if [[ $ISSUE_COUNT -eq 0 ]]; then
    echo "- No unassigned issues found"
  else
    echo "$ISSUES" | grep -o '"number":[0-9]*,"title":"[^"]*"' | \
      sed 's/"number":/- [#/; s/,"title":"/ — /; s/"$//; s|^|- [#|; s| — |](https://github.com/'"$REPO"'/issues/|; s|$|) |'
  fi

  echo ""
done

# Cache results
{
  echo "## 📊 Python AI Repositories (topic: $TOPIC, stars: $MIN_STARS-$MAX_STARS)"
  echo ""
  echo "Generated: $(date -u '+%Y-%m-%d %H:%M UTC')"
} > "$CACHE_FILE"

echo "---"
echo "*Generated: $(date -u '+%Y-%m-%d %H:%M UTC')*"
