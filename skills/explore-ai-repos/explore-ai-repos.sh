#!/bin/bash

# explore-ai-repos.sh
# Discover Python AI/ML repositories by topic with contribution readiness assessment
#
# Usage:
#   bash explore-ai-repos.sh --topic rag
#   bash explore-ai-repos.sh --topic agent --min-stars 300 --max-stars 5000
#   bash explore-ai-repos.sh --topic vector-database --created 2023-06-01

set -e

# Defaults
TOPIC=""
MIN_STARS=500
MAX_STARS=15000
CREATED_AFTER=""
READINESS_ONLY=false
NO_CACHE=false
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/explore-ai-repos"
CACHE_FILE="$CACHE_DIR/${TOPIC}_cache.json"
CACHE_TTL=7200  # 2 hours

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --topic)
      TOPIC="$2"
      shift 2
      ;;
    --min-stars)
      MIN_STARS="$2"
      shift 2
      ;;
    --max-stars)
      MAX_STARS="$2"
      shift 2
      ;;
    --created)
      CREATED_AFTER="$2"
      shift 2
      ;;
    --readiness-only)
      READINESS_ONLY=true
      shift
      ;;
    --no-cache)
      NO_CACHE=true
      shift
      ;;
    *)
      echo "❌ Unknown option: $1"
      echo ""
      echo "Usage: bash explore-ai-repos.sh --topic TOPIC [OPTIONS]"
      echo ""
      echo "Options:"
      echo "  --topic TOPIC              AI topic to search (rag, agent, llm, vector-database, etc.)"
      echo "  --min-stars N              Minimum stars (default: 500)"
      echo "  --max-stars N              Maximum stars (default: 15000)"
      echo "  --created DATE             Filter repos created after DATE (e.g., 2023-06-01)"
      echo "  --readiness-only           Only show repos with good contribution signals"
      echo "  --no-cache                 Skip cache, re-fetch from GitHub"
      echo ""
      echo "Examples:"
      echo "  bash explore-ai-repos.sh --topic rag"
      echo "  bash explore-ai-repos.sh --topic agent --min-stars 300 --max-stars 5000"
      echo "  bash explore-ai-repos.sh --topic vector-database --readiness-only"
      exit 1
      ;;
  esac
done

# Validate topic
if [[ -z "$TOPIC" ]]; then
  echo "❌ Error: --topic is required"
  echo ""
  echo "Available AI topics:"
  echo "  rag, agent, llm, vector-database, embeddings, inference, fine-tune"
  echo "  prompt-engineering, semantic-search, multi-agent, mlops"
  exit 1
fi

# Create cache directory
mkdir -p "$CACHE_DIR"

# Check cache
CACHE_FILE="$CACHE_DIR/${TOPIC}_stars-${MIN_STARS}-${MAX_STARS}_cache.json"
if [[ -f "$CACHE_FILE" ]] && [[ "$NO_CACHE" != "true" ]]; then
  if [[ $(($(date +%s) - $(stat -f%m "$CACHE_FILE" 2>/dev/null || echo 0))) -lt $CACHE_TTL ]]; then
    echo "📦 Using cached results for topic: $TOPIC"
    cat "$CACHE_FILE"
    exit 0
  fi
fi

echo "🔍 Searching GitHub for Python AI repos (topic: $TOPIC)..."

# Build GitHub API query
QUERY="language:python topic:$TOPIC stars:$MIN_STARS..$MAX_STARS"
if [[ -n "$CREATED_AFTER" ]]; then
  QUERY="$QUERY created:>$CREATED_AFTER"
fi

# Fetch repos from GitHub API
RESPONSE=$(curl -s \
  -H "Accept: application/vnd.github.v3+json" \
  "https://api.github.com/search/repositories?q=$QUERY&sort=stars&order=desc&per_page=10")

# Extract repo data
REPOS=$(echo "$RESPONSE" | grep -o '"full_name":"[^"]*"' | cut -d'"' -f4 | head -10)

