# jpskills

Claude Code skills by [@ngjupeng](https://x.com/ngjupeng).

## `/branch-tab`

Fork your current Claude Code session into a **new terminal tab** and auto-resume it there, so you can branch a conversation while the original tab keeps working.

It collapses the usual 3 step ritual into one command:

1. `/branch` (fork the conversation)
2. open a new terminal tab
3. `claude --resume <id>`

Type `/branch-tab` and it does all three. The new tab gets the full prior context but a brand new session ID, so it runs independently. Your original tab is untouched.

### Install

```bash
npx skills add ngjupeng/jpskills --skill branch-tab
```

Then type `/branch-tab` in any Claude Code session.

### Supported terminals

Auto-detected: cmux, tmux, WezTerm, kitty, iTerm2, Apple Terminal, and Ghostty. Anything else falls back to printing the command for you to paste into a new tab yourself.

> Note: only cmux is exercised end to end by the author. The others use each terminal's standard tab or window CLI. Standalone Ghostty has no API to add a tab to the current window, so it opens a new window instead.

### Options

Set these as environment variables:

- `BRANCH_TAB_FOCUS=false`: open the branch tab in the background instead of jumping to it.
- `BRANCH_TAB_CMD="codex ..."`: fork a different agent or command instead of Claude.

### No prompt setup

The first run may ask for approval. To make it run with zero prompts, add this to `~/.claude/settings.json` under `permissions.allow`, adjusting the path to where the skill is installed (usually `~/.claude/skills/branch-tab`):

```json
"Bash(bash /Users/<you>/.claude/skills/branch-tab/scripts/branch-tab.sh)"
```

## License

MIT
