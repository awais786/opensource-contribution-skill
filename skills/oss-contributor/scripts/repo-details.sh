#!/bin/bash

# repo-details.sh - Fetch detailed repo info and top 10 issues with professional formatting

set -e

REPO=$1

if [[ -z "$REPO" ]]; then
  echo "Usage: repo-details owner/repo"
  echo "Example: repo-details sgl-project/sglang"
  exit 1
fi

# Reject anything that is not a plain owner/repo slug before it reaches the API
if [[ ! "$REPO" =~ ^[A-Za-z0-9._-]+/[A-Za-z0-9._-]+$ ]]; then
  echo "Error: repo must be in owner/repo form (got: $REPO)" >&2
  exit 1
fi

# Auto-detect GitHub token from environment or gh CLI
if [[ -z "$GITHUB_TOKEN" ]]; then
  if command -v gh &> /dev/null; then
    GITHUB_TOKEN=$(gh auth token 2>/dev/null || echo "")
  fi
fi

REPO="$REPO" GITHUB_TOKEN="$GITHUB_TOKEN" python3 << 'PYTHONEOF'
import urllib.request
import json
import os
import sys
from datetime import datetime

ISSUE_LIMIT = 10      # issues to show
FETCH_PER_PAGE = 50   # over-fetch, because PRs get filtered out below

github_token = os.environ.get('GITHUB_TOKEN', '')
repo = os.environ.get('REPO', '')

try:
    # Fetch repo metadata
    api_url = f"https://api.github.com/repos/{repo}"
    req = urllib.request.Request(api_url)
    if github_token:
        req.add_header('Authorization', f'token {github_token}')
    req.add_header('Accept', 'application/vnd.github.v3+json')
    response = urllib.request.urlopen(req, timeout=10)
    repo_data = json.loads(response.read().decode('utf-8'))

    # Extract key info
    name = repo_data.get('name', 'Unknown')
    owner = repo_data.get('owner', {}).get('login', 'Unknown')
    stars = repo_data.get('stargazers_count', 0)
    forks = repo_data.get('forks_count', 0)
    language = repo_data.get('language', 'N/A')
    open_issues = repo_data.get('open_issues_count', 0)
    description = repo_data.get('description', 'No description available')
    repo_url = repo_data.get('html_url', '')

    # Print header
    print(f"# {name}")
    print("")
    print(f"📍 [{owner}/{name}]({repo_url})")
    print("")

    # Print stats
    print("## Project Stats:")
    print(f"- ⭐ {stars:,} stars | 📁 {forks:,} forks | 🐍 {language}")
    print(f"- 📋 {open_issues:,} open issues (active development)")
    print(f"- Focus: {description}")
    print("")

    # Fetch issues; the endpoint returns both issues and PRs interleaved, so
    # over-fetch and filter client-side rather than truncating first.
    # Note: assignee=none param doesn't reliably filter, so we filter both PRs and assigned issues client-side.
    issues_url = (
        f"https://api.github.com/repos/{repo}/issues"
        f"?per_page={FETCH_PER_PAGE}&state=open&sort=updated&direction=desc"
    )
    req = urllib.request.Request(issues_url)
    if github_token:
        req.add_header('Authorization', f'token {github_token}')
    req.add_header('Accept', 'application/vnd.github.v3+json')
    response = urllib.request.urlopen(req, timeout=10)
    items = json.loads(response.read().decode('utf-8'))
    # Filter: exclude PRs AND exclude assigned issues (only show unassigned)
    real_issues = [item for item in items if not item.get('pull_request') and not item.get('assignee')]

    # Print issues section
    print(f"## 🎯 Top {ISSUE_LIMIT} Issues to Work On")
    print("(Unassigned issues only - no pull requests)")
    print("")

    if real_issues:
        for i, issue in enumerate(real_issues[:ISSUE_LIMIT], 1):
            title = issue['title']
            url = issue['html_url']
            labels = [label['name'] for label in issue.get('labels', [])]
            label_str = ', '.join(labels) if labels else 'no labels'
            print(f"{i}. **[{title}]({url})**")
            print(f"   - Labels: {label_str}")
            print("")
    else:
        print("- No open, unassigned issues found")
        print("")

    # Print getting started
    print("## Getting Started")
    print("")
    print("1. **Clone and explore:**")
    print("   ```bash")
    print(f"   git clone https://github.com/{repo}.git")
    print(f"   cd {name}")
    print("   ```")
    print("")
    print("2. **Find issues to work on:**")
    print(f"   - Visit: https://github.com/{repo}/issues")
    print("   - Filter by: good first issue or help wanted labels")
    print("")
    print("3. **Setup development environment:**")
    print(f"   - Check README.md for installation")
    print(f"   - Review CONTRIBUTING.md for contribution guidelines")
    print("")
    print("4. **Submit your first PR:**")
    print(f"   - Fork the repo")
    print(f"   - Create a feature branch")
    print(f"   - Make your changes")
    print(f"   - Submit a pull request")
    print("")

    # Print metadata
    print("---")
    print(f"*Generated: {datetime.now().strftime('%Y-%m-%d %H:%M UTC')}*")

except Exception as e:
    print(f"Error fetching repo details: {e}", file=sys.stderr)
    sys.exit(1)

PYTHONEOF
