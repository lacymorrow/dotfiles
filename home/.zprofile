# Load backwards compatability - https://github.com/eddiezane/lunchy/issues/57
autoload -U +X bashcompinit && bashcompinit

# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:$PATH"

# Homebrew: Set PATH, MANPATH, etc., for Homebrew.
eval "$(/usr/local/bin/brew shellenv)" # intel mac
# eval "$(/opt/homebrew/bin/brew shellenv)" # apple-silicon mac

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don't want to commit.
for file in ~/.{path,exports,aliases,docker_aliases,functions,extra,zshrc}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file

# https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md#oh-my-zsh
if [ -f "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
    source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md
if [ -f "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
    source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# ZSH completions setup
if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
fi

# Deno completions
fpath=(~/.zsh $fpath)

# Initialize completions (do this once after setting up FPATH)
autoload -Uz compinit
compinit -u

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# Ngrok shell completions
if command -v ngrok &>/dev/null; then
	eval "$(ngrok completion)"
fi

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

# Created by `pipx` on 2024-09-05 23:39:51
export PATH="$PATH:/Users/lacy/.local/bin"
