## Context

Greenfield repository. This change establishes every pattern the project will follow.

Three constraints dominate, and each is a direct consequence of building all eight scope areas as one skill:

1. **Instruction size.** Eight areas of methodology cannot live in one `SKILL.md`. A skill whose entry file is large loads slowly, crowds context, and degrades triggering accuracy because the description competes with itself. This is the single largest technical risk in the change and it constrains the file layout.
2. **GitHub API rate limit.** Areas 1, 2, 4, and 7 read across many repositories. The authenticated budget is 5,000 points/hour. A naive implementation of repository discovery alone can exhaust it in one invocation. Budget accounting is a design concern, not an optimization.
3. **Hallucinated authority.** Every area makes claims about a project — its health, its conventions, what a reviewer meant. A confidently wrong claim is worse than no claim, because the user acts on it and is rejected for a reason the skill invented. Evidence citation has to be structurally enforced rather than requested in prose.

## Goals / Non-Goals

**Goals:**

- Deliver all eight scope areas as one coherent skill with a shared data layer.
- Keep the entry instruction file small enough to load cheaply, with methodology loaded on demand.
- Make every factual claim about a project traceable to a pull request, file, or quoted comment.
- Fit a typical single-area invocation inside a fraction of the hourly rate-limit budget, and account for the cost of the expensive areas explicitly.
- Enforce the never-act boundary structurally, not by instruction alone.

**Non-Goals:**

- Autonomous contribution. The skill drafts and advises; the user acts.
- Private or enterprise repository support in this change.
- Any hosted service, background process, or telemetry.
- Empirically tuned health thresholds. Initial values are declared provisional and exist to be corrected against real outcomes.

## Decisions

### D1: Progressive disclosure — thin entry file, methodology in `references/`

**Decision:** `SKILL.md` contains trigger conditions, the eight areas as one-line routes, the shared operating rules, and nothing else. Each area's methodology lives in `references/<area>.md`, read only when that area is invoked.

```
skills/oss-contributor/
  SKILL.md                      ← small; routes and shared rules only
  references/
    01-repo-discovery.md          ┐
    02-repo-health.md             │
    03-codebase-orientation.md    │ loaded on demand,
    04-issue-discovery.md         │ one per invocation
    05-pull-request-quality.md    │
    06-maintainer-collaboration.md│
    07-contribution-portfolio.md  │
    08-learning-resources.md      ┘
    thresholds.yaml             ← provisional, tunable
    resources/*.yaml            ← curated data, last_reviewed dates
    schemas/*.json              ← shared data contracts
  scripts/
    preflight.py                ← gh + budget check
    collect.py                  ← shared GitHub collection
    metrics.py                  ← arithmetic only
    verify.py                   ← citation validation
    store.py                    ← profile / cache / record
```

**Rationale:** this is the mitigation for constraint 1. A user asking about review feedback should not pay the context cost of portfolio methodology. It also makes each area independently editable without touching the others.

**Alternatives considered:** eight separate skills — rejected because they would fragment the shared data layer and the connective judgment that is the product's reason to exist, and the user would have to know which to invoke. One large `SKILL.md` — rejected on load cost and triggering accuracy.

### D2: One shared collection layer, not eight

**Decision:** a single `collect.py` fetches repository data — pull requests with review threads, issues, policy files, release and commit metadata — and every area consumes its output. No area calls the GitHub API directly.

**Rationale:** the areas overlap heavily. Health, issue validation, and convention extraction all need recent pull requests with their review comments. Fetching once and reusing is the difference between an affordable and an unaffordable skill, and it guarantees the areas cannot disagree about the same repository.

### D3: `gh` CLI for all GitHub access

**Decision:** shell out to `gh api graphql`.

**Rationale:** `gh` owns authentication, token refresh, and enterprise host configuration. Building a direct client means owning credential storage, scopes, and expiry — disproportionate for a skill and a common reason skills fail to install cleanly.

