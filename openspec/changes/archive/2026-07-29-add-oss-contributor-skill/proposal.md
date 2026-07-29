## Why

Becoming a successful open source contributor requires two very different kinds of competence. The first is technical — reading an unfamiliar codebase, making a correct change, writing tests that fit. Developers with professional experience usually have this. The second is procedural and social — knowing which projects are worth your time, which issues are genuinely available, how a specific project expects work to be scoped and reviewed, how to talk to a maintainer, and how to convert scattered contributions into something that reads as a body of work. This second competence is learned almost entirely by apprenticeship, and most developers never get an apprentice's access to someone who has it.

The existing tools each cover one narrow slice and none cover the connective judgment between slices. Issue aggregators list labels without checking whether the issue is available or the project is alive. Repository analytics tools serve analysts rather than contributors. General coding assistants produce excellent patches with no awareness of whether the patch is wanted. A developer working across all of these still has to supply the judgment that decides what to do next — which is exactly the part they lack.

This change builds that judgment into a single skill covering the full contribution lifecycle, from choosing a project through sustaining a contribution record over time.

## What Changes

This change covers **all eight scope areas** defined in the project context, plus two supporting capabilities the eight areas depend on but none of them owns.

**Contributor profile (supporting)** — a per-developer profile recording proficiency *separately for each language and framework*, because expertise is uneven: a Python and Django expert who has never written Rust must be matched differently in each. Open source process familiarity is recorded separately from technical proficiency, so an experienced engineer new to open source gets work at their technical level with full procedural guidance. An expert is not offered trivial work in their own technology.

**Target repositories (supporting)** — a persistent, user-curated watchlist of repositories the contributor wants to work in. When populated it becomes the default scope for issue discovery, which bounds rate-limit cost, supports sustained involvement in a few projects rather than scattered one-off contributions, and makes the contributor's own curation the primary asset.

**Finding repositories (area 1)** — search and shortlist projects matching a developer's languages, interests, and goals, with the reasoning for each match stated. Surfaced repositories can be promoted into the watchlist, which reframes discovery from a per-invocation search into an onboarding step.

**Evaluating repository health (area 2)** — assess whether a project is alive and whether it accepts outside contributions: activity cadence, release recency, maintainer responsiveness, outside-contributor merge rate, bus factor, archived or fork status, and any declared contribution policy including AI-disclosure requirements.

**Understanding large codebases (area 3)** — orient a contributor in an unfamiliar repository: entry points, module boundaries, where a given kind of change belongs, test and build layout, and the local development setup path.

**Discovering beginner-friendly issues (area 4)** — find candidate issues and validate them rather than trusting labels: check whether an issue is claimed, whether a pull request already addresses it, whether it is stale, whether a maintainer has stated a preferred approach, and what the change actually demands. Scoped to the watchlist by default, falling back to a wider search only when the watchlist is empty or the contributor asks.

**Creating high-quality pull requests (area 5)** — extract a project's conventions from its merged pull request history and review comments, check a proposed change against them, and assemble the pull request: scope, commit format, sign-off requirements, tests, and description.

**Working effectively with maintainers (area 6)** — draft issue comments, questions, and pull request descriptions; interpret terse or blunt review feedback and draft responses; advise when to ask versus proceed; advise on follow-up timing for a stalled pull request.

**Building a long-term portfolio (area 7)** — track contributions across projects, surface patterns in them, and help articulate the work for a résumé, interview, or promotion case.

**Curating learning resources (area 8)** — a maintained reference of repositories known to be good for newcomers, plus blogs, talks, podcasts, and guides, kept as versioned reference data with a review date rather than as prose baked into the skill.

Across all areas the skill **advises and drafts; it does not act**. It never posts a comment, claims an issue, or opens a pull request.

## Capabilities

### New Capabilities

