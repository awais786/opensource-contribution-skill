# Skill Review: oss-contributor

## ✅ Strengths

### 1. **Clear Architecture**
- Well-organized folder structure
- SKILL.md defines scope clearly
- References are independent and self-contained
- Good separation of concerns

### 2. **Documentation Quality**
- Comprehensive README
- Each route has dedicated reference file
- Shared rules are explicit
- State management documented

### 3. **User Experience**
- Clean command naming (`/trending-repos`)
- Clear installation instructions
- Good error messages
- Caching for efficiency

### 4. **Cost Optimization**
- Uses Claude Haiku (appropriate for data formatting)
- 2-hour caching reduces API calls
- Rate limit aware

---

## ⚠️ Issues & Recommendations

### 1. **Missing Reference Files** 🔴 CRITICAL
Only `00-trending-repos-digest.md` is implemented. Others missing:
- `00-contributor-profile.md` ❌
- `00-target-repositories.md` ❌
- `01-repo-discovery.md` ❌
- `02-repo-health.md` ❌
- `03-codebase-orientation.md` ❌
- `04-issue-discovery.md` ❌
- `05-pull-request-quality.md` ❌
- `06-maintainer-collaboration.md` ❌
- `07-contribution-portfolio.md` ❌
- `08-learning-resources.md` ❌

**Fix:** Create stub files or remove from SKILL.md routes until implemented.

**Recommendation:**
```markdown
# Impact: Currently only 1/11 routes work
# Priority: HIGH - Document what's implemented vs planned
```

### 2. **Script Implementation Incomplete** 🟡 MEDIUM
- `trending-digest.sh` exists but might not integrate with Claude Code properly
- No error handling for missing `gh` CLI
- No fallback if GitHub API is down
- Python formatting section incomplete (cut off at line 80+)

**Fix:** Complete and test the script end-to-end.

### 3. **Missing Supporting Scripts** 🟡 MEDIUM
SKILL.md references:
- `scripts/preflight.py` — Not implemented
- `scripts/collect.py` — Not implemented
- `scripts/store.py` — Not implemented

These are mentioned but don't exist. Either implement or remove references.

### 4. **Configuration Files Missing** 🟡 MEDIUM
- `references/thresholds.yaml` — Exists but empty/not integrated
- State directory (`~/.oss-contributor/`) — Created on-demand but not documented setup

**Fix:** Add initialization script or clear setup instructions.

### 5. **Shared Rules Not Enforced** 🟡 MEDIUM
SKILL.md defines 8 shared rules but no mechanism to enforce:
- Citation requirements
- Evidence checking
- Sample size reporting
- No `scripts/verify.py` referenced but not implemented

**Fix:** Clarify which rules apply to `/trending-repos` vs future routes.

### 6. **Error Handling** 🟡 MEDIUM
- Shell script silently fails with `2>/dev/null`
- No user-friendly error messages
- GitHub API errors are swallowed

**Fix:** Add explicit error handling:
```bash
if [[ -z "$PYTHON_DATA" ]] || [[ "$PYTHON_DATA" == "[]" ]]; then
  echo "❌ No repos found. Check: gh auth status" >&2
  exit 1
fi
```

### 7. **Testing** 🔴 RED FLAG
- No tests for any scripts
- No validation that commands work end-to-end
- No test fixtures or examples

**Recommendation:** Add tests:
```bash
tests/
├── trending-repos.bats
└── fixtures/
    └── sample-repos.json
```

### 8. **Model Configuration Outdated** 🟡 MEDIUM
References old "trending-digest" name in Model Configuration section (line 64):
```
### Trending Digest (Cost-Optimized)
The **trending-digest** route uses Claude Haiku...
```

Should be: "**trending-repos**"

### 9. **Documentation Inconsistencies** 🟡 MEDIUM
- README says "copy to ~/.claude/skills/" but SKILL.md doesn't specify this location
- Example outputs use old dates (2024-01-16, 2026-07-29)
- Some options documented in README not in SKILL.md

---

## 🎯 Recommendations by Priority

### **P0 - Fix Before Use** 🔴
1. ✅ Rename remaining "trending-digest" → "trending-repos" in SKILL.md (DONE)
2. ❌ Implement/test trending-repos.sh end-to-end
3. ❌ Add error handling for missing `gh` CLI
4. ❌ Test with actual GitHub API

### **P1 - Before Release** 🟡
1. ❌ Add stub reference files for unimplemented routes
2. ❌ Implement `scripts/preflight.py` or remove from docs
3. ❌ Document state directory initialization
4. ❌ Add basic tests (bash or Python)

### **P2 - Nice to Have** 🟢
1. Add version checking for `gh` CLI
2. Add telemetry/logging for debugging
3. Create CHANGELOG
4. Add example output with real repos

---

## 📋 Best Practices Checklist

| Practice | Status | Note |
|----------|--------|------|
| Clear architecture | ✅ | Well-organized |
| Documentation | ⚠️ | Good but incomplete |
| Error handling | ❌ | Needs work |
| Testing | ❌ | No tests |
| Security | ✅ | Good (no credentials stored) |
| Performance | ✅ | Caching implemented |
| Versioning | ❌ | No version tracking |
| Contributing guide | ❌ | Not present |
| License | ✅ | MIT included |
| Logging | ⚠️ | Basic stderr only |

---

## 🚀 Quick Wins (30 min)

1. **Fix Model Config name** (1 min)
   ```bash
   sed -i 's/trending-digest/trending-repos/g' skills/oss-contributor/SKILL.md
   ```

2. **Add error handling to script** (5 min)
   ```bash
   # Add to trending-digest.sh after API call
   if [[ -z "$PYTHON_DATA" ]]; then
     echo "❌ GitHub API failed" >&2
     exit 1
   fi
   ```

3. **Create CONTRIBUTING.md** (10 min)
   - How to test
   - How to add new routes
   - Code standards

4. **Add basic validation** (15 min)
   ```bash
   # Check gh installed
   if ! command -v gh &> /dev/null; then
     echo "❌ GitHub CLI not installed: brew install gh"
     exit 1
   fi
   ```

---

## Summary

| Category | Grade | Issues |
|----------|-------|--------|
| **Architecture** | A | Clean, modular |
| **Documentation** | B+ | Good but incomplete routes |
| **Implementation** | C | Script incomplete, no tests |
| **Error Handling** | C | Needs improvement |
| **Maintainability** | B | Clear code, missing tests |
| **Overall** | B- | Good foundation, needs completion |

---

## Next Steps

1. **Complete trending-repos.sh** implementation
2. **Add error handling** and validation
3. **Write tests** (at least smoke tests)
4. **Fill in reference files** or document as planned
5. **Add CONTRIBUTING.md** for future contributors

---

**Status:** ⚠️ **Functional but incomplete**
- trending-repos works for basic use
- Other 10 routes not implemented
- Missing error handling and tests
- Needs polish before production use
