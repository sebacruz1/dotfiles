# ==== Historial y opciones
HISTFILE="$HOME/.zsh_history"
HISTSIZE=200000
SAVEHIST=200000
if [[ -n "$TMUX_PANE" ]]; then
  export HISTFILE=$HOME/.zsh_history_tmux_${TMUX_PANE:1}
else
  export HISTFILE=$HOME/.zsh_history
fi

# Opciones de historial recomendadas
unsetopt share_history
setopt inc_append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt hup

export EDITOR=nvim

if command -v brew >/dev/null 2>&1; then
  eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv)"
  [[ -d "$HOMEBREW_PREFIX/share/zsh/site-functions" ]] && fpath+=("$HOMEBREW_PREFIX/share/zsh/site-functions")
fi

[[ -d /usr/share/zsh/site-functions ]] && fpath+=("/usr/share/zsh/site-functions")

autoload -Uz compinit
compinit -i

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' 'r:|[._-]=* r:|=*'
zstyle ':completion:*' completer _extensions _complete _approximate

source /opt/homebrew/opt/antidote/share/antidote/antidote.zsh

ZPLUGINS="${ZDOTDIR:-$HOME}/.zsh_plugins.txt"
ZSTATIC="${ZDOTDIR:-$HOME}/.zsh_plugins.zsh"

if [[ ! -f "$ZPLUGINS" ]]; then
  cat > "$ZPLUGINS" <<'EOF'
zdharma-continuum/fast-syntax-highlighting
zsh-users/zsh-autosuggestions
ohmyzsh/ohmyzsh path:plugins/git
ohmyzsh/ohmyzsh path:plugins/composer
ohmyzsh/ohmyzsh path:plugins/laravel
ohmyzsh/ohmyzsh path:plugins/npm
ohmyzsh/ohmyzsh path:plugins/tmux
EOF
fi

if [[ ! -f "$ZSTATIC" || "$ZPLUGINS" -nt "$ZSTATIC" ]]; then
  antidote bundle < "$ZPLUGINS" > "$ZSTATIC"
fi
source "$ZSTATIC"

if command -v brew >/dev/null 2>&1; then
  FZF_PREFIX="$HOMEBREW_PREFIX/opt/fzf"
  [[ -r "$FZF_PREFIX/shell/key-bindings.zsh" ]] && source "$FZF_PREFIX/shell/key-bindings.zsh"
  [[ -r "$FZF_PREFIX/shell/completion.zsh"   ]] && source "$FZF_PREFIX/shell/completion.zsh"
fi

bindkey -v
bindkey '^I' expand-or-complete

autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic

[[ -r ~/.aliases.zsh   ]] && source ~/.aliases.zsh
[[ -r ~/.functions.zsh ]] && source ~/.functions.zsh
[ -f "$HOME/.aliases.local.zsh"  ] && source "$HOME/.aliases.local.zsh"

export PATH="/usr/local/mysql/bin:$PATH"
export PATH=$PATH:$HOME/.config/composer/vendor/bin

# ==== Inicialización de Starship
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi
