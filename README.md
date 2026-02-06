# dotfiles

> The (dot)files that make the magic happen.

Highly-opinionated, UNIX-friendly, macOS-directed.

## Quick Start

```bash
# 1. Clone
git clone https://github.com/lacymorrow/dotfiles.git ~/dotfiles

# 2. Symlink dotfiles to home directory (backs up existing files first)
cd ~/dotfiles && ./symlink_dotfiles.sh

# 3. Install tools (pick what you need)
./brew.sh       # Homebrew packages
./node.sh       # Node.js via NVM
./mac.sh        # macOS setup & defaults
```

## What's Included

### Shell (`home/`)

All files in `home/` are symlinked to `~/` by `symlink_dotfiles.sh`.

| File | Purpose |
|------|---------|
| `.zprofile` | Login shell setup — Homebrew, NVM, completions, sources dotfile modules |
| `.zshrc` | Interactive shell — zsh options, key bindings, Starship prompt |
| `.aliases` | Shell aliases |
| `.functions` | Shell functions |
| `.exports` | Environment variables |
| `.gitconfig` | Git config, aliases, colors, URL shorthands |
| `.npmrc` | npm defaults — uses `${NPM_TOKEN}` env var for auth (see Secrets below) |
| `.vimrc` | Vim config — line numbers, search, backup/undo, status line |
| `.tmux.conf` | Tmux config — `Ctrl-a` prefix, vim-style navigation, TPM plugins |
| `starship.toml` | Starship prompt theme |

### Scripts

| Script | What it does |
|--------|-------------|
| `symlink_dotfiles.sh` | Symlinks `home/*` to `~/`, backs up existing files to `~/dotfiles_old` |
| `brew.sh` | Installs Homebrew packages |
| `node.sh` | Installs NVM and Node.js |
| `mac.sh` | macOS system preferences and setup |
| `apply-macos-settings.sh` | Detailed macOS defaults |

### Other

| File | Purpose |
|------|---------|
| `Brewfile` | Declarative Homebrew dependencies |
| `settings/` | App-specific settings (VS Code, etc.) |
| `.ssh/` | SSH config template |

## Secrets

Tokens and credentials go in `~/.secrets` — this file is sourced automatically by `.zprofile` but is **never committed** to this repo.

```bash
# ~/.secrets — create this on each machine
export NPM_TOKEN="your-npm-token-here"
# Add other API keys, credentials, etc.
```

This is how `home/.npmrc` works safely — it references `${NPM_TOKEN}` which npm interpolates at runtime. No token in the repo, no token in git history.

The file is optional. If `~/.secrets` doesn't exist, it's silently skipped. `~/.extra` also works the same way for non-secret local customizations.

## Customization

The dotfile loading order in `.zprofile` is:

```
~/.path → ~/.exports → ~/.aliases → ~/.docker_aliases → ~/.functions → ~/.secrets → ~/.extra
```

All files are optional — missing ones are silently skipped.

- **`~/.secrets`** — API tokens, credentials (never committed)
- **`~/.extra`** — Machine-specific overrides, non-secret customizations (never committed)
- **`~/.path`** — Additional `$PATH` entries

## Key Highlights

### Git

- `git go <branch>` — checkout or create branch
- `git dm` — delete merged branches
- `git fuck` — `reset HEAD --hard`
- `git pushup` / `git pu` — push and set upstream
- `push.autoSetupRemote = true` — new branches auto-track upstream

### Tmux (`Ctrl-a` prefix)

- `|` / `-` — split horizontal / vertical
- `h` `j` `k` `l` — navigate panes
- `H` `J` `K` `L` — resize panes
- TPM with tmux-sensible and tmux-resurrect

### Vim

- Relative line numbers, 80-char column guide
- Persistent undo, system clipboard
- Netrw tree view (no plugins needed)
