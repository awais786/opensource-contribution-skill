# Claude Code Onboarding Course — Design

**Date:** 2026-08-18
**Owner:** Awais Qureshi
**Status:** Draft — awaiting review, then implementation plan

---

## Purpose

Take an experienced engineer who has never meaningfully used Claude Code and make them a
competent daily driver. Competent means four specific things, which are the course's four
topics: they maintain a working agreement with Claude, they manage context deliberately,
they choose models on purpose, and they specify before they build.

The course is not a feature tour. Every module is organised around a failure that a new
user reliably hits in their first two weeks, and the exercise is the proof they no longer
hit it.

## Audience

Experienced developers with zero or shallow Claude Code use. They can code. They do not
know what `CLAUDE.md` does, why their session forgets things, or that model choice is a
decision they own.

Explicitly out of scope: non-engineers, and existing power users. A levelling-up course
for the latter is a separate product and should not be smuggled in here.

## Format

Hybrid, as decided in brainstorming:

- **Markdown modules are the source of truth.** Readable, reviewable, publishable
  standalone, and portable if the course later leaves this repo.
- **A skill runs the learner through them.** `/onboard-claude` teaches the current module,
  sets its exercise, verifies the result against the learner's own repository, and logs
  the outcome.

Neither half is optional: the modules without the runner are a document nobody finishes,
and the runner without the modules is an unmaintainable monolith.

## Scope

Six modules: setup plus the four named topics plus a capstone. Skills authoring,
subagents, hooks, MCP, plugins and permissions tuning are **out of scope** and belong to a
follow-on course.

## Repository layout

```
course/claude-onboarding/
  README.md                    syllabus, prerequisites, how to start
  modules/
    00-first-session.md
    01-working-agreement.md
    02-context-management.md
    03-models-and-budgets.md
    04-spec-driven-development.md
    05-capstone.md
  progress-template.md         copied into the learner's repo at kickoff
skills/claude-onboarding/
  SKILL.md                     the runner
```

The course lives in this repository for now: the skill conventions, TDD process and
review standards already exist here. It is self-contained under two directories and can be
extracted to its own repository without rework if it outgrows this one.

## Module structure

Every module file has the same seven sections, in this order. Uniformity is the point —
a learner should never have to work out where the exercise is.

1. **Objective** — one sentence, what they can do afterwards.
2. **The failure this prevents** — the concrete first-two-weeks pain. Motivation before mechanism.
3. **Concepts** — the minimum model needed to do the exercise. No completeness for its own sake.
4. **Walkthrough** — a worked example the learner reads, not runs.
5. **Exercise** — done in the learner's own repository.
6. **Verification criteria** — explicit, written as what a pass looks like. The runner grades against this text.
7. **Common mistakes** — populated from RED-phase findings, not invented.

## Syllabus

Order is by which failure arrives soonest, not by conceptual tidiness.

### Module 0 — First session
Install, authentication, pointing Claude at a repository, the REPL loop, permission modes
and what each one actually allows, reading a diff before accepting it.
*Exercise:* land one real change in their repository, review it, commit it.
*Verification:* a commit exists; the learner can state what Claude changed and why they accepted it.

### Module 1 — Working agreement
`CLAUDE.md`: what belongs in it, what does not, why "be helpful" is worthless and "run
`make test` before claiming done" is not. Scope discipline. Asking for verification rather
than assurances.
*Exercise:* write a `CLAUDE.md` for their repository, then demonstrate a behaviour change with and without it.
*Verification:* the file contains project-specific, checkable instructions; the learner can name the observed difference.

### Module 2 — Context management
What occupies context, what compaction costs, `/clear` as a routine rather than a panic
button, scoping reads to the parts of files that matter, and subagents as context
isolation. Recognising the symptoms of a session that has lost the thread.
*Exercise:* take a task that previously blew up, re-run it with context discipline, compare outcomes.
*Verification:* the learner can name what filled context the first time and which specific technique they applied.

### Module 3 — Models and token budgets
The current model roster and what each is for. Context window vs output cap vs thinking
budget — three different limits routinely confused for one. `/model`, per-subagent model
overrides, fast mode, and the cost of a task as something you can estimate before running it.
*Exercise:* run one task on two models; record quality, latency and cost; justify a default for their work.
*Verification:* a written comparison with a defended default, not a preference.

### Module 4 — Spec-driven development
Brainstorm → spec → plan → implement → verify. Why the expensive mistakes are the ones
made before any code is written. How to tell a spec that constrains implementation from
one that merely describes a wish.
*Exercise:* take one real feature from their repository through the full chain.
*Verification:* a spec file exists, contains no placeholders, and its acceptance criteria are testable.

### Module 5 — Capstone
One feature, all four disciplines applied: specified first, model chosen deliberately,
context managed, verified before being called done. Graded against a rubric drawn from the
five preceding modules' criteria.

## The runner skill

**Name:** `claude-onboarding`
**Description:** must start with "Use when…" per the repository's skill conventions.

**Behaviour:**

1. On first invocation, copy `progress-template.md` into the learner's repository and confirm the starting point.
2. On each invocation, read `progress.md`, resume at the current module, teach from the module file.
3. Set the exercise and stop. The learner does the work.
4. On return, verify: deterministic filesystem facts by inspection (does the file exist, was there a commit, does the spec contain placeholders), everything qualitative judged against the module's written verification criteria.
5. Append a dated entry to `progress.md` recording what passed, what did not, and the specific gap.

**Hard rule:** the runner never edits the learner's code during an exercise. It may read
anything and explain anything. Doing the homework destroys the only signal the course has.

**Failure reporting is specific.** "Your CLAUDE.md is too vague" is useless. "Lines 4–6 are
generic advice that would apply to any repository; nothing here tells Claude how to run
your tests" is the standard.

## Build constraints

**Volatile facts are sourced, never remembered.** Model identifiers, context windows,
pricing, limits and flag names come from the `claude-api` skill and live `/help` output at
build time. Modules keep durable principles in prose and point at official documentation
for anything that moves. A course teaching stale model facts is worse than no course.

**The runner is a skill, so it owes a RED phase.** Per this repository's CLAUDE.md, every
skill goes through RED-GREEN-REFACTOR. Three scenarios run against the module content with
no runner present; the gaps observed there define what the runner is for and populate each
module's Common Mistakes section. The runner is written only after that baseline exists.

**Content before mechanics.** Modules 0–2 are written and tested before the runner is
built, so the runner is designed against real content rather than an imagined shape.

## Success criteria

1. A new engineer completes all six modules using only the course and their own repository.
2. Each module's exercise produces an artefact in the learner's repository — a commit, a `CLAUDE.md`, a comparison, a spec.
3. The runner's verification distinguishes a real pass from a nominal one, and says specifically why when it fails.
4. Modules read correctly standalone, without the runner.
5. No factual claim about models, limits or pricing is sourced from memory.

## Open decisions

None blocking. Two to revisit after Module 0–2 are drafted:

- Whether the capstone rubric warrants a machine-readable form, or stays prose like the rest.
- Whether the course stays in this repository or is extracted once it stabilises.
