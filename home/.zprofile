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
# * ~/.secrets for API tokens and credentials (never committed).
# * ~/.extra can be used for other settings you don't want to commit.
for file in ~/.{path,exports,aliases,docker_aliases,functions,secrets,extra}; do
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

# NVM setup
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
    # Add NVM default node bin to PATH for global npm tools (like claude)
    if [ -f "$NVM_DIR/alias/default" ]; then
        __nvm_default_version=$(cat "$NVM_DIR/alias/default")
        # Resolve version alias to actual version directory
        if [ -d "$NVM_DIR/versions/node/v$__nvm_default_version" ]; then
            export PATH="$NVM_DIR/versions/node/v$__nvm_default_version/bin:$PATH"
        elif [ -d "$NVM_DIR/versions/node/$__nvm_default_version" ]; then
            export PATH="$NVM_DIR/versions/node/$__nvm_default_version/bin:$PATH"
        else
            # Find matching version directory (handles major version aliases like "24" -> "v24.x.x")
            # (N) glob qualifier: return empty instead of error when no matches (for aliases like "node")
            for __nvm_dir in "$NVM_DIR/versions/node/v$__nvm_default_version"*(N); do
                if [ -d "$__nvm_dir" ]; then
                    export PATH="$__nvm_dir/bin:$PATH"
                    break
                fi
            done
        fi
        unset __nvm_default_version __nvm_dir
    fi

    # Load NVM
    \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
fi

# Ngrok shell completions - lazy load on first use
ngrok() {
    unset -f ngrok
    if command -v ngrok &>/dev/null; then
        eval "$(command ngrok completion)"
    fi
    command ngrok "$@"
}

# Common tool paths (guarded — only added if installed)
# Bun
if [ -d "$HOME/.bun" ]; then
    export BUN_INSTALL="$HOME/.bun"
    export PATH="$BUN_INSTALL/bin:$PATH"
    [ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"  # completions
fi

# Go
[ -d "$HOME/go/bin" ] && export PATH="$HOME/go/bin:$PATH"

# Cargo/Rust
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# Local bin
[ -d "$HOME/.local/bin" ] && export PATH="$HOME/.local/bin:$PATH"
