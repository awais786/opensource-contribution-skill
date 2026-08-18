# Agentic Coding Onboarding Course — Design

**Date:** 2026-08-18 (supersedes `2026-08-18-claude-onboarding-course-design.md`)
**Owner:** Awais Qureshi
**Status:** Draft — awaiting review, then implementation plan

---

## Purpose

Take an experienced engineer who has never meaningfully used an agentic coding tool and make
them a competent daily driver of whichever one they use. Competent means four specific things,
which are the course's four topics: they maintain a working agreement with the agent, they
manage context deliberately, they choose models on purpose, and they specify before they build.

The course is not a feature tour. Every module is organised around a failure that a new user
reliably hits in their first two weeks, and the exercise is the proof they no longer hit it.

## Audience

Experienced developers with zero or shallow agentic-tool use. They can code. They do not know
what a project instructions file does, why their session forgets things, or that model choice
is a decision they own.

**Prerequisite: working Django familiarity.** The learner must be able to read a Django view,
run migrations and write a test without looking things up. This is not gatekeeping — a learner
who is meeting Django for the first time spends Modules 2 and 4 learning the ORM and the auth
framework instead of learning context discipline, and the vehicle becomes the subject. The
README states this prerequisite plainly and points elsewhere for Django fundamentals.

Explicitly out of scope: non-engineers, existing power users, and engineers new to Django.

## Vendor neutrality

The four disciplines are properties of working with a coding agent, not of any product. Two of
them — spec-driven development and model selection — are already tool-independent. Two —
the working agreement and context management — are universal in principle and divergent in
mechanics. Only setup is irreducibly per-tool.

### Supported tools

**Tier 1** — full mechanics, walkthroughs and exercises: **Claude Code**, **Cursor**,
**GitHub Copilot** (agent mode).

**Tier 2** — named in the mapping tables, no dedicated setup or walkthrough: **Windsurf**,
**Codex**, **Aider**, **Gemini CLI**.

Tier 1 is deliberately three. Each additional tool multiplies the volatile surface that must be
re-verified every time the course is revised.

### The anti-lowest-common-denominator rule

Vendor-agnostic writing degrades into uselessness by default: "use your tool's context feature"
teaches nothing. The rule for this course:

> Every module states its principle neutrally, then gives a **mechanics by tool** table naming
> a real, concrete mechanic for each Tier 1 tool. If a technique cannot be named concretely for
> a tool, that tool does not claim support for that technique — the table says so.

Worked walkthroughs are shown in **one** tool — Claude Code, as the reference implementation —
because a neutral walkthrough demonstrates nothing. Exercises and verification criteria are
tool-neutral.

### The AGENTS.md situation

Verified 2026-08-18, and the single most useful fact Module 1 teaches:

- `AGENTS.md` is an open standard under the Linux Foundation's Agentic AI Foundation, adopted by
  60,000+ repositories and read natively by Cursor, GitHub Copilot, Codex, Windsurf, Aider,
  Gemini CLI and Zed.
- **Claude Code is the holdout.** Its memory model still reads `CLAUDE.md`; no native
  `AGENTS.md` path had shipped as of August 2026.

Module 1 therefore teaches `AGENTS.md` as the default and treats Claude Code as a named
exception, with the practical bridge (a `CLAUDE.md` that points at `AGENTS.md`) shown explicitly.
This status **must be re-verified at every course revision** — it is the fact most likely to
change.

## Format

Hybrid:

- **Markdown modules are the source of truth.** Readable standalone, publishable, portable.
- **A runner drives the learner through them**, teaching the current module, setting its
  exercise, verifying the result against the learner's working copy, and logging the outcome.

The runner is split so it is not Claude-only:

- `runner-prompt.md` — tool-neutral. States the teaching loop, the verification procedure, the
  logging format, and the hard rules. Any capable agent can be pointed at it.
