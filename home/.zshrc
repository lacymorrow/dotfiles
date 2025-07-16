#!/usr/bin/env zsh
# Optimized .zshrc configuration

# Performance: Skip the global compinit, we'll do it ourselves
skip_global_compinit=1

# Add ~/bin to PATH if not already present
[[ ":$PATH:" != *":$HOME/bin:"* ]] && export PATH="$HOME/bin:$PATH"

# Cache brew prefix for performance
if command -v brew &>/dev/null; then
    if [[ -f "$HOME/.brew_prefix" ]]; then
        export BREW_PREFIX="$(<"$HOME/.brew_prefix")"
    else
        export BREW_PREFIX="$(brew --prefix)"
        echo "$BREW_PREFIX" > "$HOME/.brew_prefix"
    fi
    
    # Set PATH for Homebrew
    export PATH="$BREW_PREFIX/bin:$BREW_PREFIX/sbin:$PATH"
fi

# Source basic configuration files first
typeset -U config_files
config_files=(
    ~/.path
    ~/.exports
    ~/.history_settings
)

for file in ${config_files[@]}; do
    [[ -r "$file" ]] && [[ -f "$file" ]] && source "$file"
done
unset config_files

# Oh My Zsh Configuration (if installed)
if [[ -d "$HOME/.oh-my-zsh" ]]; then
    export ZSH="$HOME/.oh-my-zsh"
    
    # Install custom uber theme if it exists
    if [[ -f "$HOME/dotfiles/uber.zsh-theme" ]] && [[ ! -f "$ZSH/custom/themes/uber.zsh-theme" ]]; then
        mkdir -p "$ZSH/custom/themes"
        cp "$HOME/dotfiles/uber.zsh-theme" "$ZSH/custom/themes/"
    fi
    
    # Use custom theme if available, fallback to robbyrussell
    if [[ -f "$ZSH/custom/themes/uber.zsh-theme" ]]; then
        ZSH_THEME="uber"
    else
        ZSH_THEME="robbyrussell"
    fi
    
    # Performance optimizations
    DISABLE_AUTO_UPDATE="true"
    DISABLE_UPDATE_PROMPT="true"
    
    # Load Oh My Zsh
    source "$ZSH/oh-my-zsh.sh"
fi

# Source custom overrides AFTER Oh My Zsh
typeset -U override_files
override_files=(
    ~/.aliases
    ~/.docker_aliases
    ~/.functions
    ~/.extra
)

for file in ${override_files[@]}; do
    if [[ -r "$file" ]] && [[ -f "$file" ]]; then
        source "$file"
    fi
done
unset override_files

# ZSH-specific options
setopt AUTO_CD              # cd by typing directory name
setopt GLOB_STAR_SHORT      # ** for recursive globbing
setopt HIST_IGNORE_ALL_DUPS # Remove older duplicate entries from history
setopt HIST_REDUCE_BLANKS   # Remove blanks from history
setopt SHARE_HISTORY        # Share history between sessions
setopt EXTENDED_HISTORY     # Save timestamp in history

# History configuration
HISTSIZE=32768
HISTFILE="$HOME/.zsh_history"
SAVEHIST=$HISTSIZE

# Lazy load NVM for better performance
if [[ -d "$HOME/.nvm" ]]; then
    export NVM_DIR="$HOME/.nvm"
    # Lazy load nvm
    nvm() {
        unfunction nvm
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
        nvm "$@"
    }
    
    # Load node from .nvmrc if it exists
    load-nvmrc() {
        local node_version="$(nvm version)"
        local nvmrc_path="$(nvm_find_nvmrc)"
        
        if [ -n "$nvmrc_path" ]; then
            local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")
            
            if [ "$nvmrc_node_version" = "N/A" ]; then
                nvm install
            elif [ "$nvmrc_node_version" != "$node_version" ]; then
                nvm use
            fi
        elif [ "$node_version" != "$(nvm version default)" ]; then
            echo "Reverting to nvm default version"
            nvm use default
        fi
    }
    
    # Only load if we need it
    if [[ -f ".nvmrc" ]]; then
        load-nvmrc
    fi
fi

# Load Homebrew completions and plugins efficiently
if [[ -n "$BREW_PREFIX" ]]; then
    # Completions
    FPATH="$BREW_PREFIX/share/zsh/site-functions:$BREW_PREFIX/share/zsh-completions:$FPATH"
    
    # Autosuggestions
    [[ -f "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && \
        source "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    
    # Syntax highlighting (load last)
    [[ -f "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && \
        source "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# Deno completions
[[ -d "$HOME/.zsh" ]] && fpath=("$HOME/.zsh" $fpath)

# Initialize completions (do this once after setting up FPATH)
autoload -Uz compinit
# Check if dump exists and is less than 24 hours old
if [[ -f "$HOME/.zcompdump" ]]; then
    if [[ $(find "$HOME/.zcompdump" -mtime +1 -print) ]]; then
        compinit
    else
        compinit -C
    fi
else
    compinit
fi

# Load bash completion compatibility
autoload -U +X bashcompinit && bashcompinit

# Completion settings
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# SSH completion from config
if [[ -e "$HOME/.ssh/config" ]]; then
    zstyle ':completion:*:ssh:*' hosts $(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')
    zstyle ':completion:*:scp:*' hosts $(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')
fi

# Git completions
[[ -f "$HOME/.git_completions" ]] && source "$HOME/.git_completions"

# Lazy load heavy completions
if command -v ngrok &>/dev/null; then
    ngrok() {
        unfunction ngrok
        eval "$(command ngrok completion)"
        ngrok "$@"
    }
fi

# pipx PATH (if it exists)
[[ -d "$HOME/.local/bin" ]] && export PATH="$PATH:$HOME/.local/bin"

# Local zsh config
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

# Ensure aliases are always loaded (fallback)
if ! alias gs &>/dev/null; then
    [[ -f "$HOME/.aliases" ]] && source "$HOME/.aliases"
fi