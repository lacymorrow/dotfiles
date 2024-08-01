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

########## Variables

dir=~/dotfiles                    # dotfiles directory
olddir=~/dotfiles_old             # old dotfiles backup directory

bash "$dir/.osx"

bash "$dir/brew.sh"

bash "$dir/node.sh"

bash "$dir/symlink_dotfiles.sh"

# Install oh my zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"


###############################################################################
# Copy Files
###############################################################################

# Set up my preferred keyboard shortcuts
# cp -r settings/BetterSnapTool ~/Library/Application\ Support/BetterSnapTool/ 2> /dev/null
# cp -r settings/Preferences ~/Library/Preferences 2> /dev/null


###############################################################################
# Manual URL Installs                                                         #
###############################################################################

for app in "https://symless.com/synergy" \
	"https://cursor.sh" \
	"https://www.privateinternetaccess.com"; do
	open "${app}"
done
