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
  sets its exercise, verifies the result against the learner's working copy of the practice
  project, and logs the outcome.

Neither half is optional: the modules without the runner are a document nobody finishes,
and the runner without the modules is an unmaintainable monolith.

## Scope

Six modules: setup plus the four named topics plus a capstone. Skills authoring,
subagents, hooks, MCP, plugins and permissions tuning are **out of scope** and belong to a
follow-on course.

Django is the *vehicle*, not a subject. The course does not teach Django to people who
already know it. It teaches Claude Code practice using a Django codebase, because abstract
exercises produce abstract learning.

## The practice project

Every exercise runs against one project the learner builds across the course: a Django
sign-in application. The course ships a minimal seed; the learner builds the authentication
features on top of it, module by module.

### What the seed contains

```
course/claude-onboarding/seed/
  manage.py
  requirements.txt
  README.md
  signin/                 project: settings, urls, wsgi
  accounts/               app: minimal models, one or two views, urls
  accounts/tests/         a small, passing test suite
```

The seed is scaffolding, not the lesson. It deliberately does **not** contain sign-up,
log-in, log-out, password reset or two-factor — those are the exercise material.

The seed carries two or three realistic warts (a view doing too much, a code path with no
test coverage). These are documented in the seed README as intentional. Modules 2 and 4
need something real to work on, and a spotless skeleton gives them nothing.

### Why a seed rather than the learner's own repository

Everyone starts identical, so exercises are reproducible, verification is reliable, and the
course can ship a reference solution. A learner who wants to run exercises against their own
work is not prevented from doing so, but the written verification criteria assume the seed.

### Security posture

The application uses Django's built-in authentication throughout. The course never has a
learner hand-roll password hashing, session handling or token generation. Where an exercise
touches security-relevant ground — password reset tokens, rate limiting, CSRF — the module
states the framework mechanism to use and why rolling your own is the wrong answer.

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
  seed/                        the Django sign-in skeleton (above)
  reference/                   completed solution per module, for the author and stuck learners
  progress-template.md         copied into the learner's working copy at kickoff
skills/claude-onboarding/
  SKILL.md                     the runner
