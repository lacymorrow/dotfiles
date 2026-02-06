#!/bin/bash
############################
# DEPRECATED: Use ./setup.sh instead.
#
# This script is kept for reference. The interactive setup wizard
# (./setup.sh) replaces it with prerequisite checks, idempotency,
# and a better UX.
############################

echo ""
echo "⚠  mac.sh is deprecated. Use ./setup.sh instead."
echo ""
read -rp "Continue anyway? (y/N): " confirm
if [[ "$confirm" != [yY] ]]; then
    echo "Run: ./setup.sh"
    exit 0
fi

dir=~/dotfiles

bash "$dir/apply-macos-settings.sh"

bash "$dir/brew.sh"

bash "$dir/node.sh"

bash "$dir/symlink_dotfiles.sh"

###############################################################################
# Kill affected applications                                                  #
###############################################################################

for app in "Activity Monitor" \
	"cfprefsd" \
	"Dock" \
	"Finder" \
	"SystemUIServer"; do
	killall "${app}" &>/dev/null
done

echo ""
echo "Done. Restart your terminal or run: source ~/.zshrc"
