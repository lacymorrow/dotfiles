#!/usr/bin/env sh

echo ""
echo "#############################"
echo "# Installing applications via Homebrew from brew.sh"
echo "#############################"
echo ""

###############################################################################
# HomeBrew                                                                    #
###############################################################################

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(/usr/local/bin/brew shellenv)"

# Disable telemetry
brew analytics off

# Install everything from Brewfile
brew bundle
