#  ==== Instant prompt p10k
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ==== Historial y opciones
HISTFILE="$HOME/.zsh_history"
HISTSIZE=200000
SAVEHIST=200000
setopt sharehistory histignoredups histignorespace extendedglob

export EDITOR=vim

autoload -Uz compinit
[[ -f "$HOME/.zcompdump" ]] && compinit -i || compinit -C

# ==== Antidote bootstrap
if [[ ! -d ${ZDOTDIR:-$HOME}/.antidote ]]; then
  git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-$HOME}/.antidote
fi

source ${ZDOTDIR:-$HOME}/.antidote/antidote.zsh

# ==== Lista de plugins declarativa
ZPLUGINS="${ZDOTDIR:-$HOME}/.zsh_plugins.txt"
if [[ ! -f "$ZPLUGINS" ]]; then
  cat > "$ZPLUGINS" <<'EOF'
romkatv/powerlevel10k
zdharma-continuum/fast-syntax-highlighting
docker/cli           kind:completion
ohmyzsh/ohmyzsh path:plugins/git
EOF
fi

antidote load

FZF_PREFIX="$(brew --prefix fzf 2>/dev/null || true)"
if [[ -n "$FZF_PREFIX" ]]; then
  [[ -r "$FZF_PREFIX/shell/key-bindings.zsh" ]] && source "$FZF_PREFIX/shell/key-bindings.zsh"
  [[ -r "$FZF_PREFIX/shell/completion.zsh"   ]] && source "$FZF_PREFIX/shell/completion.zsh"
fi

bindkey -v

[[ -r ~/.aliases.zsh   ]] && source ~/.aliases.zsh
[[ -r ~/.functions.zsh ]] && source ~/.functions.zsh

# ==== p10k config
[[ -r ~/.p10k.zsh ]] && source ~/.p10k.zsh