- `skills/agentic-onboarding/SKILL.md` — a thin Claude Code wrapper over that prompt.
- Cursor and Copilot users reference `runner-prompt.md` directly (rules file or @-mention).

## Scope

Six modules: setup plus the four named topics plus a capstone. Skills/extension authoring,
subagents, hooks, MCP and permissions tuning are **out of scope**.

Django is the *vehicle*, not a subject. The course does not teach Django to people who already
know it. It teaches agentic coding practice using a Django codebase, because abstract exercises
produce abstract learning.

## The practice project

Every exercise runs against one project the learner builds across the course: a Django sign-in
application. The course ships a minimal seed; the learner builds the authentication features on
top of it, module by module. This is tool-independent by construction.

### What the seed contains

```
course/agentic-coding/seed/
  manage.py
  requirements.txt
  README.md
  signin/                 project: settings, urls, wsgi
  accounts/               app: minimal models, one or two views, urls
  accounts/tests/         a small, passing test suite
```

The seed is scaffolding, not the lesson. It deliberately does **not** contain sign-up, log-in,
log-out, password reset or two-factor — those are the exercise material.

The seed carries two or three realistic warts (a view doing too much, a code path with no test
coverage), documented in its README as intentional. Modules 2 and 4 need something real to work
on; a spotless skeleton gives them nothing.

### Why a seed rather than the learner's own repository

Everyone starts identical, so exercises are reproducible across tools, verification is reliable,
and the course can ship a reference solution. A learner may run exercises against their own work,
but the written verification criteria assume the seed.

### Security posture

The application uses Django's built-in authentication throughout. The course never has a learner
hand-roll password hashing, session handling or token generation. Where an exercise touches
security-relevant ground — password reset tokens, rate limiting, CSRF — the module states the
framework mechanism to use and why rolling your own is the wrong answer.

## Repository layout

```
course/agentic-coding/
  README.md                    syllabus, tool support matrix, how to start
  modules/
    00-first-session/          per-tool setup: claude-code.md, cursor.md, copilot.md, shared.md
    01-working-agreement.md
    02-context-management.md
    03-models-and-budgets.md
    04-spec-driven-development.md
    05-capstone.md
  seed/                        the Django sign-in skeleton
  reference/                   completed solution per module
  runner-prompt.md             tool-neutral runner logic
  progress-template.md         copied into the learner's working copy at kickoff
skills/agentic-onboarding/
  SKILL.md                     Claude Code wrapper over runner-prompt.md
```

The course lives in this repository for now: skill conventions, TDD process and review standards
already exist here. It is self-contained and extractable without rework.

## Module structure

Every module file has the same eight sections, in this order.

1. **Objective** — one sentence, what they can do afterwards.
2. **The failure this prevents** — the concrete first-two-weeks pain. Motivation before mechanism.
3. **Concepts** — the minimum model needed to do the exercise, stated tool-neutrally.
4. **Mechanics by tool** — a table naming concrete mechanics for each Tier 1 tool, with Tier 2 where known.
5. **Walkthrough** — a worked example in the reference tool, read not run.
6. **Exercise** — done against the practice project, tool-neutral.
7. **Verification criteria** — explicit, written as what a pass looks like. Grades artefacts, never tool transcripts.
8. **Common mistakes** — populated from RED-phase findings, not invented.

## Syllabus

Order is by which failure arrives soonest. The application grows feature by feature.

### Module 0 — First session
Shared: what all agentic tools have in common — the loop, reviewing a diff before accepting it,
permission and approval models, when to stop the agent. Then a per-tool setup file: install,
authentication, opening the project, running a first task.
*Exercise:* get the seed running and its tests passing, then land one small real change — fix the
untested code path or add a health-check view. Review the diff, commit it.
*Verification:* tests pass; a commit exists; the learner can state what the agent changed and why they accepted it.

