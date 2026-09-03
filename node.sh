#!/usr/bin/env sh

# Node.js toolchain: NVM + Node + Bun + global packages.
#
# IMPORTANT: the files in home/ are symlinked into ~, so ~/.zshrc IS
# home/.zshrc in this repo. The nvm and bun installers both append their own
# setup lines to your shell rc — which means they write straight into tracked
# files and you end up committing generated cruft (with hardcoded absolute
# paths). .shell_common already sets up NVM, Bun and PATH deliberately, so we
# suppress those edits and restore the files if an installer writes anyway.

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
RC_FILES="$DOTFILES_DIR/home/.zshrc $DOTFILES_DIR/home/.zprofile $DOTFILES_DIR/home/.bashrc $DOTFILES_DIR/home/.bash_profile"

snapshot_dir="$(mktemp -d)"
for f in $RC_FILES; do
    [ -f "$f" ] && cp "$f" "$snapshot_dir/$(basename "$f")"
done

restore_rc_files() {
    for f in $RC_FILES; do
        snap="$snapshot_dir/$(basename "$f")"
        if [ -f "$snap" ] && [ -f "$f" ] && ! cmp -s "$snap" "$f"; then
            echo "  reverting installer edit to $(basename "$f")"
            cp "$snap" "$f"
        fi
    done
}

# Install NVM. PROFILE=/dev/null tells its installer not to touch any rc file.
PROFILE=/dev/null bash -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash'

# Source it
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Install latest Node
nvm install node

# Install Bun (its installer has no opt-out flag, so we revert it afterwards)
curl -fsSL https://bun.sh/install | bash
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

restore_rc_files
rm -rf "$snapshot_dir"

# Install global packages via Bun
for app in "yarn" \
	"pnpm" \
	"eslint" \
	"npm-check-updates" \
	"critique" \
	; do
	bun install -g "${app}"
done
