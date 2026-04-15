# ==== Historial y opciones
HISTFILE="$HOME/.zsh_history"
HISTSIZE=200000
SAVEHIST=200000

# setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt hup

export EDITOR=nvim
export VISUAL=nvim
export MANPAGER="nvim +Man!"
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
export FZF_DEFAULT_OPTS='--color=bg+:#2d4f67,bg:#1f1f28,hl:#7e9cd8,fg:#dcd7ba,prompt:#7fb4ca --height 40% --layout=reverse'
#
if command -v brew >/dev/null 2>&1; then
  eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv)"
  [[ -d "$HOMEBREW_PREFIX/share/zsh/site-functions" ]] && fpath+=("$HOMEBREW_PREFIX/share/zsh/site-functions")
fi

[[ -d /usr/share/zsh/site-functions ]] && fpath+=("/usr/share/zsh/site-functions")

export ZSH_CACHE_DIR=$HOME/.cache/zsh
[[ ! -d "$ZSH_CACHE_DIR/completions" ]] && mkdir -p "$ZSH_CACHE_DIR/completions"

autoload -Uz compinit
compinit -i

zstyle ':completion:*' menu no
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' completer _extensions _complete _approximate _ignored
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*' 'm:{a-zA-Z}={A-Za-z} r:|[._-]=* r:|=* l:|=* r:|=*'
zstyle ':fzf-tab:*' fzf-flags '--color=bg+:#2d4f67,bg:#1f1f28,hl:#7e9cd8,fg:#dcd7ba,prompt:#7fb4ca'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always --icons --git $realpath'
zstyle ':fzf-tab:complete:php:argument-1' fzf-preview '[[ $word == "artisan" ]] && php artisan help $word || echo "No es un comando de artisan"'
zstyle ':fzf-tab:complete:git-(checkout|show|diff):*' fzf-preview 'git show --color=always $word | delta --line-numbers'


if command -v brew >/dev/null 2>&1; then
  FZF_PREFIX="$HOMEBREW_PREFIX/opt/fzf"
  [[ -r "$FZF_PREFIX/shell/key-bindings.zsh" ]] && source "$FZF_PREFIX/shell/key-bindings.zsh"
  [[ -r "$FZF_PREFIX/shell/completion.zsh"   ]] && source "$FZF_PREFIX/shell/completion.zsh"
fi
source /opt/homebrew/opt/antidote/share/antidote/antidote.zsh

ZPLUGINS="${ZDOTDIR:-$HOME}/.zsh_plugins.txt"
ZSTATIC="${ZDOTDIR:-$HOME}/.zsh_plugins.zsh"

if [[ ! -f "$ZPLUGINS" ]]; then
  cat > "$ZPLUGINS" <<'EOF'
ohmyzsh/ohmyzsh path:plugins/git
ohmyzsh/ohmyzsh path:plugins/composer
ohmyzsh/ohmyzsh path:plugins/laravel
ohmyzsh/ohmyzsh path:plugins/npm
ohmyzsh/ohmyzsh path:plugins/docker
ohmyzsh/ohmyzsh path:plugins/docker-compose
paulirish/git-open
fdellwing/zsh-bat
Aloxaf/fzf-tab
zdharma-continuum/fast-syntax-highlighting
EOF
fi

if [[ ! -f "$ZSTATIC" || "$ZPLUGINS" -nt "$ZSTATIC" ]]; then
  antidote bundle < "$ZPLUGINS" > "$ZSTATIC"
fi
source "$ZSTATIC"

bindkey -e

autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic

eval "$(zoxide init zsh)"
[[ -r ~/.aliases.zsh   ]] && source ~/.aliases.zsh
[[ -r ~/.functions.zsh ]] && source ~/.functions.zsh
[ -f "$HOME/.aliases.local.zsh"  ] && source "$HOME/.aliases.local.zsh"

export PATH="/usr/local/mysql/bin:$PATH"
export PATH=$PATH:$HOME/.config/composer/vendor/bin

if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

export PATH="$HOME/.local/bin:$PATH"
[[ -f "$HOME/.deno/env" ]] && source "$HOME/.deno/env"
