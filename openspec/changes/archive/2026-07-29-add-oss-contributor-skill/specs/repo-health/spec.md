## ADDED Requirements

### Requirement: Health and receptiveness metrics

The system SHALL compute and report, for a target repository: activity cadence, date of most recent release, median time to first maintainer response on outside pull requests, outside-contributor merge rate, percentage of outside pull requests closed unmerged, bus factor, and archived or fork status. Metrics MUST be computed arithmetically from collected data and MUST NOT be estimated by inference.

#### Scenario: Active repository with sufficient history

- **WHEN** a repository has at least 10 outside pull requests resolved in the observation window
- **THEN** all metrics are reported with numeric values, and the observation window and sample size are stated

#### Scenario: Repository has no releases

- **WHEN** the repository has never published a release
- **THEN** the last default-branch commit date is reported in place of the release date, and the substitution is labelled

#### Scenario: Archived repository

- **WHEN** the target repository is archived
- **THEN** the system reports it as archived and states that it accepts no contributions, without computing further metrics

### Requirement: Outside contributor is operationally defined

The system SHALL define an outside contributor as a pull request author whose association with the repository is not owner, member, or collaborator, and SHALL state this definition alongside any metric derived from it.

#### Scenario: Repository with mixed authorship

- **WHEN** a repository's recent pull requests include both maintainer-authored and outside-authored changes
- **THEN** merge rate and response latency are computed from outside-authored pull requests only, and the definition used is stated in the output

### Requirement: Receptiveness verdict

The system SHALL assign a single verdict of GREEN, YELLOW, or RED, derived from the computed metrics against declared thresholds, and SHALL state which metrics drove it. A negative verdict is a successful result and MUST NOT be presented as an error.

#### Scenario: Active and receptive project

- **WHEN** metrics show a high outside merge rate, short response latency, and recent activity
- **THEN** the system returns GREEN with the supporting metrics

#### Scenario: Unreceptive project

- **WHEN** metrics show a low outside merge rate and no maintainer response to outside pull requests in the window
- **THEN** the system returns RED, states the driving metrics, and presents the result as a useful finding rather than a failure

#### Scenario: Insufficient data for a verdict

- **WHEN** the repository has fewer than 5 outside pull requests in its entire history
- **THEN** the system returns an explicit insufficient-data result rather than any verdict

### Requirement: Contribution policy detection

The system SHALL detect and surface a project's declared contribution policy, including requirements to disclose AI assistance and prohibitions on AI-generated contributions, by inspecting contributing guidelines, agent instruction files, pull request templates, and the repository description.

#### Scenario: Project mandates AI disclosure

- **WHEN** the repository's guidelines require disclosure of AI assistance
- **THEN** the system reports the requirement verbatim and links its source file

#### Scenario: Project prohibits AI-assisted contributions

- **WHEN** the repository declares that AI-generated contributions are not accepted
- **THEN** the system surfaces the prohibition prominently regardless of the health verdict

#### Scenario: No policy found

- **WHEN** no contribution policy can be located
- **THEN** the system states that none was found and does not infer one from silence

### Requirement: Freshness is always reported

The system SHALL state when the underlying data was collected and the window it covers, and SHALL identify any portion served from cache along with its age.

#### Scenario: Report served partly from cache

- **WHEN** cached analysis is reused while responsiveness metrics are recomputed
- **THEN** the output identifies which portion is cached, states its age, and states the collection time of the fresh portion