- `contributor-profile`: Eliciting, persisting, and refreshing a per-developer profile with per-technology proficiency, process familiarity recorded separately, goal, time budget, and constraints. Consumed by every area that matches work to a person.
- `target-repositories`: A persistent, health-verified watchlist of repositories the contributor works in, used as the default scope for issue discovery and populated by promotion from discovery.
- `repo-discovery`: Searching for and shortlisting candidate repositories against a contributor's languages, interests, and goals, with stated reasoning.
- `repo-health`: Assessing whether a project is active and receptive to outside contributions, and detecting its declared contribution policy.
- `codebase-orientation`: Orienting a contributor in an unfamiliar repository — structure, change location, tests, and local setup.
- `issue-discovery`: Finding candidate issues and validating availability, staleness, real difficulty, and maintainer-stated approach.
- `pull-request-quality`: Extracting project conventions from merged history and checking a proposed contribution against them before submission.
- `maintainer-collaboration`: Drafting communication to maintainers and interpreting review feedback, including timing and escalation guidance.
- `contribution-portfolio`: Tracking a contributor's record across projects and articulating it for career use.
- `learning-resources`: Maintaining curated reference data on projects, blogs, talks, podcasts, and guides, with freshness tracking.

### Modified Capabilities

None. `openspec/specs/` is empty; this is the first change in the project.

## Assumptions

Recorded explicitly per project rules. Each is a decision made in the absence of confirming evidence, and each is revisable.

1. **The eight areas ship as one skill, not eight.** They share a data layer and a user, and splitting them would fragment the judgment that connects them. If the skill's instructions grow too large to load efficiently, this is the first thing to revisit.
2. **The primary user has professional coding ability but little open source process experience.** The skill therefore invests in procedural and social guidance over teaching how to write code.
3. **Public GitHub is the only data source.** Decisions made on Discord, Matrix, or mailing lists are invisible, and the skill states this limitation rather than pretending completeness.
4. **The contribution-portfolio area operates on data the user points it at**, not on continuous background tracking, since the skill has no persistent runtime.
5. **Curated resources will go stale.** They are therefore versioned reference data carrying a review date, not assertions embedded in skill instructions.
6. **A GitHub API rate-limit budget of 5,000 points/hour is the ceiling.** Any area reading across many repositories must narrow cheaply before analyzing deeply.
7. **`gh` is installed and authenticated.** The skill checks and reports setup steps rather than degrading silently.
8. **Proficiency is meaningful per technology, not per person.** The profile therefore has no single seniority field. If this proves more granular than users will actually maintain, the fallback is a default proficiency with per-technology overrides.
9. **Most contributors will work in a small number of projects rather than many.** The watchlist is designed for roughly 5–20 targets. If real usage trends toward far more, the per-invocation analysis budget has to be revisited.

## Impact

- **New code**: `skills/oss-contributor/` containing `SKILL.md`, `references/` for methodology and curated data, and `scripts/` for GitHub data collection and deterministic checks.
- **Dependencies**: `gh` CLI (authenticated) and Python 3. No new services.
- **Rate limit is the dominant technical constraint.** Areas 1, 2, and 4 read across many repositories; a naive implementation exhausts the hourly budget on a single run. Caching and cheap pre-filtering are required, not optional. The watchlist materially improves this: a watchlist-scoped run costs a bounded amount proportional to the number of targets, where an unscoped search does not.
- **Data written locally**: a contributor profile, a target watchlist, a repository analysis cache with a short TTL, and a contribution record. Nothing is transmitted off the machine.
- **Skill size is a real risk.** Eight areas of instructions in one `SKILL.md` will not load efficiently; the design must keep the entry file small and push methodology into `references/` loaded on demand.
- **Legal posture**: official API only; CLA, DCO, and licensing surfaced but never advised on; review comments linked rather than reproduced in bulk.
- **Ethical posture**: the skill respects declared AI-contribution policies and never submits on the user's behalf, so it cannot become a mechanism for directing unwanted volume at maintainers.
