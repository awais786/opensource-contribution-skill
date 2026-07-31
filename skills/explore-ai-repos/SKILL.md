---
name: explore-ai-repos
description: Use when seeking lesser-known Python AI/ML projects to contribute to, beyond trending repos—filter by AI topics (LLM, agent, RAG, vector-db) to find quality projects with real contribution opportunities
---

# Explore AI Repositories

## Overview

**Finding quality AI projects is harder than finding trending ones.** Trending repos (AutoGPT, LangChain, Hermes) are massive, gatekept, or oversubscribed. Lesser-known but well-maintained AI projects exist in the 500-20,000 star range, organized by AI topic (LLM, agent, RAG, retrieval), with real contribution opportunities.

This skill teaches systematic exploration: search by AI topic instead of keywords, batch-validate contribution readiness, and focus on projects actively seeking help.

## When to Use

**Use when:**
- You want Python AI/ML repos to contribute to, but don't want to fight for attention on mega-projects
- You're targeting a specific AI area (retrieval systems, LLM inference, agent orchestration, vector databases)
- You need a quick assessment of which repos welcome external contributions
- You want high-quality but underexplored projects

**Symptoms you need this:**
- "AutoGPT is too complex"
- "I want a smaller project where my contributions matter"
- "How do I find AI repos beyond what's trending?"
- "Is this repo actually accepting contributions?"

**Don't use if:**
- You're already familiar with niche AI projects in your area
- You prefer building from scratch rather than contributing
- You need enterprise-grade, battle-tested libraries (use trending repos for that)

## Core Pattern

### Step 1: Search by AI Topic (Not Keywords)

GitHub has explicit AI topics. Search by these instead of generic keywords:

**Primary AI Topics:**
- `llm` — Large Language Models
- `agent` — Agentic frameworks / orchestration
- `rag` — Retrieval-Augmented Generation
- `vector-database` — Vector storage systems
- `embeddings` — Embedding generation and search
- `inference` — Model inference / serving
- `fine-tune` — Model fine-tuning / LoRA
- `prompt-engineering` — Prompt optimization
- `semantic-search` — Semantic search systems

**Compound searches:**
Combine topics with star range to find sweet spot:
```bash
# High quality, not mega (sweet spot for contributions)
language:python topic:rag stars:500..15000

# Vector databases - active and less crowded
language:python topic:vector-database stars:200..8000

# Emerging agent frameworks
language:python topic:agent stars:300..5000 created:>2023
```

### Step 2: Batch-Validate Contribution Readiness

For each candidate, check these in order (< 2 minutes per repo):

**The 30-Second Filter:**
1. Last commit within 3 months? (Dead repos = skip)
2. More than 1 contributor? (Solo projects reject PRs)
3. `CONTRIBUTING.md` exists or README has contribution section?
4. Has issues labeled `good-first-issue` or `help-wanted`?

**The 2-Minute PR Assessment:**
1. Sort recent merged PRs by date
2. Average time-to-merge < 2 months? (Good)
3. Maintainer reviews substantively (asks for tests/docs) or rubber-stamps?
4. Are they actually open to external contributions?

**Red Flags (eliminate immediately):**
- No commit in 6+ months
- CONTRIBUTING.md says "no external contributions"
- All PRs from the same 2-3 people (gatekept)
- Issues open 12+ months without response

### Step 3: Use the Find Script

Run the automated discovery script to search by topic and surface unassigned issues:

```bash
/explore-ai-repos --topic rag --stars 500..15000
/explore-ai-repos --topic vector-database
/explore-ai-repos --topic agent --created 2023
```

Output will show:
- Top repos matching criteria
- Star count + last commit date
- Unassigned issues per repo
- Quick readiness assessment per repo

## Quick Reference

### AI Topics by Domain

| Domain | Primary Topics | Key Keywords |
|--------|---|---|
| **LLM / Language** | `llm`, `prompt-engineering` | inference, fine-tune, serving |
| **Retrieval** | `rag`, `vector-database`, `semantic-search` | embeddings, similarity, chunking |
| **Agents** | `agent`, `multi-agent` | orchestration, framework, agentic |
| **ML Ops** | `mlops`, `model-serving` | deployment, monitoring, inference |
| **Fine-tuning** | `fine-tune`, `lora` | parameter-efficient, adapters |