**Alternatives considered:** a Python client with a personal access token in an environment variable — rejected for the auth burden. Unauthenticated REST — rejected outright; 60 requests/hour cannot support any area.

### D4: Batched GraphQL with bounded, recency-ordered sampling

**Decision:** one composed GraphQL query per collection phase, retrieving pull requests with their review threads in a single round trip. Default sample: 40 most recently updated merged pull requests plus 20 closed-unmerged, ordered by recency. Page size 20 to stay inside query complexity scoring.

**Rationale:** the REST equivalent costs roughly `1 + 2N` requests. GraphQL collapses this to a handful of paginated queries. Recency ordering serves the recency-weighting requirement — a project whose practice changed must be described by current practice. Closed-unmerged pull requests are sampled deliberately and separately: they carry the rejection signal, which is the part no competing tool uses.

**Consequence:** all conclusions are sample-based. Output language must never let "no evidence found" read as "does not exist."

### D5: Rate-limit budget is accounted per area, and expensive areas narrow before they analyze

**Decision:** declare an estimated cost per area, check remaining budget before starting, and require the multi-repository areas to filter cheaply before analyzing deeply.

| Area | Repositories touched | Est. cost | Narrowing strategy |
|---|---|---|---|
| 2 Repo health | 1 | ~60 pts | none needed |
| 3 Codebase orientation | 1 | ~20 pts | local clone where available |
| 5 Pull request quality | 1 | reuses area 2 | cache hit |
| 6 Maintainer collaboration | 1 | reuses area 2 | cache hit |
| 8 Learning resources | verification only | ~60 pts × n | verify on recommendation only |
| **1 Repo discovery** | **many** | **unbounded** | search metadata first; full health on top 10 only |
| **4 Issue discovery (watchlist)** | **N targets** | **bounded, ~N × 20 pts** | watchlist scope; one analysis per target, cached |
| **4 Issue discovery (unscoped)** | **many** | **unbounded** | filter on search-returned fields first; one health analysis per repo, reused across its issues |
| **7 Portfolio** | **many** | **unbounded** | user's own events feed; no per-repo analysis |

**Rationale:** this is the mitigation for constraint 2. The bolded areas are the ones that can exhaust the budget, and each gets an explicit narrowing rule rather than a general instruction to be careful. Filters that need no additional API call always run first.

Note the two rows for area 4. **Watchlist scoping converts the worst-case area into a bounded one** — cost becomes proportional to the number of targets, known in advance, with health cached per target across invocations. This is the strongest argument for the watchlist beyond its product merits.

**Alternatives considered:** a global request counter with a hard stop — kept as a backstop, but insufficient alone, because stopping halfway through discovery produces a misleading partial answer rather than a cheap complete one.

### D6: Scripts compute, the model interprets, scripts verify

**Decision:** a three-stage split with a hard boundary.

```
  ┌─────────────┐   ┌──────────────┐   ┌─────────────┐
  │ 1. COLLECT  │──▶│ 2. INTERPRET │──▶│ 3. VERIFY   │
  │  (script)   │   │   (model)    │   │  (script)   │
  ├─────────────┤   ├──────────────┤   ├─────────────┤
  │ gh graphql  │   │ read review  │   │ cited PR    │
  │ arithmetic  │   │ comments     │   │ exists?     │
  │ metrics     │   │ propose      │   │ quote       │
  │             │   │ conventions  │   │ verbatim?   │
  │ NO judgment │   │ + evidence   │   │ else DROP   │
  │             │   │              │   │ apply       │
  │             │   │              │   │ thresholds  │
  └─────────────┘   └──────────────┘   └─────────────┘
```

**Rationale:** this is the mitigation for constraint 3, and it also resists sycophancy. Metrics must never be model-produced — a language model deriving a percentage from a list produces plausible wrong numbers. Verdicts must not be model-chosen, because models are biased toward encouraging answers and the RED verdict is the most valuable output the skill produces. Conversely, reading a review thread to infer "maintainers dislike new dependencies" is exactly what a model is for.

