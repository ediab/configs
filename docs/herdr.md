# Herdr keybindings guide

Herdr is a terminal workspace manager for AI coding agents. This covers every keybinding active in this config: built-ins, plus the custom ones added in `~/.config/herdr/config.toml`.

Prefix key: **`ctrl+b`** (Herdr default, not overridden here). Press the prefix first, then the key.

## Basics

| Keys | Action |
|------|--------|
| `prefix+?` | Help |
| `prefix+s` | Settings |
| `prefix+q` | Detach (leave Herdr running) |

## Workspaces

| Keys | Action |
|------|--------|
| `prefix+w` | Workspace picker |
| `prefix+g` | Goto (jump to workspace/pane) |
| `prefix+shift+n` | New workspace |
| `prefix+shift+g` | New worktree |
| `prefix+shift+w` | Rename workspace |
| `prefix+shift+d` | Close workspace (asks to confirm) |

## Tabs

| Keys | Action |
|------|--------|
| `prefix+c` | New tab |
| `prefix+shift+t` | Rename tab |
| `prefix+1..9` | Switch to tab N |
| `prefix+p` / `prefix+n` | Previous / next tab |
| `prefix+shift+x` | Close tab |

## Panes

| Keys | Action |
|------|--------|
| `prefix+v` | Split vertically |
| `prefix+minus` | Split horizontally |
| `prefix+h/j/k/l` | Focus left / down / up / right |
| `prefix+tab` / `prefix+shift+tab` | Cycle panes |
| `prefix+x` | Close pane |
| `prefix+z` | Zoom (fullscreen) pane |
| `prefix+r` | Resize mode (arrows to resize, esc to exit) |
| `prefix+e` | Edit scrollback |
| `prefix+b` | Toggle sidebar |
| `prefix+shift+p` | Rename pane |

## Custom commands (config.toml)

### Annotate plugin — `plannotator/herdr-annotate`

Annotate terminal selections and agent output; copy annotations as Markdown context for agents.

| Keys | Action |
|------|--------|
| Select text, then `prefix+a` | Annotate the selection |
| `prefix+shift+a` | Copy all annotations to clipboard as Markdown |
| `prefix+m` | Manage annotations (browse, copy, archive, delete) |
| `prefix+o` | Review documents (e.g. plan .md files) in the focused pane's folder |
| `prefix+shift+o` | Review the focused agent's last reply, send feedback back |
| Ctrl-click a `file://….md` link | Open that file in the annotator |

### Smart Rename plugin — `iurysza/herdr-tab-smart-rename`

AI-generated names for tabs and workspaces.

| Keys | Action |
|------|--------|
| `prefix+t` | Smart-rename current tab |
| `prefix+alt+t` | Smart-rename all tabs |

### reviewr — diff review pane

| Keys | Action |
|------|--------|
| `cmd+r` | Toggle the reviewr diff-review pane |

## Installed plugins

Tracked in `herdr/plugins.txt` (regenerate with `herdr plugin list`):

- `annotate` (plannotator/herdr-annotate) — annotations, see table above
- `tab-smart-rename` (iurysza/herdr-tab-smart-rename) — tab naming
