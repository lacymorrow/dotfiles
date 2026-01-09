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

# Note: HOMEBREW_PREFIX is already set by brew shellenv above

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

# Initialize completions with caching (rebuild once per day)
# -u flag ignores insecure directories (group-writable Homebrew dirs)
autoload -Uz compinit
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
    compinit -u
else
    compinit -C -u  # Use cached completions
fi

# NVM - Lazy load for fast shell startup (saves ~500ms)
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
    # Lazy load nvm, node, npm, npx, yarn, pnpm
    __load_nvm() {
        unset -f nvm node npm npx yarn pnpm __load_nvm
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    }
    nvm() { __load_nvm && nvm "$@"; }
    node() { __load_nvm && node "$@"; }
    npm() { __load_nvm && npm "$@"; }
    npx() { __load_nvm && npx "$@"; }
    yarn() { __load_nvm && yarn "$@"; }
    pnpm() { __load_nvm && pnpm "$@"; }
fi

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

# SSH host completion is handled by zsh's built-in _ssh completion

# Git alias completion is set up in .zshrc
