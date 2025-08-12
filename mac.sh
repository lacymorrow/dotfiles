#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
#
# ORDER IS IMPORTANT:
# - Copy dotfiles to homefolder
# - Install Oh My Zsh (depends on dotfiles in home)
# - Install brew
# - Install NVM
# - Install node `nvm install node`
# - Install node packages (depends on node)
############################

dir=~/dotfiles                    # dotfiles directory

bash "$dir/apply-macos-settings.sh"

bash "$dir/brew.sh"

bash "$dir/node.sh"

bash "$dir/symlink_dotfiles.sh"

# Install oh my zsh
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"


###############################################################################
# Copy Files
###############################################################################

# Set up my preferred keyboard shortcuts
# cp -r settings/BetterSnapTool ~/Library/Application\ Support/BetterSnapTool/ 2> /dev/null
# cp -r settings/Preferences ~/Library/Preferences 2> /dev/null


###############################################################################
# Manual URL Installs                                                         #
###############################################################################

#	"https://cursor.sh" \
for app in "https://symless.com/synergy" \
	"https://www.privateinternetaccess.com"; do
	open "${app}"
done

sleep 30

echo "Waiting for 30 seconds to let the apps install..."

###############################################################################
# Kill affected applications                                                  #
###############################################################################

for app in "Activity Monitor" \
	"Address Book" \
	"Calendar" \
	"cfprefsd" \
	"Contacts" \
	"Dock" \
	"Finder" \
	"Google Chrome Canary" \
	"Google Chrome" \
	"Messages" \
	"Photos" \
	"Safari" \
	"Spectacle" \
	"SystemUIServer" \
	"Terminal" \
	"Transmission"; do
	killall "${app}" &>/dev/null
done

read -p "Press Enter to restart the computer..."
sudo shutdown -r now