#!/bin/bash
# Connect to GCP VM and manage tmux sessions
#
# Usage:
#   vm              List all running tmux sessions
#   vm <name>       Attach to session (creates if doesn't exist)
#   vm new <name>   Create a new session
#   vm kill <name>  Kill a session
#   vm all          Print attach commands for all sessions (copy-paste into tabs)

VM_HOST="dev-vm-1"
TERM_OVERRIDE="export TERM=xterm-256color"

case "${1}" in
  ""|ls|list)
    echo "Active tmux sessions on ${VM_HOST}:"
    echo "─────────────────────────────────"
    ssh ${VM_HOST} "${TERM_OVERRIDE}; tmux list-sessions 2>/dev/null || echo 'No sessions running. Use: vm new <name>'"
    echo ""
    echo "Reconnect with: vm <session-name>"
    ;;
  new)
    NAME="${2:?Usage: vm new <session-name>}"
    echo "Creating session '${NAME}' on ${VM_HOST}..."
    ssh ${VM_HOST} -t "${TERM_OVERRIDE}; tmux new-session -s ${NAME}"
    ;;
  kill)
    NAME="${2:?Usage: vm kill <session-name>}"
    echo "Killing session '${NAME}'..."
    ssh ${VM_HOST} "${TERM_OVERRIDE}; tmux kill-session -t ${NAME}"
    ;;
  all)
    echo "Run each in a separate Ghostty tab:"
    echo "─────────────────────────────────"
    ssh ${VM_HOST} "${TERM_OVERRIDE}; tmux list-sessions -F '#S' 2>/dev/null" | while read s; do
      echo "  vm ${s}"
    done
    ;;
  *)
    SESSION="${1}"
    ssh ${VM_HOST} -t "${TERM_OVERRIDE}; tmux attach-session -t ${SESSION} 2>/dev/null || tmux new-session -s ${SESSION}"
    ;;
esac