Stage 3 makes citation structural: a proposed convention whose cited pull request is absent from the collected sample, or whose quoted text does not appear verbatim in a fetched comment body, is discarded programmatically.

### D7: Thresholds in a data file, declared provisional

**Decision:** health thresholds live in `references/thresholds.yaml` and are applied arithmetically. The model does not select a verdict.

Provisional starting values, stated as estimates rather than findings:

| Signal | GREEN | YELLOW | RED |
|---|---|---|---|
| Outside merge rate | ≥ 40% | 15–39% | < 15% |
| Median first response | ≤ 7 days | 8–30 days | > 30 days or none |
| Last release or commit | ≤ 90 days | 91–365 days | > 365 days |
| Bus factor | ≥ 3 | 2 | 1 |

Combination: any RED signal caps the verdict at RED; otherwise the verdict is the worst individual signal. Deliberately pessimistic — a false GREEN costs a wasted weekend, a false RED costs a skipped project among alternatives.

**Consequence:** the file carries a header stating the values are unvalidated, and correcting them against real outcomes is tracked work.

### D8: Local storage layout

**Decision:** all state under `~/.oss-contributor/` — `profile.yaml`, `targets.yaml`, `cache/<owner>__<repo>.json` with a 7-day TTL and schema version, and `record.json`.

**Rationale:** writing into repositories the user is evaluating would pollute projects they do not own. Schema versioning matters because cached data is consumed across areas; a cache written by an older layout must be invalidated rather than misread. Health metrics are never cached — responsiveness is the fastest-decaying signal, and a stale merge rate is precisely the failure the skill exists to prevent.

### D9: The never-act boundary is enforced by capability, not instruction

**Decision:** scripts use read-only GitHub operations only. No script issues a mutating API call, and the skill has no code path that posts a comment, assigns an issue, or opens a pull request.

**Rationale:** "do not post" as a prose instruction is a request a model can fail under pressure. Removing the capability entirely means the failure mode does not exist. Drafts are returned as text for the user to paste.

### D10: Proficiency is stored per technology, with no global seniority field

**Decision:** `profile.yaml` records an ordered proficiency per language and per framework, plus an open source process familiarity recorded independently of all of them. There is no single "seniority" or "experience level" field anywhere in the schema.

**Rationale:** expertise is uneven and the uneven part is what matters for matching. A Python and Django expert who has never written Rust is two different contributors depending on which repository they are looking at, and a schema with one seniority field cannot express that. Separating process familiarity from technical proficiency handles the common case the eight areas were otherwise going to get wrong — an engineer with twenty years of experience and no open source contributions needs work matched at their technical level and guidance supplied at a beginner's level, simultaneously.

The load-bearing consequence: **an expert must not be offered trivial work in their own technology.** Matching is a two-sided fit test, not a floor.

**Alternatives considered:** a single seniority level with per-language overrides — simpler to elicit, but it makes the common uneven case the exception path rather than the default, and the override becomes the field that actually matters. A years-of-experience number — rejected; it correlates poorly with the ability to land a change in a specific codebase.

**Consequence:** intake is longer. The 7-question ceiling in the spec exists to bound this, and proposal assumption 8 records the fallback if per-technology entry proves more than users will maintain.

### D11: The watchlist is the default scope, and discovery populates it

**Decision:** issue discovery scopes to `targets.yaml` when it is non-empty; unscoped search is the fallback, not the default. Repository discovery's output is promotable into the watchlist, carrying its already-computed health verdict.

**Rationale:** three reasons, in ascending order of importance.

1. **Cost.** It converts the most expensive area into a bounded one (see D5).
2. **Caching actually works.** A stable set of repositories means health and conventions are cached across invocations instead of recomputed against a different set each time.
3. **It matches how contribution succeeds.** Sustained involvement in a small number of projects produces better outcomes than scattered one-off pull requests across many. Making the watchlist the default makes the better pattern the path of least resistance, and it makes the contributor's own curation — not a generic ranking function — the thing driving recommendations.