### Module 1 — Working agreement
Project instructions files: what belongs in them, what does not, why "be helpful" is worthless and
"run `python manage.py test` before claiming done" is not. `AGENTS.md` as the standard, per-tool
files as the exceptions, and how to avoid maintaining five near-identical files. Scope discipline.
Asking for verification rather than assurances.
*Exercise:* write an `AGENTS.md` for the sign-in project covering at minimum the test command, the
migration policy (generated, never hand-edited), where settings live, and project conventions.
Wire it up for the learner's tool. Demonstrate a behaviour change with and without it.
*Verification:* the file contains project-specific, checkable instructions — not generic advice that
would apply to any repository; the tool actually reads it; the learner can name the observed difference.

### Module 2 — Context management
What occupies context, what compaction or truncation costs, clearing as a routine rather than a
panic button, scoping reads to the parts of files that matter, and delegating side quests to keep
the main thread clean. Recognising the symptoms of a session that has lost the thread.
*Exercise:* implement sign-up and log-in. This is deliberately a sprawling multi-file Django task —
model or form, view, URL, template, tests, settings — the shape that reliably exhausts a context
window in any tool. Do it once naively, observe what happens, then re-run with context discipline.
*Verification:* sign-up and log-in work and are tested; the learner can name what filled context the
first time and which specific technique they applied the second.

### Module 3 — Models and token budgets
The most naturally vendor-agnostic module: every Tier 1 tool exposes a model picker spanning
multiple vendors. The current roster and what each model is for. Context window vs output cap vs
thinking budget — three different limits routinely confused for one. Where each tool exposes model
choice, and what a task costs before you run it.
*Exercise:* two tasks of different character against the same codebase — a mechanical one (back-fill
tests for the existing views) and a design one (choose an approach for password reset). Run each on
two models. Record quality, latency and cost.
*Verification:* a written comparison that defends a default for each kind of task, rather than stating a preference.

### Module 4 — Spec-driven development
Fully tool-independent. Brainstorm → spec → plan → implement → verify. Why the expensive mistakes
are the ones made before any code is written. How to tell a spec that constrains implementation from
one that merely describes a wish.
*Exercise:* take password reset through the full chain. The spec must state token expiry, single-use
semantics, the behaviour on an unknown email address, and what is covered by tests.
*Verification:* a spec file exists, contains no placeholders, its acceptance criteria are testable, and
the implementation matches it.

### Module 5 — Capstone
One feature of real substance — login rate limiting, or TOTP two-factor — with all four disciplines
applied: specified first, model chosen deliberately, context managed, verified before being called
done. Graded against a rubric drawn from the five preceding modules' criteria.

## Duration and delivery

Roughly **14–16 hours hands-on**, self-paced over two to three weeks.

| Module | Hands-on | What drives the estimate |
|---|---:|---|
| 0 — First session | ~1h | Install, authentication, Django environment, seed green, one small change |
| 1 — Working agreement | ~1.5h | Writing a genuinely specific instructions file takes iteration |
| 2 — Context management | ~3.5h | Sign-up and log-in implemented twice — naive, then disciplined |
| 3 — Models and budgets | ~2h | Two tasks across two models, plus the written comparison |
| 4 — Spec-driven development | ~3h | Password reset through the full chain, spec included |
| 5 — Capstone | ~3.5h | TOTP or rate limiting under full discipline, graded |

**Module 2's double implementation is the lesson, not padding.** Context exhaustion has to be
felt once to be believed. It is also the module most likely to need two sittings, and the
README should say so rather than letting learners think they have fallen behind.

**These are not coding hours.** The agent does the typing. The time goes into reviewing diffs,
iterating on instructions, and writing the comparisons and specs. The README states this
explicitly, because learners who expect to be typing conclude they are doing it wrong.

### Delivery shapes

- **Self-paced, one module per sitting, two to three weeks.** Recommended. The gap between
  sittings is where the practices meet the learner's real work, which is where they stick.
- **Cohort: six two-hour sessions over three weeks.** Works with a facilitator; Module 2 needs
  the full slot and then some.
- **Intensive: two consecutive days.** Not recommended. Modules 2 and 5 are the ones fatigue
  damages most, and both land late.

