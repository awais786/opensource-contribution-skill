## ADDED Requirements

### Requirement: Resources are versioned reference data

The system SHALL maintain curated resources — newcomer-friendly repositories, blogs, talks, podcasts, and guides — as structured reference data files carrying a last-reviewed date, rather than as assertions embedded in skill instructions.

#### Scenario: Resource set consulted

- **WHEN** the system recommends learning resources
- **THEN** the recommendations are drawn from the reference data files and each carries its last-reviewed date

#### Scenario: Reference data is updated

- **WHEN** a resource entry is added or revised
- **THEN** only the reference data file changes, and the skill instructions require no modification

### Requirement: Staleness is visible

The system SHALL report when curated resources were last reviewed and SHALL warn when the review date exceeds 180 days.

#### Scenario: Resources reviewed recently

- **WHEN** the resource set was reviewed within the last 180 days
- **THEN** recommendations are presented with the review date stated

#### Scenario: Resources overdue for review

- **WHEN** the resource set has not been reviewed for more than 180 days
- **THEN** the system warns that recommendations may be out of date and states the review date

### Requirement: Recommendations are matched, not enumerated

The system SHALL select resources relevant to the user's declared profile, current task, and experience level, and MUST NOT return the full catalogue as a response.

#### Scenario: Beginner asks where to learn

- **WHEN** a contributor new to open source asks for learning material
- **THEN** the system returns a small set matched to their languages and stated goal, with the reason each was selected

#### Scenario: No matching resource exists

- **WHEN** no curated resource matches the user's languages or domain
- **THEN** the system states that the curated set does not cover the area rather than returning a loosely related substitute

### Requirement: Curated repositories carry verified health status

Any repository recommended as newcomer-friendly SHALL have its status verified through the `repo-health` capability at recommendation time, and MUST NOT be recommended on the strength of its curated listing alone.

#### Scenario: Curated repository has since become inactive

- **WHEN** a repository in the curated set now returns a RED verdict or is archived
- **THEN** it is withheld from recommendation and flagged for removal from the curated set

#### Scenario: Health cannot be verified

- **WHEN** health verification cannot be completed for a curated repository
- **THEN** the repository is presented with an explicit statement that its current status is unverified

### Requirement: Provenance is stated

Each curated entry SHALL record why it was included and who or what vouched for it, so the basis of a recommendation is inspectable.

#### Scenario: User asks why a resource was recommended

- **WHEN** the user questions a recommendation
- **THEN** the system reports the recorded inclusion rationale and last-reviewed date for that entry