```

The course lives in this repository for now: the skill conventions, TDD process and review
standards already exist here. It is self-contained under two directories and can be
extracted to its own repository without rework if it outgrows this one.

## Module structure

Every module file has the same seven sections, in this order. Uniformity is the point — a
learner should never have to work out where the exercise is.

1. **Objective** — one sentence, what they can do afterwards.
2. **The failure this prevents** — the concrete first-two-weeks pain. Motivation before mechanism.
3. **Concepts** — the minimum model needed to do the exercise. No completeness for its own sake.
4. **Walkthrough** — a worked example the learner reads, not runs.
5. **Exercise** — done against the practice project.
6. **Verification criteria** — explicit, written as what a pass looks like. The runner grades against this text.
7. **Common mistakes** — populated from RED-phase findings, not invented.

## Syllabus

Order is by which failure arrives soonest, not by conceptual tidiness. The application grows
feature by feature across the six modules.

### Module 0 — First session
Install, authentication, pointing Claude at a repository, the REPL loop, permission modes and
what each one actually allows, reading a diff before accepting it.
*Exercise:* get the seed running and its tests passing, then land one small real change —
fix the untested code path or add a health-check view. Review the diff, commit it.
*Verification:* tests pass; a commit exists; the learner can state what Claude changed and why they accepted it.

### Module 1 — Working agreement
`CLAUDE.md`: what belongs in it, what does not, why "be helpful" is worthless and "run
`python manage.py test` before claiming done" is not. Scope discipline. Asking for
verification rather than assurances.
*Exercise:* write a `CLAUDE.md` for the sign-in project covering at minimum the test command,
the migration policy (generated, never hand-edited), where settings live, and the project's
conventions. Then demonstrate a behaviour change with and without it.
*Verification:* the file contains project-specific, checkable instructions — not generic
advice that would apply to any repository; the learner can name the observed difference.

### Module 2 — Context management
What occupies context, what compaction costs, `/clear` as a routine rather than a panic
button, scoping reads to the parts of files that matter, and subagents as context isolation.
Recognising the symptoms of a session that has lost the thread.
*Exercise:* implement sign-up and log-in. This is deliberately a sprawling multi-file Django
task — model or form, view, URL, template, tests, settings — the shape that reliably fills a
context window. Do it once naively, observe what happens, then re-run with context discipline.
*Verification:* sign-up and log-in work and are tested; the learner can name what filled
context the first time and which specific technique they applied the second.

### Module 3 — Models and token budgets
The current model roster and what each is for. Context window vs output cap vs thinking budget
— three different limits routinely confused for one. `/model`, per-subagent model overrides,
fast mode, and the cost of a task as something you can estimate before running it.
*Exercise:* two tasks of different character against the same codebase — a mechanical one
(back-fill tests for the existing views) and a design one (choose an approach for password
reset). Run each on two models. Record quality, latency and cost.
*Verification:* a written comparison that defends a default for each kind of task, rather than
stating a preference.

### Module 4 — Spec-driven development
Brainstorm → spec → plan → implement → verify. Why the expensive mistakes are the ones made
before any code is written. How to tell a spec that constrains implementation from one that
merely describes a wish.
*Exercise:* take password reset through the full chain. The spec must state token expiry,
single-use semantics, the behaviour on an unknown email address, and what is covered by tests.
*Verification:* a spec file exists, contains no placeholders, its acceptance criteria are
testable, and the implementation matches it.

### Module 5 — Capstone
One feature of real substance — login rate limiting, or TOTP two-factor — with all four
disciplines applied: specified first, model chosen deliberately, context managed, verified
before being called done. Graded against a rubric drawn from the five preceding modules'
criteria.

## Django-specific material, distributed

The Django-flavoured Claude patterns are taught where they naturally belong rather than
siloed in a module of their own:

| Pattern | Where it lands |
|---|---|
| Test command, migration policy, settings layout | Module 1, as `CLAUDE.md` content |
| Multi-file feature sprawl; ORM and settings as context traps | Module 2, as the core exercise |
| Mechanical test-writing vs design work as different model jobs | Module 3, as the two tasks |
| Migration and security criteria as testable acceptance criteria | Module 4, in the spec |
| Framework mechanisms over hand-rolled auth | Module 5, in the review rubric |

## The runner skill

**Name:** `claude-onboarding`
**Description:** must start with "Use when…" per the repository's skill conventions.

**Behaviour:**

1. On first invocation, help the learner copy the seed into a working directory, confirm the
   test suite passes, and place `progress.md`.
2. On each invocation, read `progress.md`, resume at the current module, teach from the module file.
3. Set the exercise and stop. The learner does the work.
4. On return, verify: deterministic facts by inspection (do the tests pass, does the file
   exist, was there a commit, does the spec contain placeholders), everything qualitative
   judged against the module's written verification criteria.
5. Append a dated entry to `progress.md` recording what passed, what did not, and the specific gap.

**Hard rule:** the runner never edits the learner's code during an exercise. It may read
anything and explain anything. Doing the homework destroys the only signal the course has.
The `reference/` solutions exist for the author and for a learner who is genuinely stuck,
and the runner offers them only after a failed attempt.

**Failure reporting is specific.** "Your CLAUDE.md is too vague" is useless. "Lines 4–6 are
generic advice that would apply to any repository; nothing here tells Claude how to run your
tests" is the standard.

## Build constraints

**Volatile facts are sourced, never remembered.** Model identifiers, context windows, pricing,
limits and flag names come from the `claude-api` skill and live `/help` output at build time.
Modules keep durable principles in prose and point at official documentation for anything that
moves. A course teaching stale model facts is worse than no course.

**Django version is pinned and stated.** The seed pins its Django and Python versions in
`requirements.txt`, and the README names the versions the course was written against.

**The runner is a skill, so it owes a RED phase.** Per this repository's CLAUDE.md, every skill
goes through RED-GREEN-REFACTOR. Three scenarios run against the module content with no runner
present; the gaps observed there define what the runner is for and populate each module's
Common Mistakes section. The runner is written only after that baseline exists.

**Content before mechanics.** The seed and modules 0–2 are written and tested before the runner
is built, so the runner is designed against real content rather than an imagined shape.

## Success criteria

1. A new engineer completes all six modules and ends with a working Django sign-in application
   containing sign-up, log-in, password reset, and the capstone feature — all tested.
2. Each module's exercise produces an artefact in the learner's working copy — a commit, a
   `CLAUDE.md`, a written comparison, a spec.
3. The runner's verification distinguishes a real pass from a nominal one, and says
   specifically why when it fails.
4. Modules read correctly standalone, without the runner.
5. The seed's test suite passes on a clean checkout, on the pinned Django and Python versions.
6. No factual claim about models, limits or pricing is sourced from memory.

## Open decisions

None blocking. Two to revisit after the seed and modules 0–2 are drafted:

- Whether the capstone rubric warrants a machine-readable form, or stays prose like the rest.
- Whether the course stays in this repository or is extracted once it stabilises.
