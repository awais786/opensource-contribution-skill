---
name: repo-details
description: Use when you've chosen a specific repository and want to understand its scope, active issues, and contribution entry points
---

# Repository Details

Get detailed information about a specific GitHub repository: stats, description, up to 10 open and unassigned issues, and a getting started guide.

## When to Use

**Triggering symptoms:**
- "I found a repo I like—what issues are there?"
- "Is this project actively maintained?"
- "What does this project focus on?"
- "How do I contribute to this specific repo?"

**Perfect for:**
- Deep dive after finding trending repos with `/find-repos`
- Evaluating if a project matches your skills
- Finding recent issues to work on in a specific project
- Understanding contribution requirements

## Quick Start

```bash
/repo-details sgl-project/sglang
/repo-details owner/repo-name
```

The argument must be a plain `owner/repo` slug; a URL is rejected.

## Output Format

1. **Project name & GitHub link** — Direct link to repo
2. **Stats** — Stars, forks, language, open issue count
3. **Up to 10 Issues to Work On** — Open, unassigned, not pull requests, with labels
4. **Getting Started Guide** — Clone, setup, and contribution workflow
5. **Timestamp** — When data was fetched

## Setup

- **None required** — works unauthenticated at 60 API requests/hour
- **Optional**: `gh auth login` (or `GITHUB_TOKEN`) raises that to 5000/hour
- **Performance**: ~2-3 seconds per query (direct API call, not cached)

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| "repo must be in owner/repo form" | Pass the slug only, e.g. `fastapi/fastapi` |
| "HTTP Error 404" | Check the spelling, or the repo is private |
| "No open, unassigned issues found" | Not an error: every open issue there is claimed |
| "Rate limited" (403) | Run `gh auth login` — 60 req/hr unauthenticated, 5000 authenticated |

## Workflow

1. Run `/find-repos --language python` (discover trending repos)
2. Pick a repo that interests you
3. Run `/repo-details owner/repo` (explore that specific repo)
4. Click an issue link to read full details on GitHub
5. Fork, code, submit PR
