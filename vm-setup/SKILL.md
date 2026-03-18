---
name: vm-setup
description: Set up persistent Claude Code sessions on a GCP VM with tmux, kitty grid restore, clipboard sync, and file download. Use when user wants to configure VM workflow.
disable-model-invocation: true
---

# VM Workflow Setup

Set up a complete workflow for running Claude Code on a remote VM with session persistence, clipboard sync, and batch restore.

## What This Sets Up

1. **SSH keepalive** — prevents idle disconnects
2. **tmux on VM** — sessions survive SSH drops (laptop sleep, network change)
3. **`clip` on VM** — copy text to local clipboard via OSC 52 (works through tmux+SSH)
4. **`vm` command** — list/connect to named tmux sessions
5. **`kitty-vm` command** — restore all sessions in kitty with grid layout (4 per tab)
6. **`vm-sync` command** — push Claude config (CLAUDE.md, commands, settings, skills, memory) to VM
7. **`vm-dl` command** — download file from VM and auto-open locally
8. **Kitty config** — keybindings matched to Ghostty (Cmd+D split, Cmd+[] navigate)

## Setup Steps

### Step 1: Gather Info
Ask the user for:
- VM SSH host (e.g., `dev-vm-1` or IP address)
- VM username
- SSH key path (default: `~/.ssh/google_compute_engine`)
- Terminal preference: kitty, ghostty, or both

### Step 2: SSH Config
Add to `~/.ssh/config`:
```
Host <vm-host>
      HostName <ip>
      User <username>
      IdentityFile <key-path>
      ServerAliveInterval 15
      ServerAliveCountMax 3
      TCPKeepAlive yes
```

### Step 3: Install Scripts
Copy all scripts from this skill's `scripts/` directory to `~/.claude/scripts/` and make them executable. Update the `VM_HOST` variable in each script to match the user's VM host.

### Step 4: Shell Aliases
Add to `~/.zshrc`:
```bash
# Claude VM shortcuts
alias vm='~/.claude/scripts/vm.sh'
alias vm-sync='~/.claude/scripts/sync-to-vm.sh'
alias vm-dl='~/.claude/scripts/vm-dl.sh'
alias vm-restore='~/.claude/scripts/vm-restore.sh'
alias kitty-vm='~/.claude/scripts/kitty-vm.sh'
```

### Step 5: VM-Side Setup
SSH into the VM and:

1. Install tmux config (`~/.tmux.conf`):
```
set -g history-limit 50000
set -g mouse on
set -g status-style 'bg=#333333 fg=#ffffff'
set -g status-left '[#S] '
set -g status-right '%H:%M '
set -g base-index 1
set -g allow-rename off
set -g display-time 3000
set -g set-clipboard on
set -g allow-passthrough on
set -g bell-action any
set -g visual-bell off
```

2. Install `clip` utility to `/usr/local/bin/clip` (requires sudo):
```bash
#!/bin/bash
if [ -n "$1" ]; then TEXT="$*"; else TEXT=$(cat); fi
ENCODED=$(echo -n "$TEXT" | base64 | tr -d '\n')
if [ -n "$TMUX" ]; then
  printf '\033Ptmux;\033\033]52;c;%s\a\033\\' "$ENCODED"
else
  printf '\033]52;c;%s\a' "$ENCODED"
fi
echo "Copied to local clipboard (${#TEXT} chars)"
```

3. Create `~/Desktop/agents/` directory for AI file output

### Step 6: Kitty Config (if using kitty)
Install kitty config to `~/.config/kitty/kitty.conf` with:
- `enabled_layouts splits,grid,stack`
- Ghostty-matched keybindings (Cmd+D, Cmd+Shift+D, Cmd+[], etc.)
- `allow_remote_control yes`
- `copy_on_select clipboard`

### Step 7: Add to CLAUDE.md
Add VM utilities section to `~/.claude/CLAUDE.md`:
```markdown
## VM Utilities (when running on VM)
- **Copy to local clipboard**: Pipe output to `clip`. Example: `echo "text" | clip`
- **File download**: Generate files to `~/Desktop/agents/YYYY-MM-DD/` and tell me the path. I'll run `vm-dl <path>` from my local terminal.
```

### Step 8: Verify
- Run `vm` to verify SSH connection works
- Run `vm test` to verify tmux session creation
- Inside tmux, run `echo "hello" | clip` to verify clipboard
- Run `kitty-vm` to verify batch restore

## Usage After Setup

| Command | Where | What |
|---------|-------|------|
| `vm` | local | List active tmux sessions |
| `vm <name>` | local | Connect to/create named session |
| `kitty-vm` | local | Restore all sessions in kitty grid (4/tab) |
| `kitty-vm 8` | local | Restore with 8 per tab |
| `vm-sync` | local | Push Claude config to VM |
| `vm-dl <path>` | local | Download file from VM + open |
| `clip` | VM | Copy to local clipboard |
