#!/bin/bash

# find-repos.sh - Fetch trending GitHub repositories by scraping GitHub's trending page
# Shows top 10 recent issues per repo with direct links (parallel fetching for speed)

set -e

LANGUAGE=${LANGUAGE:-python}
USE_CACHE=${USE_CACHE:-true}

# Auto-detect GitHub token from environment or gh CLI
if [[ -z "$GITHUB_TOKEN" ]]; then
  if command -v gh &> /dev/null; then
    GITHUB_TOKEN=$(gh auth token 2>/dev/null || echo "")
  fi
fi

CACHE_DIR="$HOME/.oss-contributor/cache/trending"
mkdir -p "$CACHE_DIR"

CACHE_KEY="trending-${LANGUAGE}.json"
CACHE_FILE="$CACHE_DIR/$CACHE_KEY"
CACHE_AGE=$(( $(date +%s) - $(stat -f%m "$CACHE_FILE" 2>/dev/null || echo 0) ))

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --language) LANGUAGE="$2"; shift 2 ;;
    --no-cache) USE_CACHE=false; shift ;;
    *) shift ;;
  esac
done

# Check cache (2 hours = 7200 seconds)
if [[ $USE_CACHE == true ]] && [[ $CACHE_AGE -lt 7200 ]] && [[ -f "$CACHE_FILE" ]]; then
  echo "📊 Using cached results ($(( CACHE_AGE / 60 ))m ago)..." >&2
  REPOS_JSON=$(cat "$CACHE_FILE")
  CACHE_STATUS="cached $(( CACHE_AGE / 60 ))m ago"
else
  echo "🔍 Scraping GitHub trending page..." >&2

  REPOS_JSON=$(python3 << 'PYTHONEOF'
import urllib.request
import json
import re
from datetime import datetime

try:
    # Scrape GitHub trending page
    url = f"https://github.com/trending/python?since=daily"
    response = urllib.request.urlopen(url, timeout=10)
    html = response.read().decode('utf-8')

    # Extract repo paths: /owner/repo
    repos = re.findall(r'href="(/[a-zA-Z0-9_.-]+/[a-zA-Z0-9_.-]+)"', html)
    repos = [r for r in repos if r.count('/') == 2 and not any(x in r for x in ['sponsors', 'trending', 'topics', 'issues', 'pulls', 'settings', 'apps'])]
    repos = list(set(repos))[:10]

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

# Format output
echo "## 📊 Trending Python Repositories (Daily)"
echo ""
echo "| Rank | Repo Link |"
echo "|------|-----------|"

python3 << PYTHONEOF
import json
import urllib.request
import re
from datetime import datetime
import os
import concurrent.futures
from functools import partial

repos_json = '''$REPOS_JSON'''
repos = json.loads(repos_json)
github_token = '''$GITHUB_TOKEN'''

for i, repo in enumerate(repos, 1):
    owner = repo['owner']
    name = repo['name']
    url = repo['url']
    print(f"| {i} | [{owner}/{name}]({url}) |")

print("")
print("## 📋 Top 10 Issues by Repository")
print("")

# Fetch issues in parallel for speed
def fetch_issues(repo, github_token):
    owner = repo['owner']
    name = repo['name']
    repo_path = f"{owner}/{name}"

    try:
        api_url = f"https://api.github.com/repos/{repo_path}/issues?per_page=10&state=open&sort=updated&direction=desc"
        req = urllib.request.Request(api_url)
        if github_token:
            req.add_header('Authorization', f'token {github_token}')
        req.add_header('Accept', 'application/vnd.github.v3+json')
        response = urllib.request.urlopen(req, timeout=3)
        issues = json.loads(response.read().decode('utf-8'))
        return (repo_path, issues)
    except Exception as e:
        return (repo_path, [])

# Fetch all issues in parallel (max 5 concurrent to avoid rate limits)
results = {}
with concurrent.futures.ThreadPoolExecutor(max_workers=5) as executor:
    futures = [executor.submit(fetch_issues, repo, github_token) for repo in repos[:10]]
    for future in concurrent.futures.as_completed(futures):
        try:
            repo_path, issues = future.result()
            results[repo_path] = issues
        except:
            pass

# Print results in order
for i, repo in enumerate(repos[:15], 1):
    repo_path = f"{repo['owner']}/{repo['name']}"
    print(f"### {i}. {repo_path}")
    print("")

    issues = results.get(repo_path, [])
    if issues:
        for issue in issues:
            title = issue['title'][:75]
            issue_url = issue['html_url']
            print(f"- [{title}]({issue_url})")
    else:
        print("- (Could not fetch issues)")

    print("")

print("## 📊 Statistics")
print(f"- **Repos found:** {len(repos)}")
print(f"- **Generated:** {datetime.now().strftime('%Y-%m-%d %H:%M UTC')}")
print(f"- **Cache:** $CACHE_STATUS")
if not github_token:
    print(f"- **Tip:** Add GitHub token for faster fetching. Run: gh auth login")

PYTHONEOF