### Star Range Guidelines

| Range | Use Case |
|-------|----------|
| **50-500** | Emerging projects, higher risk but novel work |
| **500-5,000** | Sweet spot for contributions; active, not mega |
| **5,000-20,000** | Mature, quality, but getting crowded with contributors |
| **20,000+** | High barrier to entry; use only if deeply invested |

## Implementation

### Using the Skill (with Script)

**Basic search by topic:**
```bash
/explore-ai-repos --topic rag
# Shows: top 10 RAG repos (500-15k stars), unassigned issues, readiness score
```

**Narrow by sub-topic and stars:**
```bash
/explore-ai-repos --topic vector-database --min-stars 200 --max-stars 5000
```

**Find emerging agents:**
```bash
/explore-ai-repos --topic agent --created 2023-06-01
```

**Check contribution readiness quickly:**
```bash
/explore-ai-repos --topic llm --readiness-only
# Shows only repos with active maintainers + good-first-issue labels
```

### Manual Search (Without Script)

If the script isn't available, do this manually:

1. Go to GitHub Search
2. Use: `language:python topic:RAG stars:500..15000 sort:stars`
3. For each result, check:
   - Last commit date
   - CONTRIBUTING.md existence
   - Recent PR merge time
   - Issue quality (specific vs. vague)

## Common Mistakes

**Mistake 1: Searching by Keywords Instead of Topics**
- ❌ Search: `python rag retrieval`
- ✅ Instead: `language:python topic:rag`
- **Why:** Topics are explicit, keywords catch noise. Topic search finds real RAG projects.

**Mistake 2: Ignoring the Star Range**
- ❌ Pick only 50-star projects (too risky; may be abandoned)
- ❌ Pick only 50k+ star repos (too competitive; gatekept)
- ✅ Instead: 500-15,000 range (active + accepting help)
- **Why:** Sweet spot = proven project + real contribution need.

**Mistake 3: Skipping Maintainer Responsiveness Check**
- ❌ "Looks good, let me submit a PR"
- ✅ Instead: Check last 5 merged PRs for response time first
- **Why:** Unresponsive maintainers = your work languishes. Validate before investing.

**Mistake 4: Not Reading CONTRIBUTING.md**
- ❌ Assume contribution is welcome based on stars
- ✅ Instead: Read CONTRIBUTING.md + last 3 PRs from external contributors
- **Why:** Some projects say "no external contributions" explicitly. Saves wasted effort.

**Mistake 5: Picking Repos with Zero "Good First Issue" Labels**
- ❌ "I'll figure it out as I go"
- ✅ Instead: Prioritize repos with 3+ labeled good-first-issues
- **Why:** Labeled issues show maintainer actively curates for contributors.

## Real-World Impact

**Without this skill:**
- Spend 2+ hours manually searching GitHub
- Pick trending repos, lose 20+ potential contributors
- Submit PR to gatekept project, gets rejected
- Contribute to semi-abandoned project, work never merges

**With this skill:**
- 15 minutes: Find 5-10 quality repos in your AI area
- Validate maintainer responsiveness in 2 min per repo
- Pick underexplored project where your work actually lands
- Build real portfolio contribution in active project

**Example Workflow:**
1. Run `/explore-ai-repos --topic rag --min-stars 300`
2. Find 8 RAG projects with 2-5k stars, active maintainers
3. Check readiness of top 3 (5 min total)
4. Pick project with "good-first-issue" + recent PR approvals
5. Start contributing to high-quality but less-crowded project

---

## See Also

- `/find-repos` — Discover trending Python repos (use when you want mainstream projects)
- `/repo-details` — Deep dive on a specific repo you've chosen
- [GitHub Topic Search](https://github.com/topics) — Browse official GitHub topics
- [Awesome Lists](https://github.com/search?q=awesome+ai) — Curated collections by domain

## References

- **GitHub Search Syntax:** [Advanced search](https://docs.github.com/en/search-code/getting-started-with-searching-on-github/understanding-the-search-syntax)
- **Python AI Topics:** `llm`, `agent`, `rag`, `vector-database`, `embeddings` (searchable on GitHub)