## Django-specific material, distributed

| Pattern | Where it lands |
|---|---|
| Test command, migration policy, settings layout | Module 1, as `AGENTS.md` content |
| Multi-file feature sprawl; ORM and settings as context traps | Module 2, as the core exercise |
| Mechanical test-writing vs design work as different model jobs | Module 3, as the two tasks |
| Migration and security criteria as testable acceptance criteria | Module 4, in the spec |
| Framework mechanisms over hand-rolled auth | Module 5, in the review rubric |

## The runner

**Skill name:** `agentic-onboarding`
**Description:** must start with "Use when…" per the repository's skill conventions.

**Behaviour, defined once in `runner-prompt.md`:**

1. On first invocation, help the learner copy the seed into a working directory, confirm the test
   suite passes, record which tool they are using, and place `progress.md`.
2. On each invocation, read `progress.md`, resume at the current module, teach from the module file,
   showing the mechanics row for the learner's recorded tool.
3. Set the exercise and stop. The learner does the work.
4. On return, verify: deterministic facts by inspection (do the tests pass, does the file exist, was
   there a commit, does the spec contain placeholders), everything qualitative judged against the
   module's written verification criteria.
5. Append a dated entry to `progress.md` recording what passed, what did not, and the specific gap.

**Hard rule:** the runner never edits the learner's code during an exercise. It may read anything and
explain anything. Doing the homework destroys the only signal the course has. The `reference/`
solutions exist for the author and for a genuinely stuck learner, and are offered only after a
failed attempt.

**Failure reporting is specific.** "Your AGENTS.md is too vague" is useless. "Lines 4–6 are generic
advice that would apply to any repository; nothing here tells the agent how to run your tests" is
the standard.

## Build constraints

**Volatile facts are sourced, never remembered — for all three Tier 1 tools.** Model identifiers,
context windows, pricing, limits, flag names, file conventions and feature availability are verified
against official documentation at build time. The README states the date the tool matrix was last
verified. This is now three times the volatile surface of a single-vendor course and is the main
ongoing maintenance cost of vendor neutrality.

**The AGENTS.md / CLAUDE.md split is the highest-churn fact in the course.** Re-verify first, every revision.

**Django version is pinned and stated.** The seed pins Django and Python in `requirements.txt`; the
README names the versions the course was written against.

**The runner owes a RED phase.** Per this repository's CLAUDE.md, every skill goes through
RED-GREEN-REFACTOR. Scenarios run against the module content with no runner present; the gaps
observed define what the runner is for and populate each module's Common Mistakes section.

**Content before mechanics.** The seed and modules 0–2 are written and tested before the runner is
built, so the runner is designed against real content.

**Tier 1 parity is tested, not assumed.** Before release, Module 1 and Module 2 exercises are run
end-to-end in each Tier 1 tool. A mechanics table written from documentation alone is a guess.

## Success criteria

1. A new engineer completes all six modules **in any Tier 1 tool** and ends with a working Django
   sign-in application containing sign-up, log-in, password reset and the capstone feature — all tested.
2. Each module's exercise produces an artefact — a commit, an instructions file, a written comparison,
   a spec — and verification grades the artefact, never the tool.
3. No module contains a vague cross-tool instruction; every technique names a concrete mechanic per
   Tier 1 tool or declares the tool unsupported for it.
4. The runner works both as a Claude Code skill and as a prompt handed to another agent.
5. Modules read correctly standalone, without any runner.
6. The seed's test suite passes on a clean checkout, on the pinned Django and Python versions.
7. No factual claim about tools, models, limits or pricing is sourced from memory.

## Open decisions

None blocking. To revisit after the seed and modules 0–2 are drafted:

- Whether the capstone rubric warrants a machine-readable form, or stays prose.
- Whether Tier 1 should drop to two tools if parity testing proves expensive.
- Whether the course stays in this repository or is extracted once it stabilises.
