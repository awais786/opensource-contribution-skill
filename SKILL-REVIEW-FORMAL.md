# Formal Skill Review: oss-contributor
## Using superpowers:writing-skills Framework

---

## 📋 TDD Compliance Check

### ❌ RED Phase (Baseline Testing)
**Status:** NOT COMPLETED

**Required:** Run pressure scenarios WITHOUT skill to document baseline failures

**What's missing:**
- No documented baseline test runs
- No agent behavior captured before skill existed
- No rationalization patterns identified
- No failure modes enumerated

**Impact:** Can't verify if skill solves real problems or is solving hypothetical ones

**Action Required:** Before deploying, run with subagent:
```
Task: Find trending repos and evaluate [10 repos] for contribution
Pressures: Time crunch, sunk cost (already picked 5), authority (wants specific language)
Document: What decisions does agent make? What rationalizations appear?
```

### ⚠️ GREEN Phase (Minimal Skill)
**Status:** PARTIALLY COMPLETED

**What exists:**
- ✅ `/trending-repos` route implemented and tested
- ✅ Core documentation written
- ❌ Only 1 of 11 declared routes working
- ❌ Other routes reference non-existent documentation

**Problem:** Skill declares 11 routes but implements 1. This violates "write minimal skill addressing baseline failures" — you've written aspirational routes, not minimal addressing identified problems.

### ⚠️ REFACTOR Phase (Close Loopholes)
**Status:** NOT STARTED

**Required:** Test implementation against edge cases and document how agent rationalizes away guidance

**Missing:**
- No pressure-scenario results
- No rationalization table
- No red flags list

---

## 🔍 Skill Discovery Optimization (SDO) Analysis

### 1. Description Field ❌ NEEDS WORK

**Current (SKILL.md line 3):**
```yaml
description: Use for open source contribution work — deciding whether a project is worth contributing to, checking if a repo is active or abandoned, finding issues to work on, learning a project's unwritten conventions, preparing a pull request that will actually be accepted, interpreting maintainer review feedback, tracking a contribution record, or finding learning resources. Triggers on "should I contribute to", "is this project active", "what can I work on", "find me an issue", "will they merge my PR", "what does this project expect", "what did this reviewer mean", "my open source portfolio", and on a bare repository URL offered for assessment.
```

