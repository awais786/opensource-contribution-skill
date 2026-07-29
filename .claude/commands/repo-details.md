---
name: repo-details
description: Use when you've chosen a specific repository and want to understand its scope, active issues, and contribution entry points
---

# Repository Details

Get comprehensive information about any GitHub repository to evaluate it and find issues to work on.

## Quick Start

```bash
# Get details for a specific repo
/repo-details sgl-project/sglang
/repo-details fastapi/fastapi
/repo-details owner/repo-name
```

## What You Get

1. **Project Name & GitHub Link** — Direct link to the repository
2. **Project Stats** — Stars, forks, language, open issue count
3. **Description** — What the project does and its focus
4. **Top 10 Recent Issues** — With labels for easy filtering
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

## Setup Required

1. GitHub CLI must be installed
2. Authenticate with: `gh auth login`
3. Verify with: `gh auth status`

## Performance

- **Speed:** ~2-3 seconds per query
- **Caching:** Direct API call (not cached)
- **Rate limits:** 60 requests/hour unauthenticated, 5000/hour authenticated

## Common Issues & Fixes

| Issue | Solution |
|-------|----------|
| "Command not found" | Run `/find-repos` first to discover repos, THEN use this command |
| "Authentication error" | Run `gh auth login` and verify with `gh auth status` |
| "No issues shown" | Repo may have zero open issues; try a different repo |
| "Rate limited" | Add GitHub token for higher rate limits |

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
