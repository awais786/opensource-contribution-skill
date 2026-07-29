# Trending Repos Digest Design

## Context

The OSS contributor skill helps developers find and contribute to open source projects. A daily digest of trending repositories provides lightweight visibility into emerging projects without requiring users to manually browse GitHub.

**Existing ecosystem context:**
- Skill already integrates with `gh` CLI (authenticated GitHub API access)
- Skill operates locally (no server, no telemetry)
- Skill is portable across Claude Code and compatible agents

## Goals / Non-Goals

**Goals:**
- Fetch and display top 15 trending Python repositories on command
- Fetch and display top 15 trending non-Python repositories on command
- Show key metadata: name, description, stars, language, recent commit date
- Manual on-demand execution (user runs `/trending-digest`)
- Low compute cost (Haiku only for formatting, no complex reasoning)

**Non-Goals:**
- Do not evaluate or score projects (just display trending data)
- Do not provide strategic analysis or recommendations
- Do not take action on repositories
- No AI reasoning or synthesis needed

## Decisions

### Decision 1: GitHub API via `gh` CLI vs. Web Scraping vs. Third-Party APIs

**Choice:** GitHub API via authenticated `gh` CLI only. No scraping. No third-party APIs.

**Rationale:**
- `gh` CLI already authenticated; no separate auth story
- Official API respects rate limits and data freshness
- Portable and verifiable (no external service dependencies)
- Trending query is simple (~2-4 API calls total)

**Alternatives Considered:**
1. Web scraping (Terms of Service violation, fragile)
2. GraphQL API directly (requires auth setup; `gh` CLI abstracts this)
3. Third-party APIs (external dependency, privacy concerns)

**GitHub API Rate Limits:**
- Trending fetch: ~2-4 API calls per run
- Daily execution well under rate limits (~5k/hour auth limit)

**Implementation:** Skill uses bash commands in SKILL.md workflow: `gh search repos --sort stars --language python --created >=[7 days ago]` and equivalent for non-Python repos. No Python script needed.

### Decision 2: Language Filtering (Python + Non-Python)

**Choice:** Query top 15 trending Python repos, then top 15 trending non-Python repos separately.

**Rationale:**
- Python repos dominate trending lists; separate queries ensure visibility of both domains
- Allows team to track expertise areas (Python + emerging languages)
- Simple to implement and schedule

**Alternatives Considered:**
1. All trending repos mixed (Python dominates visibility)
2. Multiple language-specific digests (too many filters)
3. Python + non-Python split (chosen; balances visibility)

**Implementation:** Two separate GitHub queries in script, combined results displayed in single digest

### Decision 3: Data Freshness and Trending Window

**Choice:** Trend window: last 7 days. Run digest daily.

**Rationale:**
- 7-day window captures recent momentum without stale data
- Daily digest keeps developers current
- Balances frequency with meaningful changes

**Alternatives Considered:**
1. Last 24 hours (too narrow; misses recent repos)
2. Last 30 days (too broad; includes stale repos)
3. Last 7 days daily (chosen; sweet spot)

**Implementation:** GitHub query filter: `created >=[7 days ago]`, sorted by stars descending

### Decision 4: Model Choice - MUST USE HAIKU (Cost Optimization)

**Choice:** REQUIRED: Use Claude Haiku (cheapest available model) for formatting/output. NO other models allowed.

**Rationale:**
- No AI reasoning needed; just data fetching and formatting
- Haiku is the cheapest available model (~90% cheaper than Opus)
- Execution is deterministic (no complex synthesis)
- Cost per run: ~100-200 tokens (pennies, not dollars)

**Why NOT:**
- ❌ Opus/Sonnet: Overkill for formatting; unnecessary cost
- ❌ Pure script output: Possible but less polished

**IMPLEMENTATION REQUIREMENT:**
When building SKILL.md, explicitly configure:
```
model: haiku
```

Or in workflow definition:
```
This skill uses Claude Haiku (cheapest model)
Reasoning needed: None
Task: Data formatting only
```

**Verification:** Each build step should verify Haiku is configured, not Opus/Sonnet.

## Risks / Trade-offs

| Risk | Mitigation |
|---|---|
| **GitHub API rate limits** | Trending query uses ~2-4 API calls per run. Daily execution is ~4-6 calls/day, far below 5k/hour limit. No risk. |
| **No results for trending filter** | Rare edge case if no new repos in 7-day window. Handle gracefully with message "No new trending repos this period". |
| **Duplicate runs in a day** | If user runs digest multiple times, will get same results. This is acceptable (digest is meant for daily, not hourly). |
| **Data freshness** | Stars/activity data is real-time from GitHub. Timestamp each digest with fetch time. |

## Deployment Plan

**Phase 1: Implement skill command**
- Add `/trending-digest` command to SKILL.md
- Define workflow: bash queries + Claude formatting
- No scripts, no scheduling, no background jobs

**Phase 2: Test**
- Manual test: Run `/trending-digest`, verify output
- Verify bash commands work with `gh` CLI
- Validate formatting is readable

**Phase 3: Document**
- Add usage examples to SKILL.md
- Document what trending means (last 7 days, by stars)

**Rollback strategy:**
- Skill command is additive
- Users don't invoke if not useful
- Safe to remove with no dependencies

## Open Questions

1. **Output format:** Markdown table (recommended) or list format?
2. **Trending window:** Last 7 days by default? (Fixed, no config needed)
3. **Manual only:** No scheduling needed since it's manual on-demand? (Confirmed: yes)
