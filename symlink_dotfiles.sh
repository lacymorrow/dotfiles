#!/bin/bash
############################
#
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
#
############################

########## Variables

dir=~/dotfiles                    # dotfiles directory
olddir=~/dotfiles_old             # old dotfiles backup directory

##########

# create dotfiles_old in homedir
echo "Creating $olddir for backup of any existing dotfiles in ~"
mkdir -p $olddir
echo "...done"

# echo "> Clone firmware"

# Clone files
# echo "Cloning the dotfiles"
# git clone --single-branch --branch master https://github.com/lacymorrow/dotfiles.git $dir
# echo "...done"

# change to the dotfiles directory
echo "Changing to the $dir directory"
cd $dir
echo "...done"

if [ -d "$dir" ]; then

    # move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks
    echo "Moving any existing dotfiles from ~ to $olddir"

    # matches all dotfiles, except . and ..
    for file in "$dir"/home/.[!.]*; do
        mv  ~/$(basename "$file") $olddir
        echo "Creating symlink to $file in home directory."
        ln -s $file ~/$(basename "$file")
    done

fi
