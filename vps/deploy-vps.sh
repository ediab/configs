#!/bin/bash
# Deploy the VPS shell dotfiles from this repo to `ssh vps`.
#
# Unlike the Mac, the VPS copies are NOT symlinked: nothing on the VPS reads this
# repo, so this directory is the source of truth and is pushed by script. The files
# here were captured byte-for-byte from the VPS, so a deploy with no local edits is
# a no-op you can use to verify drift:
#
#   for f in .zshrc .zshenv .p10k.zsh .tmux.conf; do
#       diff -q <(ssh vps "cat ~/$f") "$(dirname "$0")/$f" || echo "DRIFT: $f"
#   done
#
#   .zshrc     zsh: oh-my-zsh + plugins, PATH, aliases (mode 600 on the VPS)
#   .zshenv    PATH for *every* zsh invocation — must stay output-free (a single
#              line of stdout breaks the mosh MOSH-CONNECT handshake)
#   .p10k.zsh  Powerlevel10k prompt (wizard-generated: lean, ascii, 1 line)
#   .tmux.conf minimal mobile-friendly tmux (prefix C-a, status bar on top)
#
# This is deliberately a separate, simpler set than the Mac dotfiles at the repo
# root — the VPS has no starship/fzf/plugins, so do not sync those across.
#
# CAUTION: installers (bun, brew, pyenv, nvm) append their own blocks to the VPS
# ~/.zshrc. If one runs after a deploy, re-capture the file here (scp it back) or
# the next deploy reverts that block.
#
#   VPS_HOST=<ssh-alias>   override the target host (default: vps)

set -euo pipefail

HOST="${VPS_HOST:-vps}"
SRC="$(cd "$(dirname "$0")" && pwd)"
FILES=(.zshrc .zshenv .p10k.zsh .tmux.conf)

for f in "${FILES[@]}"; do
    if [ ! -f "$SRC/$f" ]; then
        echo "Not found: $SRC/$f" >&2
        exit 1
    fi
done

for f in "${FILES[@]}"; do
    scp -q "$SRC/$f" "$HOST:~/$f"
    echo "Copied $f -> $HOST:~/$f"
done

# scp applies the *source* file's mode, and git does not track it — so the deployed
# .zshrc would end up world-readable or not depending on the checkout. Pin it to the
# 600 the VPS already used (same as the Mac copy) instead of letting it drift.
ssh "$HOST" 'chmod 600 ~/.zshrc'

# tmux caches its config in the running server, so re-source it when one is up.
# No server running (or the source fails) is not an error here.
ssh "$HOST" 'tmux source-file ~/.tmux.conf 2>/dev/null || true'

echo ""
echo "Deployed. zsh changes apply to new shells on $HOST (in an existing shell: 'reload')."