**Alternatives considered:** search-first with an optional pinned list — rejected because it leaves the expensive path as the default and treats curation as an add-on. Auto-populating the watchlist from discovery results — rejected; promotion should be a deliberate act, since the entry records *why* the contributor chose that project.

**Consequence:** the empty-watchlist state is now a first-class path, not an edge case. A new user's first interaction is discovery-then-promote, and that flow has to be good.

## Risks / Trade-offs

| Risk | Mitigation |
|---|---|
| **Skill instructions grow past a workable size** despite progressive disclosure | Entry file holds routes only; enforce a size ceiling on `SKILL.md` and treat exceeding it as a signal to split the skill |
| **Eight areas dilute triggering accuracy** — the model invokes the wrong area or none | Explicit per-area trigger phrasing in the description; verify triggering against phrased user requests during testing |
| **Provisional thresholds are wrong**, producing misleading verdicts | Isolated in one data file with an unvalidated header; confidence reported alongside every verdict so low-sample results can be discounted |
| **Model proposes conventions no evidence supports** | Structural verification in stage 3; unverifiable claims dropped without negotiation |
| **Sycophancy suppresses negative verdicts** | Verdicts are arithmetic (D7); track the rate of negative verdicts during testing and treat a near-zero rate as a defect |
| **Rate limit exhausted mid-analysis** | Per-area cost accounting and narrowing rules (D5); budget checked before starting; partial results named explicitly, never silently truncated |
| **Off-GitHub decisions are invisible** — real intent often lives in Discord or mailing lists | Cannot be solved; stated as a standing caveat in every area that makes claims about maintainer intent |
| **Curated resources go stale** | Versioned data with `last_reviewed`; staleness warning past 180 days; curated repositories re-verified at recommendation time |
| **Career articulation overstates the user's role** | Spec requires claims stay within recorded evidence; drafts cite the specific contributions they rest on |
| **Skill is trivially forkable — no technical moat** | Accepted, not mitigated. The defensible asset is threshold quality and extraction methodology accumulated over time |

## Migration Plan

Greenfield; nothing to migrate. Rollout order follows the dependency graph rather than the numbered scope order:

```
  preflight + collect + store      (foundation — everything depends on it)
            │
            ├──▶ contributor-profile ─────┐  (matching input for 1 and 4)
            │                             │
            ├──▶ 2 repo-health ───────────┼──▶ 1 repo-discovery ──┐
            │         │                   │                       │
            │         │                   ├──▶ 5 pr-quality       │ promotes into
            │         │                   └──▶ 8 resources        │
            │         │                                           ▼
            │         └──────────────────────▶ target-repositories
            │                                           │
            │                                           ▼
            │                                    4 issue-discovery
            │                                    (watchlist-scoped)
            │
            ├──▶ 3 codebase-orientation   (independent)
            ├──▶ 6 maintainer-collab      (needs 5's conventions)
            └──▶ 7 portfolio              (independent)
```

Area 2 is built first because six other capabilities consume it. `contributor-profile` and `target-repositories` are both prerequisites of area 4, and `target-repositories` depends on area 2 for verification, so the watchlist cannot precede health. Rollback is deletion of the skill directory and `~/.oss-contributor/`; no external state exists.

## Open Questions

1. **Are the D7 thresholds close to correct?** Unknown. The most consequential open question, and the reason they are isolated in a data file.
2. **Does progressive disclosure actually keep the skill loadable at eight areas?** Untested. If not, splitting into two or three skills is the fallback, and the reference layout already supports it.
3. **What sample size is sufficient?** 40 merged and 20 unmerged are estimates balancing cost against signal. A smaller sufficient sample would materially improve the expensive multi-repository areas.
4. **Should closed-unmerged pull requests be weighted by closure reason?** One closed as "superseded by #123" is a different signal from one closed as "we don't want this." Distinguishing them likely improves accuracy but requires interpreting closure comments. Deferred.
5. **How should forks and monorepos be handled?** A fork's history may belong to its upstream; a monorepo's conventions may vary per package. Detect and warn for now.
