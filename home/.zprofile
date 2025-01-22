# Load backwards compatability - https://github.com/eddiezane/lunchy/issues/57
time autoload -U +X bashcompinit && bashcompinit
time autoload -U +X compinit && compinit

# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:$PATH"

# Homebrew: Set PATH, MANPATH, etc., for Homebrew.
eval "$(/opt/homebrew/bin/brew shellenv)" # apple-silicon mac
# eval "$(/usr/local/bin/brew shellenv)" # intel mac

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,exports,aliases,docker_aliases,functions,extra,zshrc}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file

# https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md#oh-my-zsh
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md
# If you receive "highlighters directory not found" error message,
# you may need to add the following to your .zshenv:
#   export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/opt/homebrew/share/zsh-syntax-highlighting/highlighters
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ZSH completions
# You may also need to force rebuild `zcompdump`:
#   rm -f ~/.zcompdump; compinit
# Additionally, if you receive "zsh compinit: insecure directories" warnings when attempting
# to load these completions, you may need to run these commands:
#   chmod go-w '/opt/homebrew/share'
#   chmod -R go-w '/opt/homebrew/share/zsh'

if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

    autoload -Uz compinit
	compinit
fi


# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# Ngrok shell completions
if command -v ngrok &>/dev/null; then
	eval "$(ngrok completion)"
fi

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
	shopt -s "$option" 2>/dev/null
done

# Add tab completion for many Bash commands
if which brew &>/dev/null && [ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]; then
	# Ensure existing Homebrew v1 completions continue to work
	export BASH_COMPLETION_COMPAT_DIR="$(brew --prefix)/etc/bash_completion.d"
	source "$(brew --prefix)/etc/profile.d/bash_completion.sh"
elif [ -f /etc/bash_completion ]; then
	source /etc/bash_completion
fi

# Enable tab completion for `g` by marking it as an alias for `git`
if type _git &>/dev/null; then
	complete -o default -o nospace -F _git g
fi

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults

# Add `killall` tab completion for common apps
complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari SystemUIServer Terminal Twitter" killall

# Created by `pipx` on 2024-09-05 23:39:51
export PATH="$PATH:/Users/lacy/.local/bin"

# Deno
fpath=(~/.zsh $fpath)
autoload -Uz compinit
compinit -u
