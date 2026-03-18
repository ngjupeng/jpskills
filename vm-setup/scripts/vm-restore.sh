#!/bin/bash
# Restore all VM tmux sessions in separate Ghostty tabs
# Usage: vm-restore
#
# After laptop sleep → wake up → stale tabs auto-close (~45s)
# Then run: vm-restore
# Opens a new Ghostty tab for each active tmux session on the VM

VM_HOST="dev-vm-1"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Get list of active tmux sessions
SESSIONS=$(ssh ${VM_HOST} "export TERM=xterm-256color; tmux list-sessions -F '#S' 2>/dev/null")

if [ -z "$SESSIONS" ]; then
  echo "No active tmux sessions on ${VM_HOST}."
  echo "Start one with: vm <session-name>"
  exit 0
fi

COUNT=$(echo "$SESSIONS" | wc -l | tr -d ' ')
echo "Found ${COUNT} active sessions. Opening Ghostty tabs..."

# First session: attach in current terminal
FIRST=true
for SESSION in $SESSIONS; do
  if $FIRST; then
    echo "  [current tab] → ${SESSION}"
    FIRST=false
    FIRST_SESSION="$SESSION"
  else
    echo "  [new tab] → ${SESSION}"
    # Open new Ghostty tab and run vm <session> in it
    osascript -e "
      tell application \"Ghostty\"
        activate
        tell application \"System Events\"
          keystroke \"t\" using command down
          delay 0.5
          keystroke \"${SCRIPT_DIR}/vm.sh ${SESSION}\"
          key code 36
        end tell
      end tell
    " &
  fi
done

# Wait for all tabs to open
wait

# Attach current terminal to first session
echo ""
echo "Attaching to ${FIRST_SESSION} in this tab..."
${SCRIPT_DIR}/vm.sh ${FIRST_SESSION}
