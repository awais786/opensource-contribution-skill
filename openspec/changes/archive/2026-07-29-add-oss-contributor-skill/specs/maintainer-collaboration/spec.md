## ADDED Requirements

### Requirement: Drafting communication to maintainers

The system SHALL draft messages to maintainers — issue claiming comments, clarifying questions, design proposals, and pull request descriptions — matching the tone and length observed in the project's own recent discussions.

#### Scenario: Claiming an issue

- **WHEN** the user intends to work on an available issue
- **THEN** the system drafts a claiming comment consistent with how other contributors have claimed issues in that project

#### Scenario: Project communication style is terse

- **WHEN** the project's recent discussions are short and technical
- **THEN** the drafted message is correspondingly brief rather than elaborately polite

#### Scenario: Drafts are never posted

- **WHEN** any message has been drafted
- **THEN** it is presented to the user to post, and the system does not post it

### Requirement: Interpreting review feedback

The system SHALL interpret terse, blunt, or ambiguous review feedback into its concrete technical requests, distinguishing what the reviewer is asking for from how it was phrased.

#### Scenario: Blunt review comment

- **WHEN** a reviewer leaves a comment such as "no" or "this is wrong"
- **THEN** the system identifies the concrete change being requested where determinable, using surrounding context

#### Scenario: Feedback intent is genuinely unclear

- **WHEN** the reviewer's request cannot be determined from the comment and its context
- **THEN** the system states that the intent is unclear and drafts a specific clarifying question rather than guessing

#### Scenario: Feedback reflects a project convention

- **WHEN** a review comment reflects a convention identified by the `pull-request-quality` capability
- **THEN** the interpretation links the convention and its evidence so the user understands the underlying rule

### Requirement: Ask-versus-proceed guidance

The system SHALL advise whether a contributor should ask a maintainer before proceeding or make a reasonable decision and proceed, based on the change's blast radius and whether the project's history shows maintainers rejecting unsolicited design decisions.

#### Scenario: Change carries architectural consequences

- **WHEN** a contemplated change alters a public interface or spans module boundaries
- **THEN** the system advises proposing the approach before implementing and drafts the proposal

#### Scenario: Change is small and reversible

- **WHEN** a contemplated change is narrow and self-contained
- **THEN** the system advises proceeding without waiting, noting what would make asking worthwhile

### Requirement: Follow-up timing guidance

The system SHALL advise when and how to follow up on a stalled pull request, calibrated to the project's observed median response latency rather than to a fixed interval.

#### Scenario: Pull request awaiting review

- **WHEN** a pull request has been open longer than the project's median first-response time
- **THEN** the system advises a follow-up and drafts a message appropriate to the delay

#### Scenario: Delay is normal for the project

- **WHEN** a pull request has been open a period well within the project's normal response latency
- **THEN** the system advises waiting and states the observed median so the user can calibrate expectations

#### Scenario: Response latency is unknown

- **WHEN** the project's response latency cannot be determined
- **THEN** the system states this and offers a conservative default rather than presenting an unfounded interval as project-specific

### Requirement: The system does not escalate on the user's behalf

The system SHALL NOT contact maintainers through any channel, and SHALL NOT recommend escalation paths that pressure maintainers, such as contacting them outside the project's stated channels.

#### Scenario: Long-stalled pull request

- **WHEN** a pull request has been ignored well beyond the project's normal latency
- **THEN** the system suggests options within the project's stated channels and states plainly that maintainers may be unavailable and the work may not land
