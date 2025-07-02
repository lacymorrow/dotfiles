# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository for macOS configuration management using multiple approaches:
- Traditional shell scripts for setup and symlinking
- Homebrew for package management via Brewfile
- Nix/NixOS with nix-darwin for declarative system configuration
- Home Manager for user-specific dotfile management

## Setup Commands

### Initial Setup (Choose one approach)

**Traditional Setup:**
```bash
bash <(curl -s https://raw.githubusercontent.com/lacymorrow/dotfiles/master/mac.sh)
```

**Or run individual components:**
```bash
# Install Homebrew and packages
bash <(curl -s https://raw.githubusercontent.com/lacymorrow/dotfiles/master/brew.sh)

# Install Node.js via NVM
bash <(curl -s https://raw.githubusercontent.com/lacymorrow/dotfiles/master/node.sh)

# Apply macOS system settings
bash ./apply-macos-settings.sh

# Symlink dotfiles to home directory
bash ./symlink_dotfiles.sh
```

**Nix-Darwin Setup:**
```bash
# Build and switch to nix-darwin configuration
nix build .#darwinConfigurations.mac.system
./result/sw/bin/darwin-rebuild switch --flake .

# Or rebuild after changes
darwin-rebuild switch --flake .
```

**Homebrew Package Management:**
```bash
# Install all packages from Brewfile
brew bundle

# Update Brewfile with currently installed packages
brew bundle dump --force
```

## Architecture

### Configuration Structure

- **`flake.nix`** - Nix flake configuration defining inputs and outputs
- **`darwin-configuration.nix`** - System-level Nix packages and macOS configuration
- **`home.nix`** - Home Manager configuration for user dotfiles
- **`Brewfile`** - Homebrew package definitions (CLI tools, GUI apps, Mac App Store apps)
- **`home/`** - Directory containing actual dotfiles (`.bashrc`, `.gitconfig`, `.aliases`, etc.)

### Setup Scripts

- **`mac.sh`** - Main setup script that orchestrates the entire installation
- **`brew.sh`** - Installs Homebrew and runs `brew bundle`
- **`node.sh`** - Sets up Node.js via NVM
- **`apply-macos-settings.sh`** - Applies macOS system preferences
- **`symlink_dotfiles.sh`** - Creates symlinks from `home/` to `~/`

### Package Management Approaches

This repository uses a hybrid approach:
- **Nix packages** for CLI tools and development utilities (defined in `darwin-configuration.nix`)
- **Homebrew casks** for GUI applications and tools not available in nixpkgs
- **Mac App Store** apps managed via `mas` command

### Shell Configuration

- Uses **Zsh** with **Oh My Zsh** framework
- Custom theme: `uber.zsh-theme` (located in repository root)  
- Modular configuration split across multiple dotfiles:
  - `.aliases` - Command aliases including `git fuck` (git reset HEAD --hard)
  - `.docker_aliases` - Docker-specific aliases
  - `.exports` - Environment variable exports
  - `.functions` - Custom shell functions
  - `.bash_prompt` - Custom prompt configuration

### Development Tools

The configuration includes development-focused packages:
- Git with custom configuration
- Node.js ecosystem (npm, yarn, pnpm) via both Nix and NVM
- Docker and container tools
- Code editors: VS Code, Neovim, Sublime Text
- Various CLI utilities: bat, ffmpeg, imagemagick, wget

## Working with This Repository

When making changes:
1. **For Nix changes**: Edit `.nix` files and run `darwin-rebuild switch --flake .`
2. **For Homebrew changes**: Edit `Brewfile` and run `brew bundle`
3. **For dotfiles**: Edit files in `home/` directory, changes are symlinked automatically
4. **For system settings**: Edit `apply-macos-settings.sh` and run it directly

This repository represents a working macOS development environment focused on web development, with strong emphasis on command-line tools and productivity applications.