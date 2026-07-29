# opensource-contribution-skill

**Find good open source repos and their top 10 issues. Start contributing today.**

## Install (30 seconds)

```bash
# 1. Copy skill
cp -r skills/oss-contributor ~/.claude/skills/

# 2. Authenticate
gh auth login

# 3. Restart Claude Code
# (exit terminal and restart)
```

## Use It

```bash
# Find trending repos + show top 10 issues
/find-and-evaluate

# With filters
/find-and-evaluate --days 30 --topic web --min-stars 100
/find-and-evaluate --language rust --days 14
```

## What You Get

```
📊 Top Trending Repos (Last 7 Days)
| Repo | Stars | Language |
| ... | ... | ... |

🎯 Top 10 Issues: selected/repo
| # | Title | Labels | Updated |
| 1 | Add feature X | enhancement | 2 days ago |
| 2 | Fix bug Y | bug | 5 days ago |
...
```

## Options

```
--days N           # 1, 3, 7, 14, 30 (default: 7)
--min-stars N      # Quality filter (default: 0)
--topic TAG        # web, rust, cli, database, etc.
--language LANG    # python, rust, typescript, etc.
--exclude-pattern  # Skip repos (e.g., "awesome-*")
--no-cache         # Fresh GitHub query (ignore 2-hour cache)
```

## Examples

**Trending web frameworks**
```bash
/find-and-evaluate --topic web --min-stars 100 --days 30
```

**What's hot in Rust?**
```bash
/find-and-evaluate --language rust --days 14
```

**Find easy starter projects**
```bash
/find-and-evaluate --min-stars 50
# Look for "good first issue" label
```

## Cost

- Fresh query: ~$0.001 (Haiku model)
- Cached results: Free (2-hour cache)

## Troubleshooting

**"gh command not found"**
```bash
brew install gh        # macOS
sudo apt install gh    # Linux
choco install gh       # Windows
```

**No repos found?**
- Try `--days 30` instead of `--days 7`
- Remove `--min-stars` filter
- Check topic name

**Can't see command after install?**
- Restart Claude Code completely
- Check: `ls ~/.claude/skills/oss-contributor/`

## Next Steps

1. Run `/find-and-evaluate`
2. Pick a repo that interests you
3. Look for "good first issue" label
4. Click the issue and start coding

**That's it. Happy contributing!** 🚀
