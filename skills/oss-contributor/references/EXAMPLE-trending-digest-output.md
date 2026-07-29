# Example Output: /find-repos

This is what you'll see when you run `/find-repos --language rust`.

Captured from a real run — repo and issue lists change daily.

---

```
## 📊 Trending Rust Repositories (Daily)

| Rank | Repo Link |
|------|-----------|
| 1 | [1jehuang/jcode](https://github.com/1jehuang/jcode) |
| 2 | [atuinsh/atuin](https://github.com/atuinsh/atuin) |
| 3 | [astral-sh/uv](https://github.com/astral-sh/uv) |
| 4 | [modelcontextprotocol/rust-sdk](https://github.com/modelcontextprotocol/rust-sdk) |
| 5 | [nolabs-ai/nono](https://github.com/nolabs-ai/nono) |
| 6 | [rustfs/rustfs](https://github.com/rustfs/rustfs) |
| 7 | [superradcompany/microsandbox](https://github.com/superradcompany/microsandbox) |
| 8 | [zed-industries/zed](https://github.com/zed-industries/zed) |
| 9 | [ogulcancelik/herdr](https://github.com/ogulcancelik/herdr) |
| 10 | [agavra/tuicr](https://github.com/agavra/tuicr) |

## 📋 Top 10 Open Issues by Repository
(Unassigned issues only - no pull requests)

### 1. 1jehuang/jcode

- [CI on master is fully red: fmt drift + failing header auth test](https://github.com/1jehuang/jcode/issues/662)
- [Gemini API provider hangs indefinitely during login and run](https://github.com/1jehuang/jcode/issues/660)
- [macOS stdin detection never fires: TH_STATE_WAITING is 3, not 2](https://github.com/1jehuang/jcode/issues/651)
- [MCP: http entry in ~/.claude.json silently displaces a stdio server](https://github.com/1jehuang/jcode/issues/653)
- [Mermaid emoji labels render following text as tofu on macOS](https://github.com/1jehuang/jcode/issues/647)
- [Fix typo in repository About description (effiecent → efficient)](https://github.com/1jehuang/jcode/issues/659)

### 2. atuinsh/atuin

- [[Bug]: `atuin pty-proxy init` exports `SHELL=zsh` instead of the spawned sh](https://github.com/atuinsh/atuin/issues/3606)
- [[Bug]: TUI shows history count but no entries in global scope (aarch64)](https://github.com/atuinsh/atuin/issues/3472)
- [feat: Interpret non-latin input as Latin for CJK/Cyrillic.](https://github.com/atuinsh/atuin/issues/3780)
- [[Bug]: Agent Hook setup needs to use absolute paths](https://github.com/atuinsh/atuin/issues/3698)
- [[Bug]: OSC133 wrapper clobbers RPS1 variable in zsh](https://github.com/atuinsh/atuin/issues/3758)

...

## 📊 Statistics
- **Repos found:** 10
- **Generated:** 2026-07-29 23:20 UTC
- **Cache:** fresh (just scraped)
- **Tip:** Add GitHub token for faster fetching. Run: gh auth login
```

---

## Reading the Output

**Every issue listed is available work.** Pull requests are excluded, and so is
anything already assigned — nothing shown is already being handled by another
contributor.

**Rank is GitHub's, not ours.** The order comes straight from GitHub's trending
page and is preserved as scraped.

**Issue titles are truncated to 75 characters.** Click through for the full text.

**A repo can legitimately show no issues.** Three outcomes are reported
differently so you can tell them apart:

| Line | Meaning |
|------|---------|
| A list of issues | Available work |
| `- No open, unassigned issues found` | Fetch worked; every open issue is claimed |
| `- (Could not fetch issues: ...)` | The API call failed; the error says why |

**The token tip only appears when unauthenticated.** Without a token you get 60
GitHub API requests per hour, and each run spends 10.

---

## Next Steps

1. **Pick a repo** from the table

2. **Explore it** — this adds stars, forks, description, and each issue's labels,
   so you can spot `good first issue` and `help wanted`:
   ```bash
   /repo-details atuinsh/atuin
   ```

3. **Click an issue link** and read the full thread on GitHub

4. **Fork, code, submit your PR**
