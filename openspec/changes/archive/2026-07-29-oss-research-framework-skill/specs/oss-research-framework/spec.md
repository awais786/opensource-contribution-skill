# Trending Repos Digest Spec

## ADDED Requirements

### Requirement: Skill can fetch and display trending repositories by language

The skill SHALL query GitHub for trending repositories using the `gh` CLI, fetching top 15 trending Python and top 15 trending non-Python repositories created in the last 7 days, sorted by stars descending.

#### Scenario: User invokes trending digest command
- **WHEN** user types `/trending-digest`
- **THEN** the skill queries GitHub for top 15 trending Python repos (last 7 days, sorted by stars)
- **AND** queries GitHub for top 15 trending non-Python repos (last 7 days, sorted by stars)
- **AND** displays both results to user

#### Scenario: No results available
- **WHEN** GitHub returns fewer than 15 results for a query
- **THEN** the skill displays all available results with note about result count

#### Scenario: GitHub API error
- **WHEN** GitHub API is unavailable or times out
- **THEN** the skill displays an error message and suggests retry

### Requirement: Skill formats trending results as readable table

The skill SHALL format the fetched trending repositories into a readable markdown table with key metadata columns.

#### Scenario: Format Python trending results
- **WHEN** Python trending repos are fetched
- **THEN** results are displayed in markdown table format with columns: Rank, Repo Name, Stars, Description, Language, Last Commit Date

#### Scenario: Format non-Python trending results
- **WHEN** non-Python trending repos are fetched
- **THEN** results are displayed in same markdown table format
- **AND** results are labeled clearly as "Non-Python Trending"

#### Scenario: Add metadata and timestamp
- **WHEN** digest is displayed
- **THEN** includes timestamp showing when data was fetched (UTC)
- **AND** shows total results count (e.g., "15 Python repos, 12 non-Python repos found")

### Requirement: Skill uses bash and Haiku (cheapest model) for lightweight execution

The skill SHALL use `gh` CLI bash commands to fetch data and Claude Haiku (the cheapest available model) to format output. NO complex reasoning needed - only data fetching and formatting.

#### Scenario: Execute via bash only
- **WHEN** `/trending-digest` is invoked
- **THEN** skill executes bash commands (no Python scripts run)
- **AND** uses `gh search repos` with appropriate filters

#### Scenario: Use Haiku model (REQUIRED - cost optimization)
- **WHEN** data is fetched from GitHub
- **THEN** Haiku model MUST be used for formatting (not Opus, not Sonnet)
- **AND** Haiku processes output with minimal cost since no reasoning needed
- **AND** skill configuration explicitly specifies: `model: haiku`

#### Scenario: Manual on-demand execution
- **WHEN** user invokes `/trending-digest`
- **THEN** skill runs immediately and returns results
- **AND** no scheduled/background execution needed

#### Scenario: Cost verification
- **WHEN** skill is configured
- **THEN** SKILL.md or configuration file explicitly states: "Model: Haiku (cheapest, no reasoning needed)"
- **AND** each run costs minimal tokens (formatting only, ~100-200 tokens)
