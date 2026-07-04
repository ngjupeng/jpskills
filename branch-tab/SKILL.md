---
name: branch-tab
description: Fork the current Claude Code session into a NEW terminal tab and auto-resume it there, so you can branch a conversation while the original tab keeps working. One step instead of /branch + open a tab + claude --resume. Auto-detects cmux, tmux, WezTerm, kitty, iTerm2, Apple Terminal, and Ghostty. Only run when the user explicitly invokes /branch-tab.
disable-model-invocation: true
---

# branch-tab

Collapse the 3-step "branch this session into a parallel tab" ritual into one command.

Manually that ritual is: `/branch` (fork the conversation) → open a new terminal tab →
`claude --resume <id>`. This skill does all three at once, in whatever terminal you use.

## What to do when invoked

Run the bundled script with Bash, using this skill's own directory (its absolute path is
printed to you when the skill loads):

    bash "<SKILL_DIR>/scripts/branch-tab.sh"

That's the whole action. Do not reimplement it inline.

The script:
1. Detects the current terminal (cmux, tmux, WezTerm, kitty, iTerm2, Apple Terminal, Ghostty).
2. Opens a NEW tab in the same window/workspace, in the current working directory.
3. Runs `claude --continue --fork-session` inside it, which resumes the most-recent
   session in this directory (the one you're in) but forks it to a brand-new session ID.

Result: the new tab is a branch with full prior context and an independent session ID.
The original tab is untouched and keeps working.

## After running

- On success: tell the user the branch tab is open (focused by default) and that this
  original tab is independent and can keep going.
- If the script printed a fallback message (unsupported terminal), relay the exact command
  it told the user to paste into a new tab.

## Options (environment variables)

- `BRANCH_TAB_FOCUS=false`: open the branch tab in the background instead of jumping to it.
- `BRANCH_TAB_CMD="codex ..."`: fork a different agent/command instead of Claude.

## First run / no-prompt setup

The first Bash call may ask for approval. To make `/branch-tab` run with zero prompts,
add this line to `~/.claude/settings.json` under `permissions.allow`, replacing the path
with wherever this skill is installed (usually `~/.claude/skills/branch-tab`):

    "Bash(bash /Users/<you>/.claude/skills/branch-tab/scripts/branch-tab.sh)"

## Notes

- Only cmux is exercised end-to-end by the author; the other terminals use each one's
  standard tab/window CLI (tmux `new-window`, `wezterm cli spawn`, `kitty @ launch`,
  AppleScript for iTerm2/Terminal, `open -na Ghostty.app` for standalone Ghostty).
- Standalone Ghostty has no API to add a tab to the current window, so it opens a new
  *window* instead of a tab.
