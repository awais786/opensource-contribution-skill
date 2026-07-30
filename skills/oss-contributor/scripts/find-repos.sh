#!/bin/bash

# find-repos.sh - Fetch trending GitHub repositories by scraping GitHub's trending page
# Shows up to 10 open, unassigned, non-PR issues per repo (parallel fetching for speed)

set -e

LANGUAGE=${LANGUAGE:-python}
USE_CACHE=${USE_CACHE:-true}

# Parse arguments before anything derives state from $LANGUAGE
while [[ $# -gt 0 ]]; do
  case $1 in
    --language) LANGUAGE="$2"; shift 2 ;;
    --no-cache) USE_CACHE=false; shift ;;
    *) shift ;;
  esac
done

# Auto-detect GitHub token from environment or gh CLI
if [[ -z "$GITHUB_TOKEN" ]]; then
  if command -v gh &> /dev/null; then
    GITHUB_TOKEN=$(gh auth token 2>/dev/null || echo "")
  fi
fi

CACHE_DIR="$HOME/.oss-contributor/cache/trending"
mkdir -p "$CACHE_DIR"

# Reduce the language to a safe filename component
CACHE_SLUG=$(printf '%s' "$LANGUAGE" | tr '[:upper:]' '[:lower:]' | tr -c 'a-z0-9._-' '-')
CACHE_KEY="trending-${CACHE_SLUG}.json"
CACHE_FILE="$CACHE_DIR/$CACHE_KEY"

# stat(1) differs between BSD (macOS) and GNU (Linux)
file_mtime() {
  stat -f%m "$1" 2>/dev/null || stat -c%Y "$1" 2>/dev/null || echo 0
}
CACHE_AGE=$(( $(date +%s) - $(file_mtime "$CACHE_FILE") ))

# Check cache (2 hours = 7200 seconds)
if [[ $USE_CACHE == true ]] && [[ -f "$CACHE_FILE" ]] && [[ $CACHE_AGE -lt 7200 ]]; then
  echo "📊 Using cached results ($(( CACHE_AGE / 60 ))m ago)..." >&2
  REPOS_JSON=$(cat "$CACHE_FILE")
  CACHE_STATUS="cached $(( CACHE_AGE / 60 ))m ago"
else
  echo "🔍 Scraping GitHub trending page..." >&2

  REPOS_JSON=$(LANGUAGE="$LANGUAGE" python3 << 'PYTHONEOF'
import urllib.request
import urllib.parse
import json
import re
import os

language = os.environ.get('LANGUAGE', '').strip()

try:
    # Scrape GitHub trending page for the requested language
    path = urllib.parse.quote(language.lower()) if language else ''
    url = f"https://github.com/trending/{path}?since=daily"
    response = urllib.request.urlopen(url, timeout=10)
    html = response.read().decode('utf-8')

    # Extract repo paths: /owner/repo
    repos = re.findall(r'href="(/[a-zA-Z0-9_.-]+/[a-zA-Z0-9_.-]+)"', html)
    repos = [r for r in repos if r.count('/') == 2 and not any(x in r for x in ['sponsors', 'trending', 'topics', 'issues', 'pulls', 'settings', 'apps'])]
    # dict.fromkeys dedupes while preserving trending order; set() would randomise it
    repos = list(dict.fromkeys(repos))[:10]

    repos_data = []
    for repo_path in repos:
        owner, name = repo_path.strip('/').split('/')
        repos_data.append({
            'owner': owner,
            'name': name,
            'url': f'https://github.com/{owner}/{name}'
        })

    print(json.dumps(repos_data))

except Exception as e:
    print(json.dumps([]))
PYTHONEOF
  )

  [[ $USE_CACHE == true ]] && echo "$REPOS_JSON" > "$CACHE_FILE"
  CACHE_STATUS="fresh (just scraped)"
fi

# Title-case the language for display
LANGUAGE_LABEL=$(printf '%s' "$LANGUAGE" | awk '{ print toupper(substr($0,1,1)) substr($0,2) }')

