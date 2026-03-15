# CLAUDE.md

## Repository Overview

Personal dotfiles repository supporting macOS and WSL2 Ubuntu environments.

## Structure

```
dotfiles/         # Config files symlinked to ~ via set.sh
scripts/          # Installation and utility scripts
scripts/install/  # Per-tool install scripts
install_mac.sh    # macOS setup (Homebrew)
install_wsl2_ubuntu.sh  # WSL2 Ubuntu setup
set.sh            # Creates symlinks: dotfiles/.* -> ~/.*
```

## Key Files

| File | Purpose |
|------|---------|
| `dotfiles/.commonrc` | Shared aliases/functions sourced by both bash and zsh |
| `dotfiles/.zshrc` | Zsh config (zplug, completions, vi-mode, keybindings) |
| `dotfiles/.bashrc` | Bash config |
| `dotfiles/.vimrc` | Vim config (dein.vim plugins) |
| `dotfiles/.tmux.conf` | Tmux config (TPM plugins) |
| `dotfiles/.gitconfig` | Git config (vimdiff, sops, ghq) |
| `dotfiles/.config/starship.toml` | Starship prompt config |

## Setup

```bash
# Apply dotfiles (creates symlinks in ~)
./set.sh

# Install tools
./install_wsl2_ubuntu.sh   # WSL2 Ubuntu
./install_mac.sh            # macOS
```

## Conventions

- Shell aliases live in `dotfiles/.commonrc` (shared across bash/zsh)
- New tools get their own script in `scripts/install/<tool>.sh`
- Install scripts should be idempotent and work on fresh Ubuntu/macOS
- No secrets in this repo
