---
name: repo-details
description: Use when exploring a specific repository to get detailed stats, description, and top 10 issues with links
---

# Repository Details

Get detailed information about any GitHub repository: stats, description, and top 10 issues with direct links.

## Quick Start

```bash
/repo-details owner/repo
/repo-details sgl-project/sglang
/repo-details fastapi/fastapi
```

## What You Get

- **Project Stats**: Stars, forks, language, open issue count
- **Description**: What the project does
- **Top 10 Issues**: Recently updated issues with labels
- **Getting Started**: Clone, setup, and contribution tips
- **Direct Links**: Click any issue to jump to GitHub

## Examples

### Find issues in FastAPI
```bash
/repo-details fastapi/fastapi
```

### Explore Anthropic's SDK
```bash
/repo-details anthropics/anthropic-sdk-python
```

### Check out a trending project
```bash
/repo-details huggingface/speech-to-speech
```

## Output Includes

1. **Project Header** — Repo name and GitHub link
2. **Stats** — Stars, forks, language, open issues
3. **Top 10 Issues** — With labels for easy filtering
4. **Getting Started Guide** — Clone, setup, and contribution steps
5. **Timestamp** — When data was fetched

## Performance

- **Fresh query**: ~2-3 seconds
- **Requires**: GitHub CLI authentication (`gh auth login`)

## Next Steps

1. Run `/repo-details owner/repo`
2. Pick an issue that interests you
3. Click the link to read full details
4. Follow the "Getting Started" section
5. Submit your first PR!
