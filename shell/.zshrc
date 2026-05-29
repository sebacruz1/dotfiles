# ==== Historial y opciones
HISTFILE="$HOME/.zsh_history"
HISTSIZE=200000
SAVEHIST=200000
setopt APPEND_HISTORY INC_APPEND_HISTORY HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE hup

export EDITOR=nvim
export VISUAL=nvim
export MANPAGER="nvim +Man!"
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
export FZF_DEFAULT_OPTS='--color=bg+:#2d4f67,bg:#1f1f28,hl:#7e9cd8,fg:#dcd7ba,prompt:#7fb4ca --height 40% --layout=reverse'

export ZSH_CACHE_DIR="${HOME}/.cache/zsh"
export ZPLUGINS="${ZDOTDIR:-$HOME}/.zsh_plugins.txt"
export ZSTATIC="${ZDOTDIR:-$HOME}/.zsh_plugins.zsh"

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

source ~/.antidote/antidote.zsh

antidote bundle < "$ZPLUGINS" > "$ZSTATIC"

autoload -Uz compinit
compinit -i

source "$ZSTATIC"

zstyle ':completion:*' menu no
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' completer _extensions _complete _approximate _ignored
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':fzf-tab:*' fzf-flags '--color=bg+:#2d4f67,bg:#1f1f28,hl:#7e9cd8,fg:#dcd7ba,prompt:#7fb4ca'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always --icons --git $realpath'
zstyle ':fzf-tab:complete:php:argument-1' fzf-preview '[[ $word == "artisan" ]] && php artisan help $word || echo "No es un comando de artisan"'
zstyle ':fzf-tab:complete:git-(checkout|show|diff):*' fzf-preview 'git show --color=always $word | delta --line-numbers'

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  [[ -r "/usr/share/fzf/key-bindings.zsh" ]] && source "/usr/share/fzf/key-bindings.zsh"
  [[ -r "/usr/share/fzf/completion.zsh"   ]] && source "/usr/share/fzf/completion.zsh"
fi

bindkey -e
[[ -r ~/.aliases.zsh   ]] && source ~/.aliases.zsh
[[ -r ~/.functions.zsh ]] && source ~/.functions.zsh
[ -f "$HOME/.aliases.local.zsh"  ] && source "$HOME/.aliases.local.zsh"

if command -v zoxide >/dev/null 2>&1; then eval "$(zoxide init zsh)"; fi
if command -v starship >/dev/null 2>&1; then eval "$(starship init zsh)"; fi
