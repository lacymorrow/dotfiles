#!/bin/bash
############################
#
# Symlinks dotfiles from ~/dotfiles/home into the home directory.
#
# Top-level dotfiles (.zshrc, .gitconfig, ...) are symlinked directly.
# Directories (.config, .ssh) are RECURSED INTO: the directory itself is
# created as a real directory in ~ and the files inside are symlinked
# individually. This matters — symlinking ~/.ssh at the directory level
# would put any key you later generate inside the git repo, and would make
# every tool that writes to ~/.config write into the repo too.
#
############################

set -uo pipefail

dir="${DIR:-$HOME/dotfiles}"
olddir="${OLDDIR:-$HOME/dotfiles_old}"
srcdir="$dir/home"

created=0
skipped=0
backed_up=0

link_file() {
    local source="$1" target="$2"

    # Already pointing where we want it?
    if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
        skipped=$((skipped + 1))
        return
    fi

    # Back up whatever is in the way
    if [ -e "$target" ] || [ -L "$target" ]; then
        local backup_dir
        backup_dir="$olddir/$(dirname "${target#"$HOME"/}")"
        mkdir -p "$backup_dir"
        echo "  backing up $target"
        mv "$target" "$backup_dir/" 2>/dev/null
        backed_up=$((backed_up + 1))
    fi

    mkdir -p "$(dirname "$target")"
    ln -s "$source" "$target"
    echo "  linked ${target#"$HOME"/}"
    created=$((created + 1))
}

# Recurse: mirror directory structure, symlink leaf files.
walk() {
    local src="$1" dest="$2" entry name

    for entry in "$src"/* "$src"/.[!.]*; do
        [ -e "$entry" ] || continue
        name="$(basename "$entry")"

        if [ -d "$entry" ]; then
            mkdir -p "$dest/$name"
            walk "$entry" "$dest/$name"
        else
            link_file "$entry" "$dest/$name"
        fi
    done
}

if [ ! -d "$srcdir" ]; then
    echo "No $srcdir directory found." >&2
    exit 1
fi

echo "Symlinking $srcdir -> $HOME"
walk "$srcdir" "$HOME"

# ~/.ssh must be 700 or ssh refuses to use it
[ -d "$HOME/.ssh" ] && chmod 700 "$HOME/.ssh"

echo ""
echo "Symlinks: $created created, $skipped already correct, $backed_up backed up to $olddir"
