# Skill-Writing & Development Guidelines

This project demonstrates creating reusable skills using **Test-Driven Development** (TDD). These guidelines ensure consistency, quality, and reusability.

## Skill Creation Process (RED-GREEN-REFACTOR)

**REQUIRED:** Every new skill must follow TDD before deployment.

### RED Phase: Write Failing Tests
1. Create 3+ pressure scenarios that test the skill's core capability
2. Run scenarios with subagent **WITHOUT the skill present**
3. Document exact baseline behavior:
   - What searches/approaches does the agent naturally use?
   - What gaps or inefficiencies exist?
   - What rationalizations do they make?
4. This becomes the starting point for skill content

### GREEN Phase: Write Minimal Skill
1. Create `skills/[skill-name]/SKILL.md` with:
   - YAML frontmatter: `name` (kebab-case) and `description` (starts with "Use when...")
   - Overview: 1-2 sentence core principle
   - When to Use: Triggering conditions (symptoms, not just use cases)
   - Core Pattern: Step-by-step technique or workflow
   - Quick Reference: Table or bullets for scanning
   - Implementation: Code or workflow details
   - Common Mistakes: Issues discovered during RED phase testing
   - Real-World Impact: Concrete results

2. Create supporting script at `skills/[skill-name]/[skill-name].sh` if needed (>100 lines)

3. Address **ONLY the gaps found in RED phase** testing (not hypothetical gaps)

### REFACTOR Phase: Test & Polish
1. Run scenarios again **WITH the skill present**
2. Agent should now comply with skill guidance
3. If agent finds new workaround, add explicit counter to skill
4. Update rationalization table with new findings
5. Test until bulletproof

## Script Consistency Rules

All scripts in `skills/*/scripts/` and `skills/[skill-name]/` must follow these patterns:

### Argument Parsing
```bash
# Consistent pattern for all scripts
PARAM=${PARAM:-default_value}
while [[ $# -gt 0 ]]; do
  case $1 in
    --option) PARAM="$2"; shift 2 ;;
    --flag) FLAG=true; shift ;;
    *) shift ;;
  esac
done
```

### GitHub Token Handling
```bash
# Auto-detect from environment or gh CLI
if [[ -z "$GITHUB_TOKEN" ]]; then
  if command -v gh &> /dev/null; then
    GITHUB_TOKEN=$(gh auth token 2>/dev/null || echo "")
  fi
fi
```

### Cache Management
```bash
# Use project-wide cache location
CACHE_DIR="$HOME/.oss-contributor/cache/[category]"
mkdir -p "$CACHE_DIR"

# Normalize cache key
CACHE_SLUG=$(printf '%s' "$INPUT" | tr '[:upper:]' '[:lower:]' | tr -c 'a-z0-9._-' '-')
CACHE_FILE="$CACHE_DIR/cache-${CACHE_SLUG}.json"

# Check cache (2 hours = 7200 seconds)
file_mtime() {
  stat -f%m "$1" 2>/dev/null || stat -c%Y "$1" 2>/dev/null || echo 0
}
CACHE_AGE=$(( $(date +%s) - $(file_mtime "$CACHE_FILE") ))

if [[ $USE_CACHE == true ]] && [[ -f "$CACHE_FILE" ]] && [[ $CACHE_AGE -lt 7200 ]]; then
  echo "📦 Using cached results..." >&2
  cat "$CACHE_FILE"
  exit 0
fi
```

### Consistent Output Format
1. Status messages to `stderr` (>&2)
2. Results to `stdout`
3. Use markdown tables and links
4. Show generation timestamp

## Skill Naming & Discovery

### Naming Convention
- Use kebab-case: `explore-ai-repos`, not `exploreAiRepos` or `explore_ai_repos`
- Names should be verb-first when possible: `creating-skills` > `skill-creation`

### Description Field (Critical for Discovery)
- **Always** start with "Use when..." to focus on triggering conditions
- Describe the **problem**, not the workflow
- Third person, no narrative storytelling
- Under 500 characters if possible

**Good description:**
```yaml
description: Use when seeking lesser-known Python AI/ML projects to contribute to, beyond trending repos—filter by AI topics (LLM, agent, RAG, vector-db) to find quality projects with real contribution opportunities
```

**Bad description:**
```yaml
description: Find Python AI repos by topic, run GitHub API searches, assess maintainer responsiveness, and show unassigned issues
```

## Testing Standards

### Unit Testing
- Scripts must handle edge cases (empty results, API errors, rate limits)
- Test with `--no-cache` to verify fresh API calls work
- Verify output format is correct (markdown tables, links)

### Integration Testing
- Test skill integrates with other project skills (`/repo-details`, `/find-repos`)
- Verify cache TTL works (2 hours)
- Test with and without GitHub token

### Validation Criteria
1. Agent can discover skill from description
2. Agent correctly applies skill to relevant tasks
3. Skill output directly enables next action (click links, run follow-up commands)

## Documentation Standards

### SKILL.md Structure
- Frontmatter with `name` and `description`
- Overview (core principle)
- When to Use (conditions + symptoms)
- Core Pattern (techniques)
- Quick Reference (scannable table/bullets)
- Implementation (code or workflow)
- Common Mistakes (from testing)
- Real-World Impact (results)
- See Also (related skills/references)

### Script Documentation
- Comment explaining purpose in first 5 lines
- Usage examples in comments
- Input validation with clear error messages
- Consistent help/error text

## Version Control

### Commit Messages
Include TDD context in commit message:
```
Add [skill-name] skill for [purpose]

Includes SKILL.md and [script-name].sh

Created via Test-Driven Development:
- RED: [What was the baseline failure?]
- GREEN: [What does the skill teach?]
- REFACTOR: [How was it validated?]

Usage: /[skill-name] --option value

Co-Authored-By: Claude Haiku 4.5 <noreply@anthropic.com>
```

### File Organization
```
skills/
  [skill-name]/
    SKILL.md              # Main reference (required)
    [skill-name].sh       # Script (if >100 lines)
    README.md             # Optional: additional docs
```

## Performance & Cost

- **Fresh query:** ~5-15s (API call + parallel fetches)
- **Cached results:** Free & instant (2-hour TTL per key)
- **GitHub API:** Unauthenticated = 60/hr; authenticated = 5000/hr
- Scripts auto-detect `gh auth login` token

## Quality Checklist (Before Commit)

- [ ] Script works locally and follows bash best practices
- [ ] Cache location uses `$HOME/.oss-contributor/cache/`
- [ ] GitHub token auto-detection implemented
- [ ] SKILL.md description starts with "Use when..."
- [ ] Common Mistakes section has 3+ real findings
- [ ] Output format consistent with other skills
- [ ] Error handling for API rate limits and missing data
- [ ] Timestamp in output (generated time)
- [ ] RED-GREEN-REFACTOR cycle documented in commit message

## Related References

- `skills/oss-contributor/SKILL.md` — The original `/find-repos` skill
- `skills/oss-contributor/scripts/find-repos.sh` — Reference implementation
- `skills/explore-ai-repos/SKILL.md` — Example of TDD skill creation

## See Also

- [superpowers:writing-skills](https://claude.com) — Full TDD methodology
- [GitHub API Documentation](https://docs.github.com/en/rest)
- [GitHub Search Syntax](https://docs.github.com/en/search-code/getting-started-with-searching-on-github)
