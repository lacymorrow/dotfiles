# ZSH Configuration - Essential options for modern shell experience
setopt AUTO_CD              # Change to directory just by typing directory name
setopt GLOB_STAR_SHORT      # Enable ** for recursive globbing
setopt HIST_VERIFY          # Show expanded history command before executing
setopt SHARE_HISTORY        # Share history between sessions
setopt APPEND_HISTORY       # Append to history file
setopt INC_APPEND_HISTORY   # Add commands to history immediately
setopt HIST_IGNORE_DUPS     # Don't record duplicate commands
setopt HIST_IGNORE_SPACE    # Don't record commands starting with space
setopt HIST_REDUCE_BLANKS   # Remove extra blanks from commands
setopt CORRECT              # Enable command correction
setopt COMPLETE_IN_WORD     # Complete from both ends of word
setopt ALWAYS_TO_END        # Move cursor to end after completion

# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# Enable advanced completions
autoload -Uz compinit
compinit -u

# Git completion for 'g' alias (if it exists)
if type git &>/dev/null && [ -f ~/.aliases ]; then
    compdef g=git 2>/dev/null
fi

# Key bindings for word navigation and deletion
# Use emacs-style key bindings
bindkey -e

# Word navigation (Option+Arrow keys)
bindkey "^[OC" forward-word         # Option+Right Arrow
bindkey "^[OD" backward-word        # Option+Left Arrow
bindkey "^[[1;5C" forward-word      # Ctrl+Right Arrow
bindkey "^[[1;5D" backward-word     # Ctrl+Left Arrow

# Word deletion
bindkey "^[^?" backward-kill-word   # Option+Backspace
bindkey "^W" backward-kill-word     # Ctrl+W (alternative)
bindkey "^[d" kill-word             # Option+Delete

# Fix for different terminal emulators
bindkey "^[[3~" delete-char         # Delete key
bindkey "^[3;5~" kill-word          # Ctrl+Delete

# Initialize Starship prompt
eval "$(starship init zsh)"