if [[ -z "$REPOS" ]]; then
  echo "❌ No repositories found for topic: $TOPIC"
  echo ""
  echo "Suggestions:"
  echo "  • Check topic spelling (try: rag, agent, llm, vector-database)"
  echo "  • Adjust star range (try: --min-stars 100 --max-stars 50000)"
  echo "  • Verify topic exists on GitHub (visit: https://github.com/topics/$TOPIC)"
  exit 1
fi

echo ""
echo "## 🤖 Python AI Repositories (topic: $TOPIC, stars: $MIN_STARS-$MAX_STARS)"
echo ""
echo "| Repo | Stars | Last Commit | Issues | Readiness |"
echo "|------|-------|-------------|--------|-----------|"

READINESS_COUNT=0

# Process each repo
for REPO in $REPOS; do
  # Fetch repo details
  REPO_DATA=$(curl -s \
    -H "Accept: application/vnd.github.v3+json" \
    "https://api.github.com/repos/$REPO")

  STARS=$(echo "$REPO_DATA" | grep -o '"stargazers_count":[0-9]*' | cut -d':' -f2)
  LAST_COMMIT=$(echo "$REPO_DATA" | grep -o '"pushed_at":"[^"]*"' | cut -d'"' -f4 | cut -d'T' -f1)
  OPEN_ISSUES=$(echo "$REPO_DATA" | grep -o '"open_issues_count":[0-9]*' | cut -d':' -f2)

  # Calculate days since last commit
  LAST_COMMIT_DAYS=$(($(date +%s) - $(date -j -f "%Y-%m-%d" "$LAST_COMMIT" +%s 2>/dev/null || echo 0) ))
  LAST_COMMIT_DAYS=$((LAST_COMMIT_DAYS / 86400))

  # Assess readiness
  READINESS="⚠️ Unclear"
  if [[ $LAST_COMMIT_DAYS -lt 90 ]] && [[ $OPEN_ISSUES -gt 5 ]]; then
    READINESS="✅ Ready"
    ((READINESS_COUNT++))
  elif [[ $LAST_COMMIT_DAYS -gt 180 ]]; then
    READINESS="❌ Stale"
  elif [[ $OPEN_ISSUES -lt 3 ]]; then
    READINESS="⚠️ Few issues"
  fi

  # Skip if readiness-only and not ready
  if [[ "$READINESS_ONLY" == "true" ]] && [[ "$READINESS" != "✅ Ready" ]]; then
    continue
  fi

  echo "| [${REPO}](https://github.com/$REPO) | ⭐ $STARS | $LAST_COMMIT ($LAST_COMMIT_DAYS d) | $OPEN_ISSUES | $READINESS |"
done

echo ""
echo "## 📋 Unassigned Issues (Top 5 per Repo)"
echo ""

for REPO in $REPOS; do
  echo "### $REPO"

  # Fetch unassigned issues
  ISSUES=$(curl -s \
    -H "Accept: application/vnd.github.v3+json" \
    "https://api.github.com/repos/$REPO/issues?state=open&assignee=none&per_page=5")

  ISSUE_COUNT=$(echo "$ISSUES" | grep -o '"number":[0-9]*' | wc -l)

  if [[ $ISSUE_COUNT -eq 0 ]]; then
    echo "- No unassigned issues found"
  else
    echo "$ISSUES" | grep -o '"number":[0-9]*,"title":"[^"]*"' | sed 's/"number":/Issue #/; s/,"title":"/ — /; s/"$//' | sed "s|^|  - [|; s| — |](https://github.com/$REPO/issues/|; s|$|) |"
  fi

  echo ""
done

# Cache results
echo "## 🔍 Search Summary" > "$CACHE_FILE"
echo "Topic: $TOPIC | Stars: $MIN_STARS-$MAX_STARS | Ready: $READINESS_COUNT" >> "$CACHE_FILE"

echo ""
echo "## 🎯 Next Steps"
echo ""
echo "1. Pick a repo above"
echo "2. Run: /repo-details owner/repo (for deep dive)"
echo "3. Click an issue to read full details on GitHub"
echo "4. Check CONTRIBUTING.md before submitting PR"
echo ""
echo "---"
echo "*Generated: $(date -u '+%Y-%m-%d %H:%M UTC')*"
