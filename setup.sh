#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

printf "\n  Setting up prerequisites...\n\n"

# 1. Xcode Command Line Tools (provides git, clang, etc.)
if ! xcode-select -p &>/dev/null; then
    printf "  Installing Xcode Command Line Tools...\n"
    xcode-select --install
    # Wait for install to complete
    until xcode-select -p &>/dev/null; do sleep 5; done
fi
printf "  ✓ Xcode Command Line Tools\n"

# 2. If run via curl pipe, clone the repo (now that git is available)
if [ ! -f "$DOTFILES_DIR/setup/package.json" ]; then
    DOTFILES_DIR="$HOME/dotfiles"
    if [ ! -d "$DOTFILES_DIR" ]; then
        printf "  Cloning dotfiles to ~/dotfiles...\n"
        git clone https://github.com/lacymorrow/dotfiles.git "$DOTFILES_DIR"
    fi
    cd "$DOTFILES_DIR"
fi

# 3. Homebrew
if ! command -v brew &>/dev/null; then
    printf "  Installing Homebrew...\n"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Source brew for this session (Apple Silicon or Intel)
    eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv 2>/dev/null || true)"
fi
printf "  ✓ Homebrew\n"

# 4. Node.js
if ! command -v node &>/dev/null; then
    printf "  Installing Node.js...\n"
    brew install node
fi
printf "  ✓ Node.js\n"

# 5. Install setup dependencies and launch the wizard
cd "$DOTFILES_DIR/setup"
npm install --silent 2>/dev/null
printf "\n"
node index.mjs
