#!/bin/zsh
# Restore VM tmux sessions in kitty with grid layout
#
# Usage:
#   kitty-vm          Restore all sessions (4 per tab)
#   kitty-vm 8        Restore all sessions (8 per tab)
#   kitty-vm s1 s2    Restore specific sessions only

VM_HOST="dev-vm-1"
SESSION_FILE="/tmp/kitty-vm-session.conf"

# Parse arguments
SESSIONS=()
PER_TAB=4

args=("$@")
if [ ${#args[@]} -gt 0 ]; then
  last="${args[-1]}"
  if [[ "$last" =~ ^[0-9]+$ ]]; then
    PER_TAB=$last
    args=("${args[@]:0:$((${#args[@]}-1))}")
  fi
  SESSIONS=("${args[@]}")
fi

# If no sessions specified, get all active tmux sessions
if [ ${#SESSIONS[@]} -eq 0 ]; then
  echo "Fetching active sessions..."
  RAW=$(ssh -o ConnectTimeout=5 ${VM_HOST} "tmux list-sessions -F '#S' 2>/dev/null")
  if [ -z "$RAW" ]; then
    echo "No active tmux sessions on ${VM_HOST}."
    echo "Start one with: vm <session-name>"
    exit 0
  fi
  SESSIONS=("${(@f)RAW}")
  SESSIONS=("${(@)SESSIONS:#}")
fi

TOTAL=${#SESSIONS[@]}
TABS=$(( (TOTAL + PER_TAB - 1) / PER_TAB ))
echo "Found ${TOTAL} sessions → ${TABS} tab(s) × ${PER_TAB} grid"

# Generate kitty session file
rm -f "$SESSION_FILE"
touch "$SESSION_FILE"

IDX=0
TAB_NUM=0

for SESSION in "${SESSIONS[@]}"; do
  POS_IN_TAB=$((IDX % PER_TAB))

  if [ $POS_IN_TAB -eq 0 ]; then
    TAB_NUM=$((TAB_NUM + 1))
    echo "new_tab Tab ${TAB_NUM}" >> "$SESSION_FILE"
    echo "layout grid" >> "$SESSION_FILE"
    echo "  Tab ${TAB_NUM}: ${SESSION}"
  else
    echo "           ${SESSION}"
  fi

  echo "launch ssh ${VM_HOST} -t 'export TERM=xterm-256color; tmux attach-session -t ${SESSION} 2>/dev/null || tmux new-session -s ${SESSION}'" >> "$SESSION_FILE"

  IDX=$((IDX + 1))
done

echo ""
echo "Session file:"
cat "$SESSION_FILE"
echo ""
echo "Launching kitty..."

kitty --session "$SESSION_FILE" &!

echo "Done!"
