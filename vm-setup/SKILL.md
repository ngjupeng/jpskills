---
name: vm-setup
description: Set up persistent Claude Code sessions on a remote VM with tmux, clipboard sync, file download, and batch session restore. Works with any terminal (kitty, Ghostty, iTerm2, etc.).
disable-model-invocation: true
---

# VM Workflow Setup

Set up a complete workflow for running Claude Code on a remote VM with session persistence, clipboard sync, and batch restore.

## What This Sets Up

**Core (all terminals):**
1. **SSH keepalive** — prevents idle disconnects
2. **tmux on VM** — sessions survive SSH drops (laptop sleep, network change)
3. **`clip` on VM** — copy text to local clipboard via OSC 52 (works through tmux+SSH)
4. **`vm` command** — list/connect to named tmux sessions
5. **`vm-sync` command** — push Claude config (CLAUDE.md, commands, settings, skills, memory) to VM
6. **`vm-dl` command** — download file from VM and auto-open locally

**Kitty-specific (optional):**
7. **`kitty-vm` command** — restore all sessions in kitty with grid layout (4 per tab)
8. **Kitty config** — keybindings matched to Ghostty (Cmd+D split, Cmd+[] navigate)

**Ghostty-specific (optional):**
9. **`vm-restore` command** — restore sessions in Ghostty tabs (one per tab, no grid)

## Setup Steps

### Step 1: Gather Info
Ask the user for:
- VM SSH host (e.g., `dev-vm-1` or IP address)
- VM IP address
- VM username
- SSH key path (default: `~/.ssh/google_compute_engine`)
- Terminal: kitty, ghostty, iTerm2, or other

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
Add to `~/.zshrc` (or `~/.bashrc`):
```bash
# Claude VM shortcuts (core — works with any terminal)
alias vm='~/.claude/scripts/vm.sh'
alias vm-sync='~/.claude/scripts/sync-to-vm.sh'
alias vm-dl='~/.claude/scripts/vm-dl.sh'
```

If using **kitty**, also add:
```bash
alias kitty-vm='~/.claude/scripts/kitty-vm.sh'
```

If using **Ghostty**, also add:
```bash
alias vm-restore='~/.claude/scripts/vm-restore.sh'
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

### Step 6: Terminal-Specific Config

**If using kitty:**
Install kitty config to `~/.config/kitty/kitty.conf` with:
- `enabled_layouts splits,grid,stack`
- Ghostty-matched keybindings (Cmd+D, Cmd+Shift+D, Cmd+[], etc.)
- `allow_remote_control yes`
- `copy_on_select clipboard`

**If using Ghostty:**
No special config needed. OSC 52 clipboard works by default.

**If using iTerm2:**
Enable "Allow clipboard access to terminal apps" in Preferences → General → Selection.

### Step 7: Add to CLAUDE.md
Add VM utilities section to `~/.claude/CLAUDE.md`:
```markdown
## VM Utilities (when running on VM)
- **Copy to local clipboard**: Pipe output to `clip`. Example: `echo "text" | clip`
- **File download**: Generate files to `~/Desktop/agents/YYYY-MM-DD/` and tell me the path. I'll run `vm-dl <path>` from my local terminal.
```

### Step 8: Verify
- Run `vm` to verify SSH connection and list sessions
- Run `vm test` to verify tmux session creation
- Inside tmux, run `echo "hello" | clip` to verify clipboard
- If kitty: run `kitty-vm` to verify grid restore
- If Ghostty: run `vm-restore` to verify tab restore

## Usage After Setup

| Command | Where | Terminal | What |
|---------|-------|----------|------|
| `vm` | local | any | List active tmux sessions |
| `vm <name>` | local | any | Connect to/create named session |
| `vm-sync` | local | any | Push Claude config to VM |
| `vm-dl <path>` | local | any | Download file from VM + open |
| `kitty-vm` | local | kitty | Restore all sessions in grid (4/tab) |
| `kitty-vm 8` | local | kitty | Restore with 8 per tab |
| `vm-restore` | local | Ghostty | Restore sessions in separate tabs |
| `clip` | VM | any | Copy to local clipboard |
