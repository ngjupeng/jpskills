#!/bin/bash
# Sync Claude Code config to GCP VM
# Usage: ~/.claude/scripts/sync-to-vm.sh

VM_HOST="dev-vm-1"
REMOTE_USER="jupeng_quantum3labs_com"
REMOTE_CLAUDE_DIR="/home/${REMOTE_USER}/.claude"

echo "Syncing Claude config to ${VM_HOST}..."

# 1. Sync CLAUDE.md (global config)
echo "  -> CLAUDE.md"
scp ~/.claude/CLAUDE.md ${VM_HOST}:${REMOTE_CLAUDE_DIR}/CLAUDE.md

# 2. Sync commands
echo "  -> commands/"
ssh ${VM_HOST} "mkdir -p ${REMOTE_CLAUDE_DIR}/commands"
rsync -av --delete ~/.claude/commands/ ${VM_HOST}:${REMOTE_CLAUDE_DIR}/commands/

# 3. Sync settings
echo "  -> settings.json"
scp ~/.claude/settings.json ${VM_HOST}:${REMOTE_CLAUDE_DIR}/settings.json

# 4. Sync skills (Impeccable etc.)
if [ -d "$HOME/quantum3labs/miden/.agents/skills" ]; then
  echo "  -> skills/"
  ssh ${VM_HOST} "mkdir -p ${REMOTE_CLAUDE_DIR}/skills"
  rsync -av --delete ~/quantum3labs/miden/.agents/skills/ ${VM_HOST}:${REMOTE_CLAUDE_DIR}/skills/
fi

# 5. Sync memory files to ~/claude/memory/ (symlinked from all project dirs)
LOCAL_MEMORY="$HOME/.claude/projects/-Users-ngjupeng-quantum3labs-miden/memory"
if [ -d "$LOCAL_MEMORY" ]; then
  echo "  -> memory files (~/claude/memory/)"
  ssh ${VM_HOST} "mkdir -p ~/claude/memory"
  scp -q ${LOCAL_MEMORY}/*.md ${VM_HOST}:~/claude/memory/
fi

echo ""
echo "Done! Config synced to ${VM_HOST}."
echo "Commands: $(ls ~/.claude/commands/ | sed 's/.md//g' | tr '\n' ' ')"
echo "Skills: $(ls ~/quantum3labs/miden/.agents/skills/ 2>/dev/null | tr '\n' ' ')"
