## ADDED Requirements

### Requirement: A persistent watchlist of target repositories

The system SHALL maintain a user-curated list of target repositories persisted to a user-local path, supporting add, remove, and list operations. Each entry MUST record why it was added, when it was added, and when its health was last verified.

#### Scenario: Contributor adds a target

- **WHEN** a contributor adds a repository to their targets
- **THEN** the entry is persisted with the stated reason, the date added, and a health verification timestamp

#### Scenario: Contributor lists targets

- **WHEN** a contributor asks what their targets are
- **THEN** the system reports each with its reason, health verdict, and the age of that verdict

#### Scenario: Watchlist is empty

- **WHEN** no targets have been added
- **THEN** the system reports the watchlist as empty and offers to populate it through repository discovery

### Requirement: Targets are health-verified before being added

The system SHALL verify a repository through the `repo-health` capability before adding it as a target, and SHALL report the verdict at the point of addition. A repository returning RED MAY still be added if the contributor chooses, provided the verdict was shown first.

#### Scenario: Healthy repository added

- **WHEN** a contributor adds a repository that verifies GREEN
- **THEN** it is added and the verdict recorded with the entry

#### Scenario: Contributor adds an unreceptive repository

- **WHEN** a contributor adds a repository that verifies RED
- **THEN** the system reports the verdict and the metrics behind it, and adds the repository only on explicit confirmation

### Requirement: Target health is re-verified and drift is reported

The system SHALL re-verify target health when the recorded verdict is more than 7 days old, and SHALL report any target whose verdict has worsened or that has become archived.

#### Scenario: Target has gone stale

- **WHEN** a target's recorded verdict is more than 7 days old
- **THEN** health is recomputed before the target is used for recommendations

#### Scenario: Target has degraded

- **WHEN** a target previously GREEN now verifies RED, or has become archived
- **THEN** the system reports the change with the metrics that moved and asks whether to keep or remove the target

### Requirement: The watchlist is the default scope for issue discovery

The system SHALL use the target repositories as the default search scope for issue discovery when the watchlist is non-empty, and SHALL fall back to profile-driven search across GitHub only when the watchlist is empty or the contributor explicitly asks to search more widely.

#### Scenario: Watchlist populated

- **WHEN** a contributor asks what they could work on and targets exist
- **THEN** issue discovery searches those targets and states that the search was scoped to the watchlist

#### Scenario: Contributor asks to look beyond targets

- **WHEN** a contributor explicitly asks for work outside their targets
- **THEN** the system searches more widely and states that results are outside the watchlist

#### Scenario: Watchlist yields nothing

- **WHEN** no issue in the watchlist survives validation
- **THEN** the system reports this plainly, names the rejection reasons, and offers a wider search rather than performing one silently

### Requirement: Watchlist scoping bounds rate-limit cost

The system SHALL analyze each target repository at most once per invocation and reuse that analysis across all candidates from that repository, so the cost of a watchlist-scoped run is proportional to the number of targets rather than the number of candidates.

#### Scenario: Multiple candidates in one target

- **WHEN** several candidate issues belong to the same target repository
- **THEN** that repository's health and conventions are analyzed once and reused across those candidates

#### Scenario: Cost is reported

- **WHEN** a watchlist-scoped run completes
- **THEN** the system reports the number of targets analyzed and the rate-limit budget consumed

### Requirement: Discovery promotes candidates into targets

The system SHALL allow a repository surfaced by the `repo-discovery` capability to be promoted into the watchlist, carrying forward the health verdict already computed rather than recomputing it.

#### Scenario: Promoting a discovered repository

- **WHEN** a contributor promotes a repository from discovery results into their targets
- **THEN** it is added with the health verdict already computed and the discovery reasoning recorded as the entry's reason
