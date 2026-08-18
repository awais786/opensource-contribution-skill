# Review Contract

A terminating code review protocol for coding agents.

Agent review does not converge by default. Asked "is this good?", an agent will always find
something, because any code can be improved indefinitely and producing zero findings feels like
failing the task. Each round invents a fresh standard, re-discovers pre-existing problems, and
re-raises items already settled.

This contract replaces "is this good?" with "does this meet the specification?" — a question with
an answer, and therefore an end.

---

## How to use it

Drop this file into your repository (`review-contract.md` at the root, or alongside your project
instructions file). Fill in **Project settings** at the bottom. Then point your agent at it:

| Tool | How |
|---|---|
| Claude Code | `Review the current diff against @review-contract.md` |
| Cursor | `@review-contract.md` in the prompt, or add it as a rule under `.cursor/rules/` |
| GitHub Copilot | Reference it in chat, or reference it from `.github/copilot-instructions.md` |
| Codex / Windsurf / Aider / Gemini CLI | Reference it from `AGENTS.md` |

If you want every review to follow it without being asked, add one line to `AGENTS.md`:

> Code review follows `review-contract.md`. Do not review outside that contract.

---

## Rule 1 — Review the diff, not the codebase

The reviewable unit is the change under review, not the repository around it.

- In scope: every line the diff adds or modifies, and anything it demonstrably breaks.
- Out of scope: pre-existing problems in untouched code.

Out-of-scope findings are appended to the backlog file and **never block**. Recording them is
useful. Blocking on them means no change can ever merge, because every codebase has a backlog.

## Rule 2 — Only spec-traceable findings block

A finding may block **only** if it cites one of:

1. A specific acceptance criterion in the specification, quoted.
2. A test that fails, named.
3. A documented convention in the project instructions file, quoted.
4. A security or data-loss defect with a concrete exploitation or failure path described.

Everything else is a **nit**: recorded once, never blocking, never re-raised.

"I would have written this differently" is a nit. "This is not idiomatic" is a nit unless it names
the convention it violates. "Consider extracting a helper" is a nit. These are not worthless — they
are simply not grounds to withhold a pass, and treating them as such is what makes review endless.

If the reviewer cannot point at a criterion, a test, a convention, or a failure path, the reviewer
does not have a blocker. It has a preference.

## Rule 3 — PASS is a legitimate and expected outcome

A review that finds no blockers is a **successful review**, not a lazy one.

The review's final line is always exactly one of:

```
VERDICT: PASS
VERDICT: BLOCKED (n blockers)
```

`PASS` may be accompanied by any number of nits. "Approved with suggestions" is `PASS`.
There is no third verdict. "Mostly fine, but..." is not a verdict.

## Rule 4 — Findings freeze after round one

This is the rule that makes the process terminate. The others leak without it.

- **Round 1** produces the complete list of findings. Everything the reviewer intends to raise,
  it raises now.
- **Round 2** verifies *only* two things: that the round-1 blockers were addressed, and that the
  fixes introduced no regressions. It does not go looking for new material.

A second pass that goes hunting will always find something, and a third will find something else.
The list is closed after round 1. New findings in round 2 are admissible only if they are defects
in the round-1 fixes themselves.

## Rule 5 — The ledger carries state

Every finding is recorded in the ledger with a status, so a fresh context cannot re-litigate what
was already settled. Append to the ledger file; never rewrite history.

```markdown
## Review: <branch or diff range> — <date>

### Round 1
| # | Severity | Finding | Cites | Status |
|---|---|---|---|---|
| 1 | BLOCKER | Reset token has no expiry | spec §3 "tokens expire in 30 min" | fixed |
| 2 | BLOCKER | No test for unknown-email path | spec §5 acceptance criteria | fixed |
| 3 | NIT | `_build_url` could take a named arg | — | accepted as-is |

### Round 2
Blockers 1, 2 verified fixed. No regressions.

VERDICT: PASS
```

Statuses are exactly: `fixed`, `accepted as-is`, `deferred to backlog`. An accepted or deferred
finding is closed. It is not raised again in a later review of the same change.

## Rule 6 — Two fix rounds maximum

If the change is still `BLOCKED` after the second fix round, **stop reviewing**.

A third round means the reviewer and the author are working from different standards, and further
review will not reconcile them — it will generate a fourth round. The disagreement is upstream, in
the specification. Escalate: fix the spec, then re-review the change against the corrected spec as
a fresh round 1.

This is the rule people resist, because capping rounds looks like abandoning quality. It is the
opposite. Unbounded review does not produce quality; it produces churn, and eventually the author
starts ignoring the reviewer entirely, which is where quality actually goes to die.

## Rule 7 — Disagreement resolves against the spec

When the reviewer and the author disagree, the specification decides. Not seniority, not who wrote
it, and not who is more insistent.

If the spec is silent on the point, then by Rule 2 the finding is a nit — and the silence is itself
recorded as a spec gap in the backlog, so the next specification is better than this one.

---

## What the reviewer must not do

| Anti-pattern | Why it breaks termination |
|---|---|
| Reviewing the whole file because the diff touched it | Re-discovers the backlog on every pass |
| Raising a nit as a blocker "just to be safe" | Nothing ever passes; the tiers stop meaning anything |
| Finding new issues in round 2 | The list was closed; this restarts the loop |
| Re-raising an `accepted as-is` finding | The ledger exists precisely to prevent this |
| Ending with suggestions instead of a verdict | An unresolved review is an open loop by construction |
| Softening a real blocker to avoid seeming harsh | Ships the defect and wastes the review |
| Padding a clean review with invented findings | The single most common cause of the endless loop |

---

## The procedure, condensed

```
1. Establish scope        → the diff, and the spec it claims to satisfy
2. Round 1                → find everything; classify BLOCKER or NIT by Rule 2
3. Write the ledger       → every finding, with its citation
4. Emit a verdict         → PASS, or BLOCKED (n)
5. If BLOCKED             → author fixes blockers only
6. Round 2                → verify those fixes + regressions ONLY
7. Emit a verdict         → PASS, or BLOCKED (n)
8. If still BLOCKED       → stop. Fix the spec, not the code. Restart at 1.
```

---

## Project settings

Fill these in. A reviewer that cannot find the spec cannot apply Rule 2, and will fall back to
taste — which is the failure this contract exists to prevent.

```yaml
spec_location:        docs/specs/            # where acceptance criteria live
instructions_file:    AGENTS.md              # documented conventions
test_command:         python manage.py test  # must pass for any PASS verdict
ledger_file:          docs/review-ledger.md  # appended, never rewritten
backlog_file:         docs/review-backlog.md # out-of-scope and deferred findings
diff_range:           origin/main...HEAD     # default reviewable unit
max_fix_rounds:       2
```

**Additional blocking criteria for this project** — beyond Rule 2's four. Keep this list short;
every entry here is something that can stop a merge:

- <e.g. migrations must be generated, never hand-edited>
- <e.g. no new dependency without a note in the spec>
- <e.g. authentication changes require a test for the failure path>

**Standing nits** — known preferences that must never be raised as blockers:

- <e.g. line length, import ordering — the formatter owns these>
