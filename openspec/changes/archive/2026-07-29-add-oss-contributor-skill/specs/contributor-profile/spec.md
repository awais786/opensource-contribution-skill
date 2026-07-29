## ADDED Requirements

### Requirement: Per-technology proficiency

The system SHALL record proficiency separately for each declared language and framework on an ordered scale, and MUST NOT collapse them into a single overall seniority level. Every area that matches work to a contributor MUST use the proficiency for the technology that work involves.

#### Scenario: Uneven skill profile

- **WHEN** a contributor declares expert proficiency in Python and Django and beginner proficiency in Rust
- **THEN** Rust work is matched against the beginner proficiency and Python work against the expert proficiency, and a demanding Rust change is not surfaced on the strength of the Python rating

#### Scenario: Expert is not offered trivial work

- **WHEN** a contributor declares expert proficiency in a technology
- **THEN** issues in that technology assessed as trivial are ranked down or excluded, and work matching the declared proficiency is surfaced instead

#### Scenario: Framework proficiency differs from language proficiency

- **WHEN** a contributor declares expert Python but no Django experience
- **THEN** Django-specific work is matched against the absence of Django experience rather than against the Python rating

### Requirement: Technical proficiency and process familiarity are distinct

The system SHALL record open source process familiarity separately from technical proficiency, and MUST use both when matching and when deciding how much procedural guidance to provide.

#### Scenario: Experienced engineer new to open source

- **WHEN** a contributor declares high technical proficiency and no prior open source contribution
- **THEN** work is matched at their technical level while guidance on conventions, etiquette, and process is provided in full

#### Scenario: Experienced contributor in an unfamiliar language

- **WHEN** a contributor declares extensive open source experience and beginner proficiency in the target language
- **THEN** procedural guidance is abbreviated and technical scope is matched to the beginner proficiency

### Requirement: Structured intake

The system SHALL elicit the profile through a structured interview when none exists, capturing languages and frameworks with per-technology proficiency, open source process familiarity, domains of interest, weekly time budget, contribution goal, and hard constraints such as employer policy or license preferences.

#### Scenario: First-time user

- **WHEN** a contributor invokes any area requiring a profile and none exists
- **THEN** the system conducts intake and persists the profile before proceeding

#### Scenario: Intake is bounded

- **WHEN** the system conducts intake
- **THEN** it asks no more than 7 questions, and each question either changes which work is surfaced or changes how it is ranked

#### Scenario: Contributor declines a question

- **WHEN** a contributor skips or declines an intake question
- **THEN** the field is recorded as unspecified, the remaining profile is used, and the system states which matching signals are weakened

### Requirement: Contribution goal shapes what is surfaced

The system SHALL capture the contributor's goal from at minimum: a first merged pull request, deepening involvement with specific projects, or non-code contribution such as triage, documentation, or review. The goal MUST change which work is surfaced, not merely its ordering.

#### Scenario: Goal is a first merged pull request

- **WHEN** the goal is a first merge
- **THEN** ranking favors small scope and short review latency over technically interesting but slow-moving work

#### Scenario: Goal is non-code contribution

- **WHEN** the goal is triage or documentation
- **THEN** triage and documentation work is surfaced and code work is not silently substituted

### Requirement: Time budget constrains what is surfaced

The system SHALL use the declared weekly time budget to filter and annotate work, and MUST NOT surface work whose estimated effort materially exceeds the available budget.

#### Scenario: Small time budget

- **WHEN** a contributor reports 2 hours per week
- **THEN** work estimated to require substantially more is excluded and each surfaced item carries an effort estimate

#### Scenario: Effort cannot be estimated

- **WHEN** effort cannot be estimated for an item
- **THEN** it is surfaced with effort marked unknown rather than assigned a guessed figure

### Requirement: Persistence, refresh, and locality

The system SHALL persist the profile to a user-local path, reuse it without repeating intake, and offer refresh when it has not been updated for more than 90 days. The profile MUST NOT be transmitted to any external service.

#### Scenario: Returning contributor

- **WHEN** a profile updated 10 days ago exists
- **THEN** the system reuses it, states its age, and proceeds

#### Scenario: Stale profile

- **WHEN** the stored profile was last updated more than 90 days ago
- **THEN** the system surfaces it for confirmation or amendment before use

#### Scenario: Single-field amendment

- **WHEN** the contributor asks to change only their weekly time budget
- **THEN** that field is updated and the rest of the profile preserved without re-running intake