# Format output
echo "## 📊 Trending ${LANGUAGE_LABEL} Repositories (Daily)"
echo ""
echo "| Rank | Repo Link |"
echo "|------|-----------|"

REPOS_JSON="$REPOS_JSON" GITHUB_TOKEN="$GITHUB_TOKEN" CACHE_STATUS="$CACHE_STATUS" python3 << 'PYTHONEOF'
import json
import urllib.request
from datetime import datetime
import os
import concurrent.futures

REPO_LIMIT = 10       # repos to report on
ISSUE_LIMIT = 10      # issues to show per repo
FETCH_PER_PAGE = 50   # over-fetch, because PRs and assigned issues get filtered out

repos = json.loads(os.environ.get('REPOS_JSON') or '[]')[:REPO_LIMIT]
github_token = os.environ.get('GITHUB_TOKEN', '')
cache_status = os.environ.get('CACHE_STATUS', 'unknown')

for i, repo in enumerate(repos, 1):
    owner = repo['owner']
    name = repo['name']
    url = repo['url']
    print(f"| {i} | [{owner}/{name}]({url}) |")

print("")
print(f"## 📋 Top {ISSUE_LIMIT} Open Issues by Repository")
print("(Unassigned issues only - no pull requests)")
print("")

# Fetch issues in parallel for speed
def fetch_issues(repo, github_token):
    owner = repo['owner']
    name = repo['name']
    repo_path = f"{owner}/{name}"

    try:
        # Fetch issues; the endpoint returns both issues and PRs interleaved, so
        # over-fetch and filter client-side rather than truncating first.
        # Note: assignee=none param doesn't reliably filter, so we filter both PRs and assigned issues client-side.
        api_url = (
            f"https://api.github.com/repos/{repo_path}/issues"
            f"?per_page={FETCH_PER_PAGE}&state=open&sort=updated&direction=desc"
        )
        req = urllib.request.Request(api_url)
        if github_token:
            req.add_header('Authorization', f'token {github_token}')
        req.add_header('Accept', 'application/vnd.github.v3+json')
        response = urllib.request.urlopen(req, timeout=10)
        items = json.loads(response.read().decode('utf-8'))
        # Filter: exclude PRs AND exclude assigned issues (only show unassigned)
        real_issues = [item for item in items if not item.get('pull_request') and not item.get('assignee')]
        return (repo_path, real_issues, None)
    except Exception as e:
        return (repo_path, None, str(e))

# Fetch all issues in parallel (max 5 concurrent to avoid rate limits)
results = {}
with concurrent.futures.ThreadPoolExecutor(max_workers=5) as executor:
    futures = [executor.submit(fetch_issues, repo, github_token) for repo in repos]
    for future in concurrent.futures.as_completed(futures):
        try:
            repo_path, issues, error = future.result()
            results[repo_path] = (issues, error)
        except Exception as e:
            pass

# Print results in order
for i, repo in enumerate(repos, 1):
    repo_path = f"{repo['owner']}/{repo['name']}"
    print(f"### {i}. {repo_path}")
    print("")

    issues, error = results.get(repo_path, (None, 'no response'))
    if error is not None:
        # An empty list means "nothing to work on"; only a real failure lands here.
        print(f"- (Could not fetch issues: {error})")
    elif issues:
        for issue in issues[:ISSUE_LIMIT]:
            title = issue['title'][:75]
            issue_url = issue['html_url']
            print(f"- [{title}]({issue_url})")
    else:
        print("- No open, unassigned issues found")

    print("")

print("## 📊 Statistics")
print(f"- **Repos found:** {len(repos)}")
print(f"- **Generated:** {datetime.now().strftime('%Y-%m-%d %H:%M UTC')}")
print(f"- **Cache:** {cache_status}")
if not github_token:
    print(f"- **Tip:** Add GitHub token for faster fetching. Run: gh auth login")

PYTHONEOF
