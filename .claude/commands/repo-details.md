---
name: repo-details
description: Use when you've chosen a specific repository and want to understand its scope, active issues, and contribution entry points
argument-hint: "owner/repo"
allowed-tools: Bash(bash skills/oss-contributor/scripts/repo-details.sh:*)
---

# Repository Details

Get comprehensive information about any GitHub repository to evaluate it and find issues to work on.

## Result

!`bash skills/oss-contributor/scripts/repo-details.sh "$ARGUMENTS"`

Present the output above to the user as-is, preserving the markdown and links.
Do not re-fetch anything from GitHub yourself — the script is the source of
truth. If it exited with an error (bad slug, 404, rate limit), report that error
rather than answering from memory.

## Quick Start

```bash
# Get details for a specific repo
/repo-details sgl-project/sglang
/repo-details fastapi/fastapi
/repo-details owner/repo-name
```

The argument must be a plain `owner/repo` slug — a full URL or anything with
other characters is rejected.

## What You Get

1. **Project Name & GitHub Link** — Direct link to the repository
2. **Project Stats** — Stars, forks, language, open issue count
3. **Description** — What the project does and its focus
4. **Up to 10 Issues to Work On** — Open, unassigned, not pull requests, with labels
5. **Getting Started Guide** — Clone, setup, and contribution workflow
6. **Timestamp** — When data was fetched

## When to Use

**Perfect for:**
- Deep dive after finding trending repos with `/find-repos`
- Evaluating if a project matches your skills
- Finding recent issues to work on in a specific project
- Understanding contribution requirements

**Triggering symptoms:**
- "I found a repo I like—what issues are there?"
- "Is this project actively maintained?"
- "What does this project focus on?"
- "How do I contribute to this specific repo?"

## Setup

No setup required — this works unauthenticated.

**Optional:** run `gh auth login` (or export `GITHUB_TOKEN`) to raise the GitHub
API rate limit from 60 requests/hour to 5000.

## Performance

- **Speed:** ~2-3 seconds per query
- **Caching:** Direct API call (not cached)
- **Rate limits:** 60 requests/hour unauthenticated, 5000/hour authenticated

## Common Issues & Fixes

| Issue | Solution |
|-------|----------|
| "repo must be in owner/repo form" | Pass just the slug, e.g. `fastapi/fastapi`, not a URL |
| "HTTP Error 404" | Check the spelling, or the repo is private |
| "No open, unassigned issues found" | Every open issue is claimed; try a different repo |
| "HTTP Error 403" (rate limited) | Run `gh auth login` for the higher authenticated limit |

## Workflow

1. Run `/find-repos --language python` (discover trending repos)
2. Pick a repo that interests you
3. Run `/repo-details owner/repo` (explore that specific repo)
4. Click an issue link to read full details on GitHub
5. Fork, code, submit your PR

## Next Steps

After running this command:
- Click any issue link to see full details on GitHub
- Read the repo's CONTRIBUTING.md for guidelines
- Fork the repo and start working!
