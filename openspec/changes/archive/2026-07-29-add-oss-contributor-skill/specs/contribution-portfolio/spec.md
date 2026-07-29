## ADDED Requirements

### Requirement: Contribution record collection

The system SHALL assemble a contributor's record of open source activity for a named GitHub account, covering merged and open pull requests, issues opened, and review comments authored, with the repository and date for each.

#### Scenario: Record assembled for an account

- **WHEN** the user asks for their contribution record
- **THEN** the system reports the contributions it found with repository, type, date, and link for each

#### Scenario: Contributions span many repositories

- **WHEN** a contributor's activity spans more repositories than can be analyzed within budget
- **THEN** the system reports what it covered, names what it did not, and does not present a partial record as complete

#### Scenario: No contributions found

- **WHEN** the account has no public contribution history
- **THEN** the system reports an empty record and does not infer activity from other signals

### Requirement: Non-code contributions are recorded

The system SHALL record documentation changes, issue triage, and review participation alongside code contributions, and MUST NOT rank a contributor's record solely by merged code.

#### Scenario: Contributor works primarily on triage and review

- **WHEN** a contributor's activity is mostly issue triage and reviewing others' pull requests
- **THEN** that activity appears in the record as substantive contribution rather than being omitted

### Requirement: Pattern identification

The system SHALL identify patterns across the record — recurring projects, technology areas, contribution types, and sustained versus one-off involvement — and SHALL state the evidence for each pattern.

#### Scenario: Sustained involvement in one project

- **WHEN** a contributor has contributed repeatedly to one project over an extended period
- **THEN** the system identifies that as sustained involvement and cites the contributions supporting it

#### Scenario: Record too sparse for patterns

- **WHEN** the record contains too few contributions to support a pattern claim
- **THEN** the system states that no reliable pattern can be identified rather than generalizing from a handful of items

### Requirement: Career articulation

The system SHALL, on request, draft descriptions of the contribution record suited to a résumé, an interview answer, or a promotion case, grounded in specific contributions.

#### Scenario: Résumé line requested

- **WHEN** the user asks how to describe their open source work on a résumé
- **THEN** the system drafts wording that references specific contributions and links them

#### Scenario: Claims stay within the evidence

- **WHEN** drafting any career-facing description
- **THEN** the system MUST NOT overstate scope, impact, or role beyond what the recorded contributions support

### Requirement: Record data stays local

The system SHALL keep the assembled contribution record on the user's machine and MUST NOT transmit it to any external service or contribute it to any shared index.

#### Scenario: Record assembled and stored

- **WHEN** a contribution record is generated
- **THEN** it is written only to a user-local path and no external service receives it
