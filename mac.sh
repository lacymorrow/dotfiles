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

##########

# create dotfiles_old in homedir
echo "Creating $olddir for backup of any existing dotfiles in ~"
mkdir -p $olddir
echo "...done"

echo "> Clone firmware"

# Clone files
echo "Cloning the dotfiles"
git clone --single-branch --branch master https://github.com/lacymorrow/dotfiles.git $dir
echo "...done"

# change to the dotfiles directory
echo "Changing to the $dir directory"
cd $dir
echo "...done"

if [ -d "$dir" ]; then

    # move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks
    echo "Moving any existing dotfiles from ~ to $olddir"

    # matches all dotfiles, except . and ..
    for file in "$dir"/home/.[!.]*; do
        # mv ~/$file ~/dotfiles_old/
        echo "Creating symlink to $file in home directory."
        # ln -s $dir/$file ~/$file
    done

fi

###############################################################################
# Copy Files
###############################################################################

# Set up my preferred keyboard shortcuts
cp -r settings/BetterSnapTool ~/Library/Application\ Support/BetterSnapTool/ 2> /dev/null
cp -r settings/Preferences ~/Library/Preferences 2> /dev/null


###############################################################################
# Manual URL Installs                                                         #
###############################################################################

bash "$dir/.osx"

bash "$dir/node.sh"

bash "$dir/brew.sh"

for app in "https://symless.com/synergy" \
	"https://cursor.sh" \
	"https://www.privateinternetaccess.com"; do
	open "${app}"
done
