#!/usr/bin/env sh

# # Brew should be installed
# if ! type "brew" > /dev/null; then
#     echo "Homebrew is not installed. Please install it first."
# 	exit 1
# fi

# Install NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

# Source it
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Install latest Node
nvm install node

# Install Bun
curl -fsSL https://bun.sh/install | bash
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Install global packages via Bun
for app in "yarn" \
	"pnpm" \
	"eslint" \
	"npm-check-updates" \
	"critique" \
	; do
	bun install -g "${app}"
done
