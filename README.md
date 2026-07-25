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

## Docs

- `docs/tmux.md` — Beginner's guide tuned to this exact tmux config
- `docs/tmux_proposal.md` — Reference proposal for pi-subagents tmux integration

## Setup on a new machine

```sh
git clone git@github.com:eliasdiab/configs.git ~/dev/configs
ln -s ~/dev/configs/.zshrc ~/.zshrc
ln -s ~/dev/configs/.tmux.conf ~/.tmux.conf
ln -s ~/dev/configs/starship.toml ~/.config/starship.toml
ln -s ~/dev/configs/ghostty/config ~/.config/ghostty/config
ln -s ~/dev/configs/vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
ln -s ~/dev/configs/vscode/keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json
```

## Tmux plugins

```sh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
~/.tmux/plugins/tpm/bin/install_plugins
```
