## 1. Foundation

- [ ] 1.1 Create `skills/oss-contributor/` with `references/`, `references/resources/`, `references/schemas/`, and `scripts/`
- [ ] 1.2 Write `SKILL.md` with trigger conditions phrased per area, the eight routes, and the shared operating rules — routes only, no methodology
- [ ] 1.3 Enforce a size ceiling on `SKILL.md` and record the measured size; exceeding it is a signal to split the skill
- [ ] 1.4 Write `scripts/preflight.py` verifying `gh` is installed and authenticated, exiting with setup instructions on failure
- [ ] 1.5 Add a rate-limit budget check reporting remaining GraphQL points and aborting with the reset time when below the estimated cost of the requested area
- [ ] 1.6 Write `scripts/store.py` managing `~/.oss-contributor/` — profile, cache with 7-day TTL and schema version, contribution record
- [ ] 1.7 Verify cache entries with a mismatched schema version are invalidated rather than misread

## 2. Shared collection layer

- [ ] 2.1 Write the GraphQL query retrieving pull requests with author association, timestamps, and review threads in one paginated round trip
- [ ] 2.2 Write the companion query for closed-unmerged pull requests, which carry the rejection signal
- [ ] 2.3 Implement bounded recency-ordered sampling — 40 merged, 20 closed-unmerged — with page size tuned against query complexity limits
- [ ] 2.4 Record and emit actual sample size distinct from requested size
- [ ] 2.5 Fetch contributing guidelines, agent instruction files, and pull request templates from their candidate paths in one batched query
- [ ] 2.6 Fetch latest release, falling back to last default-branch commit, and label which was used
- [ ] 2.7 Handle inaccessible repositories by reporting and halting without further requests
- [ ] 2.8 Handle rate-limit exhaustion mid-collection by returning a partial result naming what was skipped and the reset time
- [ ] 2.9 Verify no script issues a mutating GitHub API call (design D9)

## 3. Area 2 — Repository health

- [ ] 3.1 Implement the outside-contributor definition from author association, excluding owner, member, and collaborator
- [ ] 3.2 Compute activity cadence, last release or commit date, and archived and fork status
- [ ] 3.3 Compute median time to first maintainer response, treating unanswered pull requests as unbounded rather than excluding them
- [ ] 3.4 Compute outside-contributor merge rate and percentage closed unmerged
- [ ] 3.5 Compute bus factor and state its operational definition in output
- [ ] 3.6 Hand-verify all metrics against two known repositories before proceeding — a wrong denominator invalidates every downstream area
- [ ] 3.7 Write `references/thresholds.yaml` with the design D7 values under a header stating they are unvalidated
- [ ] 3.8 Apply thresholds arithmetically and implement the rule that any RED signal caps the verdict at RED
- [ ] 3.9 Return an explicit insufficient-data result, not a verdict, below 5 outside pull requests in the repository's history
- [ ] 3.10 Detect declared contribution policy including AI-disclosure requirements and prohibitions, reporting text verbatim with a source link
- [ ] 3.11 Report "no policy found" explicitly rather than inferring one from silence
- [ ] 3.12 Detect CLA and DCO requirements, surfacing and linking them without interpreting their terms
- [ ] 3.13 Attach collection timestamp, observation window, sample size, and confidence to every report
- [ ] 3.14 Write `references/02-repo-health.md` documenting metric definitions and threshold rationale

## 3b. Contributor profile