**Issues:**
- ❌ **Too long** (512 chars vs 500 char target)
- ❌ **Lists processes, not conditions** ("deciding", "checking", "finding")
- ❌ **"Triggers on" is implementation detail** (agents don't care HOW skill triggers)
- ❌ **Violates SDO rule:** Description summarizes workflow, agent may follow description instead of reading skill

**Better:**
```yaml
description: Use when deciding whether to contribute to an open source project—evaluating maintainer responsiveness, code health, issue complexity, or your fit with the project's goals and conventions.
```

**Why this works:**
- ✅ Starts with "Use when"
- ✅ Lists CONDITIONS (evaluating X, deciding Y)
- ✅ Concrete triggering scenario
- ✅ 169 chars (well under limit)

### 2. Keyword Coverage ⚠️ INCOMPLETE

**Current keywords in skill:**
- ✅ Project names (microsoft/markitdown)
- ✅ Actions (contribute, evaluate, discover)
- ❌ **Missing error symptoms:** flaky CI, hostile maintainer, stalled issue
- ❌ **Missing problem names:** technical debt, unfriendly community
- ❌ **Missing related tools:** GitHub CLI, PR review
- ❌ **Missing decision points:** "should I fork?", "will this merge?"

**Add to skill:**
```markdown
Synonyms: contribution opportunity, repository quality, maintainer responsiveness, community health, issue complexity, PR acceptance probability
```

### 3. Naming ⚠️ ACCEPTABLE BUT COULD BE STRONGER

**Current:** `oss-contributor`

**Options:**
- ✅ `oss-contributor` (clear, describes role)
- ✅ `evaluating-open-source-projects` (more specific)
- ✅ `finding-contribution-opportunities` (action-oriented)

**Recommendation:** Current naming works. Could be more specific if skill focuses on one route (e.g., `trending-repos` is its own discoverable skill).

### 4. Token Efficiency 🔴 CRITICAL

**Current state:** Only trending-repos is documented. Scope is reasonable.

**If all 11 routes were implemented:**
```
SKILL.md: ~500 words (current)
11 route references: ~200 words each = 2,200 words
Total: ~2,700 words
```

**Problem:** Loading all this into system prompt for every conversation wastes tokens.

**Solution:** Split into sub-skills:
```
oss-contributor (meta-skill, <200 words)
  ├── trending-repos (standalone skill, <300 words)
  ├── repo-health (standalone skill, <300 words)
  ├── issue-discovery (standalone skill, <300 words)
  └── ...
```

---

## 📖 SKILL.md Structure Review

### Frontmatter ✅ CORRECT
```yaml
name: oss-contributor          # ✅ Valid format
description: [see above]        # ⚠️ Needs revision
```

### Content Structure ⚠️ INCOMPLETE

| Section | Status | Issues |
|---------|--------|--------|
| Overview | ✅ Good | Clear 1-2 sentence principle |
| Routes table | ⚠️ Incomplete | 10/11 reference files missing |
| Shared rules | ✅ Excellent | 8 explicit, non-negotiable rules |
| Model config | ⚠️ Outdated | References old "trending-digest" name (FIXED) |
| State management | ✅ Clear | Good specification |

### Missing Sections ❌
- [ ] "When NOT to use" (e.g., when to skip evaluation)
- [ ] "Common Mistakes" (e.g., using old evaluation data)
- [ ] "Real-World Impact" (e.g., how this prevents wasted contributions)

---

## 📝 Reference Documentation Review

### 00-trending-repos-digest.md ✅ EXCELLENT

**Strengths:**
- ✅ Complete workflow documented
- ✅ Multiple examples with different filters
- ✅ Stats breakdown explained
- ✅ Integration points clear
- ✅ Best practices section
- ✅ Common workflows highlighted

**Issues:**
- ⚠️ Very comprehensive (~1500 words) — might belong in separate file
- ⚠️ Old timestamps in examples (2024 dates, should be dynamic)

### Missing Reference Files 🔴 BLOCKING

10 of 11 reference files don't exist:
- `00-contributor-profile.md` — needed for `/profile` route
- `00-target-repositories.md` — needed for `/targets` route
- `01-repo-discovery.md` — needed for `/discovery` route
- ... (7 more)

**Options:**
1. **Implement all 11** (add to roadmap, not deployment)
2. **Remove non-functional routes** (honest scope)
3. **Mark as "Coming Soon"** (set expectations)

**Recommendation:** Remove from SKILL.md routes table until implemented. Document roadmap separately.

---

## 🧪 Testing Status

### Pressure-Scenario Testing 🔴 MISSING

**Required to validate skill:**
1. **Baseline (no skill):** Does agent naively pick wrong projects?
2. **With skill:** Does agent follow evaluation framework?
3. **Combined pressures:** Time + sunk cost + authority

**Current state:** Untested

### Micro-Testing ⚠️ PARTIAL
- ✅ trending-repos script has basic testing
- ❌ No pressure scenarios run
- ❌ No rationalization table from testing

### Test Results 🔴 NOT DOCUMENTED
- No baseline failure modes captured
- No before/after comparison
- No edge cases identified

---

## 🚨 Rationalization Bulletproofing

### Rationalization Table ❌ MISSING

Skill defines 8 shared rules but no rationalization table showing:
- What agents might say to skip rules
- Why those rationalizations are wrong
- Red flags to self-check

**Example needed:**
```markdown
| Rationalization | Reality |
|---|---|
| "That project looks good enough" | Without evaluation framework, you'll waste weeks on unfriendly projects |
| "I'll evaluate as I work" | Evaluation after investment introduces sunk cost bias |
| "This repo is trending so it's worth it" | Trending ≠ good for contributions (often bleeding-edge, closed maintenance) |
```

### Red Flags List ❌ MISSING

Should add checklist for when to stop:
```markdown
## Red Flags - STOP Before Contributing

- No response to issues in 30+ days
- PR review time > 2 months
- Maintainer disputes over direction
- Hostile tone in issues/discussions
- Undocumented contribution process

**All of these mean:** Evaluate another project instead.
```

---

## 🎯 Deployment Checklist Status

| Item | Status | Notes |
|------|--------|-------|
| RED: Baseline scenarios | ❌ | Not completed |
| GREEN: Minimal skill | ⚠️ | trending-repos done, 10 routes missing |
| REFACTOR: Loopholes | ❌ | Not started |
| Name format | ✅ | Valid |
| Description | ⚠️ | Needs revision (too long, lists processes) |
| Keywords | ⚠️ | Missing problem terms |
| Structure | ✅ | Good |
| Tested with subagent | ❌ | Not tested |
| Git committed | ✅ | All files committed |

---

## 💡 Priority Fixes (Before Deploying)

### P0 - Must Fix 🔴

1. **Revise description field**
   ```yaml
   # Current (512 chars, too long, lists processes)
   description: Use for open source contribution work — deciding whether...
   
   # Better (169 chars, starts with "Use when", lists conditions)
   description: Use when deciding whether to contribute to an open source project—evaluating maintainer responsiveness, code health, issue complexity, or your fit.
   ```

2. **Remove non-functional routes from SKILL.md**
   ```markdown
   # Before
   | Show me trending repos | trending-repos | ... |
   | Who am I, what am I good at | profile | ... |  ❌ NOT IMPLEMENTED
   | Find me projects | discovery | ... |           ❌ NOT IMPLEMENTED
   
   # After
   | Show me trending repos | trending-repos | ... | ✅ WORKING
   
   # Add roadmap section
   ## Planned Routes (Coming Soon)
   - profile, targets, discovery, health, orientation, issues, pr-quality, collaboration, portfolio, resources
   ```

3. **Complete trending-repos.sh script**
   - Full implementation (currently cut off)
   - Error handling for missing `gh` CLI
   - Graceful GitHub API failure

### P1 - Should Fix Before Release 🟡

1. Add "Common Mistakes" section
   ```markdown
   ## Common Mistakes
   - Using old evaluation data (> 2 weeks old)
   - Ignoring maintainer response time
   - Picking based on stars alone
   ```

2. Add "Red Flags" checklist
3. Create rationalization table from testing
4. Split trending-repos into standalone sub-skill (token efficiency)

### P2 - Nice to Have 🟢

1. Add "Real-World Impact" section with examples
2. Update example timestamps dynamically
3. Create CONTRIBUTING.md for skill development

---

## Summary Against writing-skills Framework

| Criterion | Rating | Notes |
|-----------|--------|-------|
| **RED Phase** | ❌ 0/10 | No baseline testing done |
| **GREEN Phase** | ⚠️ 5/10 | 1 route working, 10 missing |
| **REFACTOR Phase** | ❌ 0/10 | No loophole closing |
| **SDO: Description** | ⚠️ 4/10 | Too long, lists processes |
| **SDO: Keywords** | ⚠️ 6/10 | Core terms present, missing symptom keywords |
| **SDO: Naming** | ✅ 8/10 | Clear and searchable |
| **Token Efficiency** | ✅ 8/10 | Currently minimal (trending-repos only) |
| **Structure** | ✅ 9/10 | Clear organization |
| **Testing** | ❌ 0/10 | No pressure scenarios |
| **Bulletproofing** | ❌ 0/10 | No rationalization table or red flags |

**Overall: D+** (Idea is strong, execution incomplete)

**Verdict:** Skill is a good foundation but needs completion before production use. Currently only `/trending-repos` is functional and tested. Recommend fixing P0 items before shipping.

---

## Next Steps

### Week 1: Fix Blockers
- [ ] Revise description field (5 min)
- [ ] Remove non-functional routes (10 min)
- [ ] Complete trending-repos.sh script (30 min)
- [ ] Add error handling (15 min)

### Week 2: Test & Bulletproof
- [ ] Run baseline scenarios (with agent)
- [ ] Document rationalizations from testing
- [ ] Build rationalization table
- [ ] Create red flags checklist

### Week 3: Polish
- [ ] Add "Common Mistakes" section
- [ ] Add "Real-World Impact" examples
- [ ] Split into sub-skills if needed
- [ ] Final pressure scenario testing

### Deployment Ready Checklist
- [ ] All P0 fixes complete
- [ ] Pressure scenarios passed
- [ ] Rationalization table filled
- [ ] Red flags list added
- [ ] Git history clean
- [ ] README updated

---

**Reviewed by:** superpowers:writing-skills framework  
**Date:** 2026-07-29  
**Status:** Ready for P0 fixes, then testing
