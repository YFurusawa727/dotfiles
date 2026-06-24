# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a macOS dotfiles repository managed with **GNU Stow** and **Homebrew**. It sets up a development environment by symlinking configuration files from `packages/` into the home directory.

## Key Commands

```bash
# Pre-installation validation
bash validate.sh

# Full installation
bash install

# Post-installation tests
bash test_install.sh

# Aliases available after install (defined in packages/bash/.bashrc)
dotcheck       # validate.sh
dotinstall     # install
dottest        # test_install.sh (summary only)
dottest-full   # test_install.sh with full output
dotvalidate    # validate.sh
```

## Architecture

### Package Management via Stow

All managed configs live under `packages/<tool>/` and mirror the home directory structure. The install script runs:

```bash
stow --adopt -v -d ~/dotfiles/packages -t ~ git asdf zsh bash starship alacritty
```

The `--adopt` flag pulls in any existing configs (preventing data loss) before creating symlinks.

### Managed Packages

| Package | Key File(s) |
|---------|-------------|
| `git` | `.gitconfig.example` → generates `.gitconfig` from `.env` |
| `zsh` | `.zshrc` |
| `bash` | `.bashrc` (aliases) |
| `asdf` | `.tool-versions` (Node 22.18.0, Python 3.12.3, Firebase 14.12.1, Java corretto-17) |
| `starship` | `.config/starship.toml` |
| `alacritty` | `.config/alacritty/alacritty.toml` |

### Environment Variables

Personal info (git name, email) is stored in `.env` (git-ignored). The install script prompts for these and generates `.gitconfig` from `.gitconfig.example` using sed substitution. Use `.env.example` as a template.

### install Script Flow

1. Install Homebrew (if missing) and add to `.zprofile`
2. Run `brew bundle` from Brewfile
3. Create `.env` interactively
4. `stow --adopt` to absorb existing configs
5. Create symlinks for all packages
6. Install asdf plugins and runtimes from `.tool-versions`

## Brewfile

Contains CLI tools (including `asdf`, `stow`, `starship`, `fzf`, `peco`, `gh`, `zsh-syntax-highlighting`) and macOS apps via cask (including `alacritty`, `claude`, `claude-code`, `codex`). Add new tools here and run `brew bundle` to apply.

## Testing & Validation

- `validate.sh` — pre-install checks: system requirements, file structure, executable bits, Brewfile syntax, sensitive info scan, stow package structure
- `test_install.sh` — post-install checks: commands available, config files exist, stow symlinks valid, asdf runtimes, shell syntax, git config, starship config
- Results are logged to `test_results.log`

## Security Notes

- `.env` and `.gitconfig` are git-ignored; never commit personal info
- `validate.sh` scans for sensitive patterns before install
- sed substitutions in `install` use `|` as delimiter to safely handle paths with `/`
