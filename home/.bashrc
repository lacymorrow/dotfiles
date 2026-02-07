# Bash interactive shell configuration

# Non-interactive guard
[ -z "$PS1" ] && return

# Ensure login setup has run (e.g. for non-login interactive shells)
[ -z "$__shell_common_loaded" ] && [ -f "$HOME/.bash_profile" ] && . "$HOME/.bash_profile"

# Bash history
HISTSIZE=32768
HISTFILESIZE=$HISTSIZE
HISTCONTROL=ignoredups
HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help"

# Starship prompt
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init bash)"
fi

# Lacy Shell (requires Bash 4+)
if [[ ${BASH_VERSINFO[0]} -ge 4 ]] && [[ -f "${HOME}/.lacy/lacy.plugin.bash" ]]; then
    source "${HOME}/.lacy/lacy.plugin.bash"
fi
