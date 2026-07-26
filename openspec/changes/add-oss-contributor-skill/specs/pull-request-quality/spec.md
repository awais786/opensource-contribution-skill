## ADDED Requirements

### Requirement: Convention extraction from merged history

The system SHALL derive a project's contribution conventions from recently merged pull requests and their review comments, covering at minimum expected pull request scope, test expectations, commit message and sign-off requirements, attitude toward new dependencies, and code-organization idioms where evident.

#### Scenario: Repository with substantial review history

- **WHEN** a repository has at least 30 merged pull requests carrying review comments
- **THEN** the system produces a conventions document across the covered categories

#### Scenario: Extracted convention contradicts documentation

- **WHEN** an extracted convention conflicts with the project's written contributing guidelines
- **THEN** the system reports both, identifies which is supported by recent merged practice, and flags the contradiction

#### Scenario: Insufficient history for extraction

- **WHEN** fewer than 10 merged pull requests carry review comments
- **THEN** the system reports that conventions could not be reliably determined and MUST NOT substitute generic open source advice presented as project-specific rules

### Requirement: Every convention carries evidence

Each convention the system asserts MUST cite at least one pull request number and a verbatim quoted comment or diff observation supporting it. Conventions without such evidence MUST be discarded rather than reported.

#### Scenario: Convention supported by review comments

- **WHEN** maintainers repeatedly request tests for a category of change
- **THEN** the reported convention cites the pull request numbers and quotes the reviewer comments establishing it

#### Scenario: Plausible but unevidenced convention

- **WHEN** the system infers a likely convention that no specific pull request supports
- **THEN** the convention is omitted entirely

#### Scenario: Evidence is linked, not bulk-reproduced

- **WHEN** review comments are cited as evidence
- **THEN** only the minimum excerpt needed is quoted and the source pull request is linked

### Requirement: Recency weighting

The system SHALL weight recent evidence more heavily than older evidence so that a project whose practice has changed is described by its current practice.

#### Scenario: Practice changed over time

- **WHEN** older pull requests show one convention and recent ones show another
- **THEN** the recent convention is reported as current and the older practice may be noted as superseded

### Requirement: Pre-submission compliance check

The system SHALL check a proposed change against the extracted conventions before submission and report concrete violations together with the most likely reasons a maintainer of that specific project would reject it.

#### Scenario: Change violates an extracted convention

- **WHEN** a proposed change bundles unrelated modifications in a project whose conventions require one logical change per pull request
- **THEN** the system reports the violation, cites the evidence for the convention, and recommends splitting

#### Scenario: Change complies

- **WHEN** a proposed change satisfies the extracted conventions
- **THEN** the system reports compliance and still names the residual risks it cannot rule out

#### Scenario: Advice against submitting

- **WHEN** the assessment indicates the change is unlikely to be accepted
- **THEN** the system states that it should not be submitted in its current form and explains why, presenting this as a successful outcome rather than an error

### Requirement: Pull request assembly

The system SHALL assemble the submission artifacts — pull request title and description, commit message format, required sign-off, and disclosure statements required by the project's declared policy — for the user to review and submit.

#### Scenario: Project requires DCO sign-off

- **WHEN** the target project requires a developer certificate of origin sign-off
- **THEN** the system includes the required sign-off form in the prepared commit message and states the requirement

#### Scenario: Project requires AI-assistance disclosure

- **WHEN** the target project's policy requires disclosing AI assistance
- **THEN** the prepared pull request description includes a disclosure consistent with that policy

#### Scenario: System does not submit

- **WHEN** submission artifacts have been assembled
- **THEN** they are presented to the user for review, and no pull request is created by the system
