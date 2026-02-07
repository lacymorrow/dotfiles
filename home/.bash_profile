# Bash login shell — shared setup + bash-specific completions

# Shared login setup (PATH, tools, dotfiles)
[ -f "$HOME/.shell_common" ] && . "$HOME/.shell_common"

# Bash shell options
shopt -s nocaseglob   # Case-insensitive globbing
shopt -s histappend   # Append to history file, don't overwrite
shopt -s cdspell      # Autocorrect typos in cd paths
shopt -s autocd 2>/dev/null    # cd by typing directory name (Bash 4+)
shopt -s globstar 2>/dev/null  # Recursive globbing ** (Bash 4+)

# Bash completion framework (Homebrew)
if [ -n "$HOMEBREW_PREFIX" ]; then
    if [ -r "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh" ]; then
        export BASH_COMPLETION_COMPAT_DIR="$HOMEBREW_PREFIX/etc/bash_completion.d"
        . "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"
    fi
elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# Tab completion for `g` as git alias
if type _git &>/dev/null; then
    complete -o default -o nospace -F _git g
fi

# SSH hostname completion from ~/.ssh/config
[ -e "$HOME/.ssh/config" ] && complete -o default -o nospace -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh

# macOS-specific completions
complete -W "NSGlobalDomain" defaults
complete -o nospace -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall
