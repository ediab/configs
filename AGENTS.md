# AGENTS.md

Project-specific instructions for the configs repo.

## What's here

Dotfiles and configs for shell, terminal, editor, and Firefox. This is the source of truth — edit here, not the symlink targets.

## Symlinked files (edit in this repo)

| This repo | Live location |
|-----------|--------------|
| `.zshrc` | `~/.zshrc` |
| `.tmux.conf` | `~/.tmux.conf` |
| `starship.toml` | `~/.config/starship.toml` |
| `ghostty/config` | `~/.config/ghostty/config` |
| `vscode/settings.json` | `~/Library/Application Support/Code/User/settings.json` |
| `vscode/keybindings.json` | `~/Library/Application Support/Code/User/keybindings.json` |

## Firefox (not symlinked — sync via script)

Firefox actively writes to its profile files, so they're synced one-way into this repo:

```sh
cd ~/dev/configs/firefox && ./sync.sh
```

The sync script copies: `prefs.js`, `extensions.json`, extension prefs/settings, `containers.json`, `handlers.json`, `search.json.mozlz4`, `chrome/userChrome.css`, `chrome/userContent.css`, `chrome/theme/`, and `bookmarkbackups/`.

Sensitive files (cookies, logins, certs) and large auto-generated data (storage, favicons, extensions XPI) are never synced.

## pi-elias harness (NOT in this repo)

Pi agent extensions, skills, and settings live in `~/dev/pi-elias/` and are deployed to `~/.pi/agent/` by `install.sh`/`update.sh`. When making pi harness changes, edit in `~/dev/pi-elias/` and run `update.sh`. If `pi` itself rewrites `settings.json`, re-sync the live copy back to `~/dev/pi-elias/` to avoid drift.

## VS Code extensions

`vscode/extensions.txt` is regenerated with `code --list-extensions > vscode/extensions.txt` after installing/removing extensions.

## VPS access

```
ssh vps   # alias defined in ~/.ssh/config
```
Host: `77.42.90.4`, user: `diab`, key: `~/.ssh/id_rsa_nroot`.
