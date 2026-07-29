## ADDED Requirements

### Requirement: Search scope defaults to the watchlist

The system SHALL scope issue discovery to the contributor's target repositories when the watchlist is non-empty, and SHALL search more widely only when the watchlist is empty or the contributor explicitly asks. The scope actually used MUST be stated with the results.

#### Scenario: Targets exist

- **WHEN** a contributor asks what they could work on and their watchlist is populated
- **THEN** discovery searches only those repositories and states that results are watchlist-scoped

#### Scenario: Watchlist is empty

- **WHEN** the watchlist contains no repositories
- **THEN** discovery falls back to profile-driven search and states that results are not watchlist-scoped

#### Scenario: Watchlist yields nothing

- **WHEN** no issue in the watchlist survives validation
- **THEN** the system reports this with the rejection reasons and offers a wider search rather than silently performing one

### Requirement: Difficulty is matched to per-technology proficiency

The system SHALL compare an issue's assessed difficulty against the contributor's proficiency in the technology that issue involves, drawn from the `contributor-profile` capability, rather than against a single overall experience level.

#### Scenario: Expert in the relevant technology

- **WHEN** a contributor is an expert in the technology an issue involves
- **THEN** issues assessed as trivial in that technology are ranked down or excluded, and substantive work is surfaced instead

#### Scenario: Beginner in the relevant technology

- **WHEN** a contributor is a beginner in the technology an issue involves
- **THEN** issues assessed beyond that proficiency are excluded even if the contributor is expert in other technologies

#### Scenario: Proficiency for the technology is unknown

- **WHEN** the profile records no proficiency for the technology an issue involves
- **THEN** the issue is surfaced with proficiency match marked unknown rather than assumed

### Requirement: Labels are hints, not evidence

The system SHALL treat beginner-oriented labels such as `good first issue` as a search hint only, and MUST NOT surface an issue as beginner-appropriate on the strength of its label alone.

#### Scenario: Label understates the work

- **WHEN** an issue labelled `good first issue` implies changes across several modules or to a public interface
- **THEN** the assessed difficulty overrides the label and the discrepancy is stated explicitly

#### Scenario: Suitable issue carries no label

- **WHEN** an unlabelled issue is assessed as small and self-contained
- **THEN** it remains eligible to be surfaced despite carrying no beginner label

### Requirement: Availability validation

The system SHALL determine whether a candidate issue is genuinely available before recommending it, by checking assignees, linked open pull requests, and comments expressing intent to work on it. Issues found to be taken MUST be excluded, with the reason recorded.

#### Scenario: Issue is assigned

- **WHEN** a candidate issue has an assignee
- **THEN** it is excluded and the reason recorded as assigned

#### Scenario: An open pull request already addresses the issue

- **WHEN** an open pull request links to the candidate issue
- **THEN** it is excluded and the linked pull request identified

#### Scenario: Claim appears abandoned

- **WHEN** an issue was claimed in a comment more than 60 days ago with no subsequent activity from the claimant
- **THEN** it remains eligible and is annotated as previously claimed but apparently abandoned

### Requirement: Staleness assessment

The system SHALL assess whether an issue is still live using time since last activity and whether a maintainer has engaged with it, and SHALL exclude or annotate issues that the project itself appears to have abandoned.

#### Scenario: Long-dormant issue

- **WHEN** a candidate issue has had no activity for more than 12 months
- **THEN** it is excluded unless the repository's overall issue cadence indicates that this is normal for the project

#### Scenario: Issue never acknowledged by a maintainer

- **WHEN** an issue has been open more than 90 days with no maintainer response
- **THEN** it is annotated as unacknowledged, signalling that a change may not be wanted even if implemented

### Requirement: Maintainer-stated approach is surfaced

The system SHALL detect whether a maintainer has already described how an issue should be solved or expressed doubt about solving it, and SHALL surface that context with the issue.

#### Scenario: Maintainer specified an approach

- **WHEN** a maintainer comment describes a preferred implementation
- **THEN** the recommendation includes that approach, quoted and linked

#### Scenario: Maintainer questioned the issue

- **WHEN** a maintainer comment questions whether the change should be made at all
- **THEN** the issue is excluded, or surfaced with an explicit warning that acceptance is uncertain

#### Scenario: Design agreement needed before code

- **WHEN** the change has architectural blast radius or the thread contains unresolved design disagreement
- **THEN** the system states that discussion should precede implementation and does not present the issue as ready to code

### Requirement: Validation outcomes are explainable

The system SHALL record for each candidate whether it passed validation and why, so a short or empty result can be explained rather than merely presented.

#### Scenario: Most candidates rejected

- **WHEN** many candidates are validated and few survive
- **THEN** the system can report how many were rejected and the distribution of reasons

#### Scenario: Nothing survives validation

- **WHEN** every candidate fails validation
- **THEN** the system reports an empty result with the rejection reasons, and MUST NOT relax validation to produce recommendations