- [ ] 3b.1 Define the profile schema with per-technology proficiency entries and no global seniority field (design D10)
- [ ] 3b.2 Record open source process familiarity as a field independent of every technical proficiency
- [ ] 3b.3 Implement structured intake bounded to 7 questions, each of which changes what is surfaced or how it is ranked
- [ ] 3b.4 Record declined questions as unspecified and state which matching signals are weakened
- [ ] 3b.5 Capture contribution goal — first merge, deepening involvement, or non-code contribution — and make it change what is surfaced, not only the ordering
- [ ] 3b.6 Capture weekly time budget and hard constraints such as employer policy or license preferences
- [ ] 3b.7 Persist to `~/.oss-contributor/profile.yaml` and reuse without repeating intake
- [ ] 3b.8 Offer refresh when the profile is more than 90 days old, and support single-field amendment without full re-intake
- [ ] 3b.9 Verify the profile is never transmitted off the machine
- [ ] 3b.10 Verify a contributor expert in one technology and beginner in another is matched differently in each
- [ ] 3b.11 Write `references/00-contributor-profile.md`

## 3c. Target repositories

- [ ] 3c.1 Define the watchlist schema at `~/.oss-contributor/targets.yaml` with reason, date added, and last health verification per entry
- [ ] 3c.2 Implement add, remove, and list operations
- [ ] 3c.3 Verify health through area 2 before adding, and record the verdict with the entry
- [ ] 3c.4 Require explicit confirmation before adding a repository that verifies RED, after showing the verdict and its metrics
- [ ] 3c.5 Re-verify health when a recorded verdict is more than 7 days old
- [ ] 3c.6 Detect and report targets whose verdict has worsened or that have become archived, and ask whether to keep or remove
- [ ] 3c.7 Implement promotion from discovery results, carrying forward the computed verdict and recording the discovery reasoning as the entry reason
- [ ] 3c.8 Mark already-targeted repositories in discovery results rather than offering promotion again
- [ ] 3c.9 Report the empty-watchlist state and offer to populate it through discovery
- [ ] 3c.10 Enforce one analysis per target per invocation, reused across all candidates from that target
- [ ] 3c.11 Report targets analyzed and rate-limit budget consumed after a watchlist-scoped run
- [ ] 3c.12 Write `references/00-target-repositories.md`

## 4. Area 5 — Pull request quality

- [ ] 4.1 Write `references/05-pull-request-quality.md` defining what qualifies as a convention and the required evidence form
- [ ] 4.2 Define `references/schemas/conventions.json` as the shared contract consumed by areas 5 and 6
- [ ] 4.3 Implement extraction across scope, test expectations, commit and sign-off requirements, dependency attitude, and code-organization idioms
- [ ] 4.4 Require every proposed convention to carry a pull request number and a verbatim quoted excerpt
- [ ] 4.5 Write `scripts/verify.py` validating that each cited pull request exists in the collected sample
- [ ] 4.6 Validate that each quoted excerpt appears verbatim in the corresponding fetched comment body
- [ ] 4.7 Drop every convention failing either check and log what was dropped and why
- [ ] 4.8 Implement recency weighting so recent evidence outweighs older, marking superseded practice as such
- [ ] 4.9 Detect contradictions between extracted conventions and written contributing guidelines, reporting both
- [ ] 4.10 Report insufficient-history results without substituting generic open source advice
- [ ] 4.11 Implement the pre-submission compliance check reporting concrete violations and likely rejection reasons
- [ ] 4.12 Implement the do-not-submit recommendation path, presented as a successful outcome
- [ ] 4.13 Assemble submission artifacts — title, description, commit format, sign-off, and policy-required disclosure — for user review only

## 5. Area 1 — Repository discovery

- [ ] 5.1 Write `references/01-repo-discovery.md` including the narrowing strategy from design D5
- [ ] 5.2 Implement profile-driven search across languages, frameworks, domains, and goal
- [ ] 5.3 Narrow on search-returned metadata before any health analysis, and run full health on at most the top 10
- [ ] 5.4 Bound the shortlist to 10 with stated reasoning per result, and never pad to reach a count
- [ ] 5.4a Rank projects whose open work is uniformly trivial below projects with work matching the contributor's declared proficiency
- [ ] 5.4b Offer promotion of shortlisted repositories into the watchlist, and mark those already targeted
- [ ] 5.5 Exclude star count from ranking entirely
- [ ] 5.6 Report the queries used and state that the pool is a bounded sample
- [ ] 5.7 Report empty results with the constraints that eliminated candidates and which to relax
- [ ] 5.8 Measure and record the rate-limit cost of a full discovery run

