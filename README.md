# configs

Dotfiles and terminal/editor configuration, versioned for sync across machines.

## Files

| File | Symlink target | Purpose |
|------|---------------|---------|
| `.zshrc` | `~/.zshrc` | Zsh config (oh-my-zsh, aliases, fzf, starship, tools) |
| `.tmux.conf` | `~/.tmux.conf` | Tmux config (Ghostty-optimized, pi-subagents, 8 plugins) |
| `starship.toml` | `~/.config/starship.toml` | Prompt theme |
| `ghostty/config` | `~/.config/ghostty/config` | Terminal emulator (TokyoNight theme) |
| `vscode/settings.json` | `~/Library/Application Support/Code/User/settings.json` | Editor settings |
| `vscode/keybindings.json` | `~/Library/Application Support/Code/User/keybindings.json` | Custom keybindings |
| `vscode/extensions.txt` | _(none — regenerated via `code --list-extensions`)_ | Installed extension list |
| `herdr/plugins.txt` | _(none — regenerated via `herdr plugin list`)_ | Installed Herdr plugin list |
| `herdr/config.toml` | `~/.config/herdr/config.toml` | Herdr config (keybindings, UI) |
| `firefox/` | _(none — sync via `firefox/sync.sh`)_ | Firefox profile configs (prefs, chrome CSS, extensions, bookmarks) |

## Docs

- `AGENTS.md` — Project-specific instructions for LLM coding agents working in this repo
- `docs/tmux.md` — Beginner's guide tuned to this exact tmux config
- `docs/herdr.md` — Herdr keybindings guide (built-ins + plugin bindings)
- `docs/tmux_proposal.md` — Reference proposal for pi-subagents tmux integration

## Auto-commit

A launch agent auto-commits and pushes changes every 15 minutes:

```sh
cp ~/dev/configs/launchd/com.diab.autocommit-configs.plist ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/com.diab.autocommit-configs.plist
```

This also keeps `vscode/extensions.txt` up to date automatically.

## Setup on a new machine

```sh
git clone git@github.com:eliasdiab/configs.git ~/dev/configs
ln -s ~/dev/configs/.zshrc ~/.zshrc
ln -s ~/dev/configs/.tmux.conf ~/.tmux.conf
ln -s ~/dev/configs/starship.toml ~/.config/starship.toml
ln -s ~/dev/configs/ghostty/config ~/.config/ghostty/config
ln -s ~/dev/configs/vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
ln -s ~/dev/configs/vscode/keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json

# Auto-commit agent
cp ~/dev/configs/launchd/com.diab.autocommit-configs.plist ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/com.diab.autocommit-configs.plist
```

## Firefox

Firefox configs are backed up via a sync script (not symlinked, since Firefox actively writes to these files).

```sh
cd ~/dev/configs/firefox && ./sync.sh   # pull latest from profile
```

To restore on a new machine, close Firefox and copy the files into a fresh profile directory:

```sh
PROFILE=~/".mozilla/firefox/xxxxxxxx.your-profile"
cp ~/dev/configs/firefox/prefs.js "$PROFILE/"
cp ~/dev/configs/firefox/extension-preferences.json "$PROFILE/"
cp ~/dev/configs/firefox/extension-settings.json "$PROFILE/"
cp ~/dev/configs/firefox/containers.json "$PROFILE/"
cp ~/dev/configs/firefox/handlers.json "$PROFILE/"
cp ~/dev/configs/firefox/search.json.mozlz4 "$PROFILE/"
cp ~/dev/configs/firefox/chrome/userChrome.css "$PROFILE/chrome/"
cp ~/dev/configs/firefox/chrome/userContent.css "$PROFILE/chrome/"
cp -r ~/dev/configs/firefox/chrome/theme/ "$PROFILE/chrome/theme/"
cp -r ~/dev/configs/firefox/bookmarkbackups/ "$PROFILE/"
```

## Tmux plugins

```sh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
~/.tmux/plugins/tpm/bin/install_plugins
```
