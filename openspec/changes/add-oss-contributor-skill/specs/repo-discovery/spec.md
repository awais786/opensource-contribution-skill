## ADDED Requirements

### Requirement: Contributor profile drives repository search

The system SHALL search for candidate repositories using the profile held by the `contributor-profile` capability — declared languages and frameworks with their per-technology proficiency, domains of interest, available time, and contribution goal — rather than returning a generic list of popular projects.

#### Scenario: Search reflects declared profile

- **WHEN** a contributor declares expert Python and Django proficiency and an interest in developer tooling
- **THEN** the candidate repositories returned reflect those technologies and that domain, and each result states which profile attributes it matched

#### Scenario: Proficiency shapes which projects fit

- **WHEN** a contributor is an expert in a technology
- **THEN** projects whose open work in that technology is uniformly trivial rank below projects with work matching that proficiency

#### Scenario: Profile is incomplete

- **WHEN** the contributor has declared languages but no domain of interest
- **THEN** the system searches on the available attributes and states which ranking signals are weakened by the missing information

### Requirement: Shortlist is bounded and reasoned

The system SHALL return at most 10 candidate repositories, each accompanied by the reason it was surfaced. The system MUST NOT pad a shortlist with weak matches to reach a target count.

#### Scenario: Many strong candidates exist

- **WHEN** more than 10 repositories match the profile well
- **THEN** the system returns the 10 highest-ranked and states how many others qualified

#### Scenario: Few candidates match

- **WHEN** only 3 repositories match the profile
- **THEN** the system returns those 3 and does not add weaker candidates to lengthen the list

### Requirement: Popularity does not determine ranking

The system SHALL NOT use star count as a ranking signal. Ranking MUST be driven by fit to the profile and by the health signals defined in the `repo-health` capability.

#### Scenario: Popular but unsuitable project

- **WHEN** a highly starred repository matches the contributor's language but is archived or unreceptive
- **THEN** it ranks below a less popular repository that is active and receptive, and the reasoning states why

### Requirement: Discovered repositories can be promoted to targets

The system SHALL offer to promote a shortlisted repository into the contributor's watchlist, carrying forward the health verdict already computed during discovery rather than recomputing it.

#### Scenario: Contributor promotes a result

- **WHEN** a contributor promotes a shortlisted repository into their targets
- **THEN** it is added with the existing health verdict and the discovery reasoning recorded as the entry's reason

#### Scenario: Repository is already a target

- **WHEN** a shortlisted repository is already in the watchlist
- **THEN** the result is marked as an existing target and is not offered for promotion again

### Requirement: Discovery reports its own limits

The system SHALL state which search strategies produced the candidate pool and SHALL state that the pool is a bounded sample rather than an exhaustive enumeration of GitHub.

#### Scenario: Shortlist presented

- **WHEN** a shortlist is returned
- **THEN** the output names the queries used and states that absence from the list is not evidence that a better project does not exist

#### Scenario: No candidates found

- **WHEN** no repository matches the profile constraints
- **THEN** the system reports an empty result, names the constraints that eliminated candidates, and suggests which constraint to relax