## 6. Area 4 — Issue discovery

- [ ] 6.1 Write `references/04-issue-discovery.md` including the per-repository reuse rule and the watchlist-scoping default
- [ ] 6.2 Scope discovery to the watchlist when it is non-empty and state the scope used with the results
- [ ] 6.3 Fall back to profile-driven search only when the watchlist is empty or the contributor explicitly asks
- [ ] 6.4 Report an empty watchlist-scoped result with rejection reasons and offer a wider search rather than silently performing one
- [ ] 6.5 Match assessed difficulty against per-technology proficiency, excluding trivial work for experts and out-of-reach work for beginners in the relevant technology
- [ ] 6.6 Mark proficiency match as unknown when the profile records nothing for the technology involved
- [ ] 6.7 Implement candidate search treating beginner labels as a hint only
- [ ] 6.8 Filter on search-returned fields — age, assignee, comment count, labels — before any per-repository analysis
- [ ] 6.9 Run health analysis once per repository and reuse it across that repository's candidates
- [ ] 6.10 Implement claim detection across assignees, linked open pull requests, and comment intent
- [ ] 6.11 Treat claims older than 60 days with no claimant activity as apparently abandoned
- [ ] 6.12 Implement staleness assessment against the repository's own issue cadence
- [ ] 6.13 Annotate issues open more than 90 days with no maintainer response as unacknowledged
- [ ] 6.14 Detect maintainer-stated approaches and surface them quoted and linked
- [ ] 6.15 Exclude or warn on issues where a maintainer questioned whether the change should be made
- [ ] 6.16 Detect changes needing design agreement first and state that discussion should precede implementation
- [ ] 6.17 Assess real difficulty from blast radius and report discrepancies against the label
- [ ] 6.18 Record per-candidate validation outcomes so short or empty results can be explained
- [ ] 6.19 Measure and record the rate-limit cost of both a watchlist-scoped and an unscoped issue discovery run

## 7. Area 3 — Codebase orientation

- [ ] 7.1 Write `references/03-codebase-orientation.md`
- [ ] 7.2 Report entry points, module boundaries with responsibilities, test location, and build configuration
- [ ] 7.3 Report honestly on repositories with unrecognizable layouts rather than assuming a conventional structure
- [ ] 7.4 Implement change-location identification citing analogous existing code as evidence
- [ ] 7.5 Present multiple candidate locations with tradeoffs when ambiguous, noting maintainers may have a preference
- [ ] 7.6 State plainly when change location cannot be determined
- [ ] 7.7 Derive the local setup path from documentation and CI configuration, reporting discrepancies between them
- [ ] 7.8 State the point in time the orientation reflects and that it is not exhaustive

## 8. Area 6 — Maintainer collaboration

- [ ] 8.1 Write `references/06-maintainer-collaboration.md`
- [ ] 8.2 Implement message drafting matched to the tone and length observed in the project's recent discussions
- [ ] 8.3 Implement review-feedback interpretation identifying the concrete request behind terse phrasing
- [ ] 8.4 Draft a specific clarifying question when reviewer intent genuinely cannot be determined
- [ ] 8.5 Link the underlying convention and its evidence when feedback reflects one
- [ ] 8.6 Implement ask-versus-proceed guidance based on blast radius and the project's history
- [ ] 8.7 Implement follow-up timing calibrated to the project's observed median response latency, not a fixed interval
- [ ] 8.8 Offer a conservative default when response latency is unknown, stated as a default rather than project-specific
- [ ] 8.9 Verify no drafted message can be posted by the skill, and that escalation guidance stays within the project's stated channels

## 9. Area 7 — Contribution portfolio

