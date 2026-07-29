# opensource-contribution-skill

A powerful Claude Code skill for making smarter open source contributions. Find trending projects, evaluate their quality, discover issues to work on, and prepare PRs that get accepted.

**Perfect for:** Finding your next open source project, evaluating contribution opportunities, and understanding what maintainers expect.

---

## 🎯 Quick Start

### Installation

1. **Copy the skill to Claude Code:**
   ```bash
   cp -r skills/oss-contributor ~/.claude/skills/
   ```

2. **Authenticate with GitHub:**
   ```bash
   gh auth login
   ```

3. **Verify setup:**
   ```bash
   gh auth status
   ```

### First Command

```bash
# See trending repos in last 7 days
/trending-digest

# Or get insights with filters
/trending-digest --days 30 --topic web --stats-only
```

---

## 📋 What This Skill Does

### **Route: `/trending-digest`**
Find trending open source projects with intelligent filtering.

**Features:**
- 📊 Top 15 Python + 15 non-Python repos (configurable)
- 📅 Flexible time windows (1-30 days)
- 🏷️ Filter by topic (web, rust, cli, database, etc.)
- ⭐ Minimum stars threshold
- 📈 Aggregate statistics and trends
- 💾 2-hour result caching

**Example:**
```bash
# Trending web frameworks in last 30 days (100+ stars)
/trending-digest --days 30 --topic web --min-stars 100

# Show stats only
/trending-digest --stats-only

# Trending Rust repos sorted by recent activity
/trending-digest --language rust --sort updated

# Exclude curated/educational repos
/trending-digest --exclude-pattern "awesome-*,learning-*"
```

---

## 🚀 Common Workflows

### Workflow 1: "I want to contribute today"

```bash
# Step 1: Find interesting projects
/trending-digest --days 7 --min-stars 100

# Step 2: Evaluate project quality
/repo-health microsoft/markitdown

# Step 3: Find issues you can work on
/issue-discovery microsoft/markitdown

# Step 4: Understand the codebase
/codebase-orientation microsoft/markitdown

# Step 5: Make your contribution!
```

### Workflow 2: "Show me hot web techs"

```bash
/trending-digest --days 30 --topic web --stats-only
```

**Gives you:**
- Total repos and stars
- Language distribution
- Trending technologies
- Average project quality indicators

### Workflow 3: "Find learning opportunities"

```bash
/trending-digest --exclude-pattern "awesome-*,learning-*" --min-stars 50
```

**Filters out:**
- Curated lists (awesome-*)
- Learning repositories
- Tutorials

### Workflow 4: "Deep dive into one language"

```bash
/trending-digest --language rust --days 14 --sort updated
```

**Shows:**
- Trending Rust projects
- Sorted by recent activity (not just stars)
- Active community projects

---

## 📖 Complete Command Reference

### `/trending-digest` Options

```bash
--days N              # Time window: 1, 3, 7, 14, 30 (default: 7)
--min-stars N         # Minimum stars filter (default: none)
--topic TAG           # Filter by topic (e.g., 'web', 'rust', 'cli')
--exclude-pattern     # Exclude repos matching pattern (e.g., 'awesome-*')
--stats-only          # Show aggregate statistics only
--language LANG       # Single language instead of Python+non-Python
--sort FIELD          # Sort by: stars (default), forks, watchers, updated
--limit N             # Override default 15 repos per category
--no-cache            # Ignore cache, fresh GitHub query
```

### Output Examples

#### Default Output
```
## 📊 Trending Repos (Last 7 Days)

### Python Trending Repos (15 found)

| Rank | Repo | Stars | Description | Language | Last Commit |
|------|------|-------|-------------|----------|------------|
| 1 | NousResearch/hermes-agent | 2,340 | The agent that grows with you | Python | 2026-07-29 |
| 2 | microsoft/markitdown | 1,890 | Python tool for converting files | Python | 2026-07-23 |
...

## 📈 Aggregate Stats
- **Total repos:** 30 (15 Python + 15 non-Python)
- **Total stars:** 45,320 ⭐
- **Avg stars/repo:** 1,511
- **Most popular:** Python (avg 1,850 stars/repo)

**Generated:** 2026-07-29 14:32 UTC | **Cache:** fresh
```

#### Stats-Only Output
```bash
$ /trending-digest --stats-only --days 14

## 📊 Trending Stats (Last 14 Days)

| Metric | Value |
|--------|-------|
| Repos scanned | 30 |
| Total stars | 52,100 ⭐ |
| Avg stars/repo | 1,737 |
| Most active | Python (avg 2,045 stars) |

**Top languages by stars:**
1. Python — 27,300 stars (52%)
2. TypeScript — 13,200 stars (25%)
3. Rust — 7,850 stars (15%)
4. Go — 3,750 stars (8%)
```

---

## 💡 Pro Tips

### Choose the Right Time Window

- **`--days 1`** — Extremely new projects (high risk, high reward)
- **`--days 7`** — Good balance (emerging + proven)
- **`--days 14`** — More established (safer bets)
- **`--days 30`** — Broader landscape (planning phase)

### Filter Smartly

```bash
# Find hidden gems (not just top stars)
/trending-digest --min-stars 50 --sort forks

# Find bleeding-edge tech
/trending-digest --days 3 --sort updated

# Focus on active communities
/trending-digest --sort watchers
```

### Use Caching Efficiently

