## ADDED Requirements

### Requirement: Structural orientation of an unfamiliar repository

The system SHALL produce an orientation of a target repository covering its entry points, top-level module boundaries and their responsibilities, where tests live, and how the build is configured.

#### Scenario: Contributor opens an unfamiliar repository

- **WHEN** a contributor asks to be oriented in a repository they have not worked in
- **THEN** the system reports entry points, module boundaries with responsibilities, test location, and build configuration

#### Scenario: Repository structure does not follow a recognizable convention

- **WHEN** the repository uses an unusual or undocumented layout
- **THEN** the system reports what it could determine, names the parts it could not, and does not present a conventional layout it did not observe

### Requirement: Locating where a change belongs

The system SHALL, given a described change, identify the files or modules where that change would most plausibly be made, and SHALL cite the evidence — file paths, existing similar code, or references — that led it there.

#### Scenario: Change maps to an identifiable location

- **WHEN** a contributor describes a change and the codebase contains analogous existing code
- **THEN** the system names the candidate files and cites the analogous code supporting the choice

#### Scenario: Change location is ambiguous

- **WHEN** a described change could plausibly belong in more than one place
- **THEN** the system presents the candidate locations with the tradeoff between them and states that the project's maintainers may have a preference worth asking about

#### Scenario: Change location cannot be determined

- **WHEN** the system cannot identify where a change belongs
- **THEN** it states this plainly rather than nominating a file without supporting evidence

### Requirement: Local development setup path

The system SHALL report the steps required to build, run, and test the project locally, drawn from its documented setup instructions and its actual build and continuous integration configuration.

#### Scenario: Documented and actual setup agree

- **WHEN** the project's documented setup matches its CI configuration
- **THEN** the system reports the setup steps and the toolchain versions the project builds against

#### Scenario: Documentation is outdated relative to CI

- **WHEN** the documented setup conflicts with what CI configuration shows
- **THEN** the system reports both, identifies which is exercised by CI, and flags the discrepancy

#### Scenario: Setup cannot be determined

- **WHEN** neither documentation nor CI configuration reveals a reproducible setup path
- **THEN** the system reports that setup could not be determined and identifies what it inspected

### Requirement: Orientation states its scope

The system SHALL state that orientation is derived from the repository as it exists at a given commit or point in time, and SHALL NOT present its structural summary as exhaustive.

#### Scenario: Orientation delivered

- **WHEN** an orientation is produced
- **THEN** it states the point in time it reflects and that unexamined areas of the codebase may exist
