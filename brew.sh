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

# Auto-detect Homebrew installation path (Intel vs Apple Silicon)
if [[ -f "/opt/homebrew/bin/brew" ]]; then
    # Apple Silicon Mac
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f "/usr/local/bin/brew" ]]; then
    # Intel Mac
    eval "$(/usr/local/bin/brew shellenv)"
fi

# Disable telemetry
brew analytics off

# Install everything from Brewfile
brew bundle
