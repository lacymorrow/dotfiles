#!/bin/bash
############################
#
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
#
############################

########## Variables

dir="${DIR:-$HOME/dotfiles}"                    # dotfiles directory
olddir="${OLDDIR:-$HOME/dotfiles_old}"             # old dotfiles backup directory

##########

# change to the dotfiles directory
echo "Changing to the $dir directory"
cd "$dir" || exit 1
echo "...done"

if [ -d "$dir" ]; then

    # move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks
    echo "Setting up symlinks from ~ to $dir/home"

    created=0
    skipped=0
    backed_up=0

    # matches all dotfiles, except . and ..
    for file in "$dir"/home/.[!.]*; do
        target="$HOME/$(basename "$file")"

        # Check if symlink already points to the correct target
        if [ -L "$target" ]; then
            current="$(readlink "$target")"
            if [ "$current" = "$file" ] || [ "$(cd "$(dirname "$current")" 2>/dev/null && pwd)/$(basename "$current")" = "$(cd "$(dirname "$file")" && pwd)/$(basename "$file")" ]; then
                skipped=$((skipped + 1))
                continue
            fi
        fi

        # Back up existing file/symlink
        if [ -e "$target" ] || [ -L "$target" ]; then
            echo "Backing up $target to $olddir"
            mkdir -p "$olddir"
            mv "$target" "$olddir/" 2>/dev/null
            backed_up=$((backed_up + 1))
        fi

        echo "Creating symlink to $file in home directory."
        ln -s "$file" "$target"
        created=$((created + 1))
    done

    echo ""
    echo "Symlinks: $created created, $skipped already correct, $backed_up backed up"

fi
