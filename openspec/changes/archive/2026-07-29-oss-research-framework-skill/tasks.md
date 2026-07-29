# Trending Repos Digest Skill - Implementation Tasks

## 1. SKILL.md Command Definition

- [x] 1.1 Add `/trending-digest` command entry to SKILL.md
- [x] 1.2 Define workflow: bash query for Python trending + bash query for non-Python trending
- [x] 1.3 Add Claude Haiku step for formatting results into markdown table
- [x] 1.4 Document command: what it does, how to use, expected output

## 2. Bash Queries Implementation

- [x] 2.1 Test bash command: `gh search repos --language python --sort stars --created ">2024-01-09"` (last 7 days)
- [x] 2.2 Test bash command for non-Python: `gh search repos --language "-python" --sort stars --created ">2024-01-09"`
- [x] 2.3 Verify both queries return at least 15 results
- [x] 2.4 Verify output includes: repo name, stars, description, language, last commit date

## 3. Output Formatting

- [x] 3.1 Create Haiku prompt: "Format these GitHub repos as a markdown table with columns: Rank, Repo, Stars, Description, Language, Last Commit"
- [x] 3.2 Test formatting produces readable, aligned table
- [x] 3.3 Add timestamp to output (when digest was generated, UTC)
- [x] 3.4 Test full workflow end-to-end: `/trending-digest` → queries → formatting → output

## 4. Error Handling & Edge Cases

- [x] 4.1 Test GitHub API error: what happens if `gh` command fails?
- [x] 4.2 Test insufficient results: what if only 5 results instead of 15?
- [x] 4.3 Verify graceful error messages to user
- [x] 4.4 Test rate limits: confirm skill doesn't exceed GitHub API limits

## 5. Model Configuration (COST OPTIMIZATION)

- [x] 5.1 **REQUIRED: Configure skill to use Haiku model (cheapest)**
  - In SKILL.md, set: `model: haiku` or equivalent configuration
  - Do NOT use Opus or Sonnet for this skill
  - Verify in code that Haiku is specified explicitly
- [x] 5.2 Add documentation: "This skill uses Haiku model for cost optimization (no reasoning needed)"
- [x] 5.3 Verify each run costs minimal tokens (~100-200 for formatting only)
- [x] 5.4 Add to README/FAQ: "Why Haiku? Because formatting doesn't need reasoning. Cost per run: ~$0.001"

## 6. Documentation & Testing

- [x] 6.1 Write example output showing what user sees when they run `/trending-digest`
- [x] 6.2 Create FAQ: What counts as "trending"? Why only 7 days? Can I change filters?
- [x] 6.3 Test on real GitHub data: run `/trending-digest` at least 3 times, verify results
- [x] 6.4 **VERIFY HAIKU IS CONFIGURED** - Check SKILL.md, confirm Haiku model is used
- [x] 6.5 Mark skill as ready for use (version v1.0)
