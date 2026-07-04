#!/usr/bin/env bash
# branch-tab.sh: fork the current Claude Code (or other agent) session into a NEW
# tab in the SAME terminal window/workspace, and auto-resume the fork there.
#
# Collapses the 3-step ritual (/branch -> open new tab -> claude --resume) into one.
#
# Supported terminals (auto-detected): cmux, tmux, WezTerm, kitty, iTerm2,
# Apple Terminal, and standalone Ghostty (new window). Anything else falls back to
# printing the command for you to paste into a new tab yourself.
#
# Environment overrides:
#   BRANCH_TAB_CMD    Command the new tab runs. Default: claude --continue --fork-session
#   BRANCH_TAB_FOCUS  "true" (default) jump to the new tab; "false" open in background
set -euo pipefail

CMD="${BRANCH_TAB_CMD:-claude --continue --fork-session}"
# Prefer the session's authoritative launch directory (cmux sets this) over the
# ambient $PWD, which can drift. `claude --continue` resolves the session by cwd,
# so the new tab MUST open where the session actually started.
CWD="${CMUX_AGENT_LAUNCH_CWD:-$PWD}"
FOCUS="${BRANCH_TAB_FOCUS:-true}"

# --- terminal-specific spawners (each returns non-zero if not applicable) --------

spawn_cmux() {
  local cm out surf
  cm="$(command -v cmux || true)"
  [ -x "$cm" ] || cm="/Applications/cmux.app/Contents/Resources/bin/cmux"
  [ -x "$cm" ] || return 1
  out="$(CMUX_QUIET=1 "$cm" new-surface --type terminal --working-directory "$CWD" --focus "$FOCUS" 2>&1)" || return 1
  surf="$(printf '%s' "$out" | grep -oE 'surface:[0-9]+' | head -1)"
  [ -n "$surf" ] || return 1
  sleep 0.7   # let the shell finish initializing before we type into it
  CMUX_QUIET=1 "$cm" send --surface "$surf" "$CMD"$'\n' >/dev/null 2>&1
}

spawn_tmux() {
  command -v tmux >/dev/null || return 1
  if [ "$FOCUS" = "true" ]; then
    tmux new-window -c "$CWD" "$CMD"
  else
    tmux new-window -d -c "$CWD" "$CMD"
  fi
}

spawn_wezterm() {
  command -v wezterm >/dev/null || return 1
  wezterm cli spawn --cwd "$CWD" -- "$SHELL" -lc "$CMD; exec \"$SHELL\""
}

spawn_kitty() {
  command -v kitty >/dev/null || return 1
  kitty @ launch --type=tab --cwd "$CWD" "$SHELL" -lc "$CMD; exec \"$SHELL\"" >/dev/null 2>&1
}

spawn_iterm() {
  /usr/bin/osascript - "$CWD" "$CMD" <<'OSA'
on run argv
  set theCwd to item 1 of argv
  set theCmd to item 2 of argv
  tell application "iTerm"
    tell current window
      create tab with default profile
      tell current session to write text "cd " & quoted form of theCwd & " && " & theCmd
    end tell
  end tell
end run
OSA
}

spawn_apple_terminal() {
  /usr/bin/osascript - "$CWD" "$CMD" <<'OSA'
on run argv
  set theCwd to item 1 of argv
  set theCmd to item 2 of argv
  tell application "Terminal" to activate
  tell application "System Events" to keystroke "t" using command down
  delay 0.4
  tell application "Terminal" to do script "cd " & quoted form of theCwd & " && " & theCmd in front window
end run
OSA
}

spawn_ghostty_window() {
  # Standalone Ghostty has no CLI to add a tab to the current window; open a new WINDOW.
  [ -d "/Applications/Ghostty.app" ] || return 1
  open -na Ghostty.app --args --working-directory="$CWD" -e "$SHELL" -lc "$CMD; exec \"$SHELL\""
}

# --- detection order -------------------------------------------------------------
# cmux sets TERM_PROGRAM=ghostty too, so check cmux BEFORE ghostty. tmux next since
# it can run inside any host terminal.

if [ -n "${CMUX_SOCKET_PATH:-}${CMUX_BUNDLE_ID:-}" ]; then
  spawn_cmux && { echo "branch-tab: opened a new cmux tab (forked session)"; exit 0; }
fi

if [ -n "${TMUX:-}" ]; then
  spawn_tmux && { echo "branch-tab: opened a new tmux window (forked session)"; exit 0; }
fi

case "${TERM_PROGRAM:-}" in
  WezTerm) spawn_wezterm && { echo "branch-tab: opened a new WezTerm tab (forked session)"; exit 0; } ;;
esac

if [ -n "${KITTY_WINDOW_ID:-}" ]; then
  spawn_kitty && { echo "branch-tab: opened a new kitty tab (forked session)"; exit 0; }
fi

case "${TERM_PROGRAM:-}" in
  iTerm.app)      spawn_iterm          && { echo "branch-tab: opened a new iTerm tab (forked session)"; exit 0; } ;;
  Apple_Terminal) spawn_apple_terminal && { echo "branch-tab: opened a new Terminal tab (forked session)"; exit 0; } ;;
  ghostty)        spawn_ghostty_window && { echo "branch-tab: opened a new Ghostty window (forked session)"; exit 0; } ;;
esac

# --- fallback --------------------------------------------------------------------
echo "branch-tab: couldn't auto-open a tab in this terminal (${TERM_PROGRAM:-unknown})." >&2
echo "Open a new tab yourself and run:" >&2
echo "    $CMD" >&2
exit 1
