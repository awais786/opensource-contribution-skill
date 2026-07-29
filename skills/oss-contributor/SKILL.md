---
name: oss-contributor
description: Use for open source contribution work — deciding whether a project is worth contributing to, checking if a repo is active or abandoned, finding issues to work on, learning a project's unwritten conventions, preparing a pull request that will actually be accepted, interpreting maintainer review feedback, tracking a contribution record, or finding learning resources. Triggers on "should I contribute to", "is this project active", "what can I work on", "find me an issue", "will they merge my PR", "what does this project expect", "what did this reviewer mean", "my open source portfolio", and on a bare repository URL offered for assessment.
---

# oss-contributor

Judgment for open source contribution. Answers what to work on, whether it will be accepted, and what a project expects — grounded in that project's actual history rather than general advice.

**This skill advises and drafts. It never acts.** No script posts a comment, claims an issue, or opens a pull request. Drafts are returned for the user to send.

## Setup

```bash
python3 scripts/preflight.py --area <area-id>
```

Verifies `gh` is authenticated and the rate-limit budget covers the requested area. Run before any area that reads GitHub.

## Routes

Read the matching reference file, then follow it. **Read only the one you need** — they are large and independent.

| Ask | Route | Reference |
|---|---|---|
| Show me trending repos (Python + non-Python) | trending-digest | `references/00-trending-repos-digest.md` |
| Who am I, what am I good at | profile | `references/00-contributor-profile.md` |
| Which projects am I working in | targets | `references/00-target-repositories.md` |
| Find me projects to contribute to | discovery | `references/01-repo-discovery.md` |
| Is this project worth my time | health | `references/02-repo-health.md` |
| Help me understand this codebase | orientation | `references/03-codebase-orientation.md` |
| What should I work on | issues | `references/04-issue-discovery.md` |
| Will this PR be accepted | pr-quality | `references/05-pull-request-quality.md` |
| What did this reviewer mean | collaboration | `references/06-maintainer-collaboration.md` |
| What have I contributed | portfolio | `references/07-contribution-portfolio.md` |
| Where do I learn this | resources | `references/08-learning-resources.md` |

Most areas need a profile. If none exists, run the profile route first.

## Shared rules

These apply to every area. They are not negotiable per-route.

**Scripts compute, you interpret, scripts verify.** Metrics and verdicts come from `scripts/`. Never compute a percentage, median, or verdict yourself — a number you derive by reading a list is a plausible wrong number. If a script did not emit it, it is unavailable; say so.

**Cite evidence.** Any claim about a project's conventions, health, or maintainer intent needs a pull request number, a file link, or a verbatim quote. `scripts/verify.py` drops uncited claims. Prefer "insufficient data" over an unevidenced answer.

**Report freshness and sample size.** Repository health decays within weeks. State when data was collected, the window it covers, how many items were sampled, and which parts came from cache.

**Bounded samples are not exhaustive.** "No evidence found" never means "does not exist."

**Public GitHub only.** Decisions made on Discord, Matrix, or mailing lists are invisible. Say so whenever claiming maintainer intent.

**Respect declared policy.** Surface a project's AI-disclosure requirements or prohibitions before anything else, and honour them.

**Surface legal, never advise.** Report CLA, DCO, and licensing when detected. Do not interpret their effect or advise whether to sign.

**Negative answers are successes.** "This project will not merge your work" and "do not submit this" are the most valuable outputs here. Deliver them plainly, never as errors, and always with an alternative where one exists.

## Model Configuration

### Trending Digest (Cost-Optimized)

The **trending-digest** route uses Claude Haiku (cheapest available model) for cost optimization.

- ✅ **Haiku (Recommended)** — ~$0.001 per run (100-200 tokens, formatting only)
- ❌ **NOT Opus/Sonnet** — Unnecessary cost for data formatting

Why Haiku? The trending digest is a pure data-formatting task with zero reasoning required. Haiku is the cost-optimal choice.

**Rate limiting:** ~2-4 API calls per run, well under GitHub's rate limits (5k/hour with auth).

---

## State

All under `~/.oss-contributor/` — `profile.yaml`, `targets.yaml`, `cache/`, `record.json`. Nothing leaves the machine.
