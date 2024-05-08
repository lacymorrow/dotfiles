#!/usr/bin/env sh

# Brew should be installed
if ! type "brew" > /dev/null; then
    echo "Homebrew is not installed. Please install it first."
	exit 1
fi

# Install NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# Source it
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Install latest Node
nvm install node

# Install NPM global packages
for app in "yarn" \
	"pnpm" \
	"eslint" \
	"npm-check-updates" \
	; do
	npm install -g "${app}"
done

# Enable Yarn Corepack
corepack enable || echo "Could not enable Yarn Corepack"