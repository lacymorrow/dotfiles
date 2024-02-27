#!/usr/bin/env sh

# Brew should have already installed node

# Install NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# Install NPM global packages
for app in "yarn" \
	; do
	npm install -g "${app}"
done
