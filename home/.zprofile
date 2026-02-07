# Zsh login shell — shared setup + zsh-specific plugins/completions

# Shared login setup (PATH, tools, dotfiles)
[ -f "$HOME/.shell_common" ] && . "$HOME/.shell_common"

# Backwards compat for bash completions in zsh
autoload -U +X bashcompinit && bashcompinit

# Zsh plugins (installed via Homebrew)
if [ -n "$HOMEBREW_PREFIX" ]; then
    [ -f "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && \
        source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

    [ -f "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && \
        source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

    FPATH="$HOMEBREW_PREFIX/share/zsh-completions:$FPATH"
fi

# Bun zsh completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# Deno completions
fpath=(~/.zsh $fpath)

# Initialize completions with caching (rebuild once per day)
autoload -Uz compinit
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
    compinit -u
else
    compinit -C -u
fi
