## Why

Developers want quick visibility into what's trending in open source without manual GitHub browsing. A simple skill command shows top 15 Python + top 15 non-Python trending repos with key details, helping developers discover emerging projects.

## What Changes

- **New**: `/trending-digest` skill command that fetches and displays top 15 trending Python repos
- **New**: Displays top 15 trending non-Python repos in same digest
- **New**: Shows repo name, stars, description, language, recent activity

## Capabilities

### New Capabilities

- `trending-repos-digest`: Skill command showing top 15 trending Python repos and top 15 trending non-Python repos with key metadata (no scripts, no scheduling)

## Impact

- Adds trending digest command to existing OSS contributor skill
- No breaking changes to existing functionality
- Lightweight, minimal cost (uses Haiku model - cheapest available, ~$0.001 per run)
- Cost optimization: formatting task uses Haiku, NOT expensive models like Opus/Sonnet

## Scope Areas Covered

This change covers:
1. **Finding repositories** (trending digest command)