```bash
# First query (hits GitHub API)
/trending-digest --topic web

# Instant cached result (within 2 hours)
/trending-digest --topic web

# Force fresh data if needed
/trending-digest --topic web --no-cache
```

### Start Broad, Then Narrow

```bash
# 1. Get overview
/trending-digest --stats-only --days 7

# 2. See details
/trending-digest --days 7

# 3. Focus on what interests you
/trending-digest --topic web --min-stars 100 --days 7
```

---

## 🛠️ Setup & Requirements

### Prerequisites

- **Claude Code** (CLI or IDE extension)
- **GitHub CLI** (`gh`) — [Install here](https://cli.github.com/)
- **GitHub authentication** — Run `gh auth login`

### Verify Setup

```bash
# Check gh CLI
gh auth status

# Check rate limits
gh api rate_limit --jq '.resources.search.remaining'
```

### Rate Limits

- GitHub allows **30 requests/minute** with authentication
- Each `/trending-digest` call uses **2-4 requests**
- Caching keeps you well under limits
- Most users won't hit limits

---

## 📊 Understanding the Output

### Stats Breakdown

```
| Metric | What it means |
|--------|---------------|
| **Total repos** | Number of projects analyzed |
| **Total stars** | Sum of all stars across repos |
| **Avg stars/repo** | Average stars per project |
| **Language distribution** | % of stars by programming language |
| **Cache status** | Is this fresh or from cache? |
```

### Language Distribution

Shows how stars are distributed across languages:
- **High Python %** → Python-focused ecosystem
- **Diverse distribution** → Multi-language trending
- **Emerging languages** → Growing ecosystems (Rust, Go, etc.)

---

## 🔄 Integration with Other Skills

After discovering repos with `/trending-digest`, use:

### `/repo-health <owner>/<repo>`
Evaluate project quality:
- Maintainer responsiveness
- Issue resolution time
- Code review quality
- Activity level

**When to use:** After finding an interesting trending repo

### `/issue-discovery <owner>/<repo>`
Find issues you can work on:
- Difficulty levels
- Time estimates
- Acceptance probability
- Skill requirements

**When to use:** After confirming repo health

### `/codebase-orientation <owner>/<repo>`
Understand project structure:
- Architecture overview
- Key modules
- Testing patterns
- Contribution guidelines

**When to use:** Before starting work on an issue

---

## ❓ FAQ

**Q: How often should I run /trending-digest?**  
A: Daily to weekly depending on your goals. Trending changes every few days. Use `--days 7` for fresh perspective.

**Q: Why is my search returning no results?**  
A: Try: fewer filters, longer time window (--days 30), lower star threshold, or check topic name.

**Q: Can I filter by multiple topics?**  
A: Currently no, but you can run separate queries:
```bash
/trending-digest --topic web
/trending-digest --topic rust
```

**Q: How long does caching last?**  
A: 2 hours. Use `--no-cache` for instant fresh results.

**Q: What if GitHub API fails?**  
A: The skill will show cached results if available, or ask you to try later.

**Q: Can I use this without authenticating?**  
A: No, GitHub auth is required. Run `gh auth login` first.

**Q: How much does this cost?**  
A: ~$0.001 per fresh query (uses Claude Haiku). Cached queries are free!

---

## 🐛 Troubleshooting

### Issue: "GitHub API unavailable"
**Solution:** 
```bash
# Check authentication
gh auth status

# Check rate limit
gh api rate_limit

# Try again in a few minutes
```

### Issue: "No repos found"
**Solution:**
- Use longer time window: `--days 30` instead of `--days 7`
- Remove filters: Remove `--min-stars`, `--topic`
- Check topic name: Verify topic exists on GitHub

### Issue: "gh command not found"
**Solution:**
```bash
# Install GitHub CLI
# macOS
brew install gh

# Linux
sudo apt install gh

# Windows
choco install gh
```

---

## 📝 Examples for Your Use Case

### 🎓 "I'm learning web development"
```bash
/trending-digest --topic web --days 30 --stats-only
# Then pick top web framework to study
```

### 🦀 "I want to learn Rust"
```bash
/trending-digest --language rust --days 14 --sort updated
# Pick active Rust projects with good communities
```

### 🚀 "I want to build my portfolio"
```bash
/trending-digest --min-stars 200 --days 7
# Pick established projects with good reputation
```

### 📚 "I want to contribute to AI/ML"
```bash
/trending-digest --topic "machine-learning" --topic "ai" --days 30
# Find trending ML projects
```

### 🌍 "I want to help maintainers"
```bash
/trending-digest --days 7 --sort watchers
# Find active projects needing help
```

---

## 🤝 Contributing

Found a bug? Want to add features? 

### Feature Ideas
- [ ] Multiple topic filtering
- [ ] Language exclusion patterns
- [ ] Custom output formatting
- [ ] Comparison across time periods
- [ ] Integration with your GitHub profile

### How to Contribute
1. Fork the repository
2. Create a feature branch
3. Submit a pull request
4. Include examples of your changes

---

## 📄 License

MIT License — Use freely in your projects!

---

## 🔗 Resources

- **GitHub CLI:** https://cli.github.com/
- **Claude Code:** https://claude.com/claude-code
- **GitHub Search Syntax:** https://docs.github.com/en/search-github

---

## 💬 Questions?

- Check the FAQ above
- Review the examples
- Check GitHub Issues
- Open a discussion

---

**Happy contributing! 🚀**

Built with ❤️ by Awais Qureshi for open source developers everywhere.
