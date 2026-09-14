#!/bin/bash
# Deploy the Neovim (LazyVim) config from this repo to `ssh vps`.
#
# On the Mac ~/.config/nvim is a symlink into this repo, so the repo is the source of
# truth. The VPS copy is NOT symlinked (nothing on the VPS reads the repo), so push it
# after edits — normally the sync-vps launch agent does this for you.
#
# Only the config is pushed. Plugins, LSP servers and state live in ~/.local/share/nvim
# (and ~/.local/state/nvim, ~/.cache/nvim), which are machine-local and never synced —
# so a fresh VPS needs one bootstrap with network access:
#
#   nvim --headless "+Lazy! sync" +qa
#
#   NVIM_VPS_HOST=<ssh-alias>   override the target host (default: vps)

set -euo pipefail

HOST="${NVIM_VPS_HOST:-vps}"
SRC="$(cd "$(dirname "$0")" && pwd)"

ssh "$HOST" 'mkdir -p ~/.config/nvim'
rsync -az --delete --delete-excluded --exclude=.DS_Store --exclude=deploy-vps.sh \
    "$SRC/" "$HOST:~/.config/nvim/"
echo "Synced $SRC -> $HOST:~/.config/nvim"
