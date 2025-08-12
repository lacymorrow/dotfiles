# Load backwards compatability - https://github.com/eddiezane/lunchy/issues/57
autoload -U +X bashcompinit && bashcompinit

# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:$PATH"

# Homebrew: Set PATH, MANPATH, etc., for Homebrew.
# Auto-detect Homebrew installation path (Intel vs Apple Silicon)
if [[ -f "/opt/homebrew/bin/brew" ]]; then
    # Apple Silicon Mac
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f "/usr/local/bin/brew" ]]; then
    # Intel Mac
    eval "$(/usr/local/bin/brew shellenv)"
fi

# Cache brew --prefix for performance (saves 300-600ms on startup)
# Only set if brew is available and HOMEBREW_PREFIX isn't already set
if command -v brew &>/dev/null && [[ -z "${HOMEBREW_PREFIX}" ]]; then
    export HOMEBREW_PREFIX="$(brew --prefix)"
fi

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don't want to commit.
for file in ~/.{path,exports,aliases,docker_aliases,functions,extra}; do
	[ -r "$file" ] && [ -f "$file" ] && [ -s "$file" ] && source "$file"
done
unset file

# https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md#oh-my-zsh
if [ -f "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
    source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md
if [ -f "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
    source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# ZSH completions setup
if type brew &>/dev/null; then
    FPATH="$HOMEBREW_PREFIX/share/zsh-completions:$FPATH"
fi

# Deno completions
fpath=(~/.zsh $fpath)

# Initialize completions (do this once after setting up FPATH)
autoload -Uz compinit
compinit -u

# NVM - Load directly for immediate Node.js tool availability
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Ngrok shell completions - lazy load on first use
ngrok() {
    unset -f ngrok
    if command -v ngrok &>/dev/null; then
        eval "$(command ngrok completion)"
    fi
    command ngrok "$@"
}

# Enable ZSH options (equivalent to Bash features)
setopt AUTO_CD          # Equivalent to autocd
setopt GLOB_STAR_SHORT  # Equivalent to globstar

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh

# ZSH-specific completions
# Enable git completion for 'g' alias (if it exists)
if type git &>/dev/null && [ -f ~/.aliases ]; then
    compdef g=git 2>/dev/null
fi