- [ ] 9.1 Write `references/07-contribution-portfolio.md`
- [ ] 9.2 Assemble the contribution record from the user's public events without per-repository analysis
- [ ] 9.3 Include documentation changes, triage, and review participation alongside code contributions
- [ ] 9.4 Report coverage limits explicitly when activity exceeds what can be analyzed
- [ ] 9.5 Report an empty record plainly when no public history exists
- [ ] 9.6 Implement pattern identification with evidence cited for each pattern
- [ ] 9.7 State when the record is too sparse to support a pattern claim
- [ ] 9.8 Implement career articulation drafting grounded in and linked to specific contributions
- [ ] 9.9 Verify drafted claims never exceed what the recorded contributions support
- [ ] 9.10 Verify the record is written only to a user-local path

## 10. Area 8 — Learning resources

- [ ] 10.1 Write `references/08-learning-resources.md`
- [ ] 10.2 Define the resource data schema including `last_reviewed` and inclusion rationale per entry
- [ ] 10.3 Populate `references/resources/` with curated repositories, blogs, talks, podcasts, and guides
- [ ] 10.4 Implement profile-matched selection returning a small relevant set, never the full catalogue
- [ ] 10.5 State when the curated set does not cover the user's area rather than substituting a loose match
- [ ] 10.6 Warn when the review date exceeds 180 days
- [ ] 10.7 Verify curated repositories through area 2 at recommendation time, withholding those now RED or archived
- [ ] 10.8 Present entries whose health could not be verified with an explicit unverified statement
- [ ] 10.9 Report inclusion rationale and review date when the user questions a recommendation

## 11. Cross-cutting verification

- [ ] 11.1 Verify the never-act boundary end to end — no comment, assignment, or pull request is created by any path
- [ ] 11.2 Verify no fabricated citation survives, by injecting a false convention and confirming stage 3 drops it
- [ ] 11.3 Verify negative verdicts actually occur across a varied repository sample; a near-zero rate is a defect
- [ ] 11.4 Verify every area reports collection time, sample size, and confidence
- [ ] 11.5 Verify every area that claims maintainer intent carries the public-GitHub-only caveat
- [ ] 11.6 Verify insufficient-data paths in every area return honest results rather than degraded guesses
- [ ] 11.7 Verify total rate-limit cost for each area against the design D5 estimates and record measured values
- [ ] 11.8 Verify triggering accuracy — phrase realistic user requests for each of the eight areas and confirm the correct route is taken
- [ ] 11.9 Verify an expert profile is not offered trivial work in their expert technology, and that the same profile is matched conservatively in a technology they rated beginner
- [ ] 11.10 Verify the empty-watchlist first-run path — discovery, then promotion, then watchlist-scoped issue discovery — works end to end
- [ ] 11.11 Verify watchlist-scoped cost is bounded and proportional to the number of targets, against the design D5 estimate

## 12. Real-repository validation

- [ ] 12.1 Run areas 1 through 8 against 20 real repositories spanning healthy, marginal, and abandoned
- [ ] 12.2 Include repositories with declared AI-contribution policies and confirm they are surfaced correctly
- [ ] 12.3 Include an archived repository, a fork, and a monorepo, and confirm each is handled or warned about
- [ ] 12.4 Hand-check extracted conventions against the actual repositories and record the false-positive rate
- [ ] 12.5 Revise `references/thresholds.yaml` from measured outcomes and replace the unvalidated header

## 13. Documentation

- [ ] 13.1 Document the `gh` authentication prerequisite and per-area rate-limit expectations
- [ ] 13.2 Document the shared data contracts in `references/schemas/` as stable interfaces between areas
- [ ] 13.3 Record design open questions 2 through 5 as known limitations — progressive disclosure at scale, sample size, closure-reason weighting, fork and monorepo handling
- [ ] 13.4 Write the repository README covering installation, the eight areas, and the never-act boundary
