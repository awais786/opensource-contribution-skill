---
name: repo-details
description: Use when you've chosen a specific repository and want to understand its scope, active issues, and contribution entry points
---

# Repository Details

Get detailed information about a specific GitHub repository: stats, description, top 10 recent issues, and getting started guide.

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

## Output Format

1. **Project name & GitHub link** — Direct link to repo
2. **Stats** — Stars, forks, language, open issue count
3. **Top 10 Recent Issues** — With labels for quick filtering
4. **Getting Started Guide** — Clone, setup, and contribution workflow
5. **Timestamp** — When data was fetched

## Setup Required

- **GitHub CLI**: `gh auth login` (must authenticate first)
- **Performance**: ~2-3 seconds per query (direct API call, not cached)

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| "Command not found" | Run `/find-repos` first to discover repos, THEN use this command |
| "Authentication error" | Run `gh auth login` and verify with `gh auth status` |
| "No issues shown" | Repo may have zero open issues; try a different repo |
| "Rate limited" | GitHub has 60 req/hr unauthenticated, 5000 req/hr authenticated |

## Workflow

1. Run `/find-repos --language python` (discover trending repos)
2. Pick a repo that interests you
3. Run `/repo-details owner/repo` (explore that specific repo)
4. Click an issue link to read full details on GitHub
5. Fork, code, submit PR
