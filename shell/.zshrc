# ==== Instant prompt p10k
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ==== Historial y opciones
HISTFILE="$HOME/.zsh_history"
HISTSIZE=200000
SAVEHIST=200000
setopt sharehistory histignoredups histignorespace extendedglob
export EDITOR=vim

# ------------------------------------------------------------
# SO detection + paths (funciona en macOS y Arch)
# ------------------------------------------------------------
# macOS (brew en Apple Silicon) o Intel
if command -v brew >/dev/null 2>&1; then
  eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv)"
  # Completions de brew
  [[ -d "$HOMEBREW_PREFIX/share/zsh/site-functions" ]] && fpath+=("$HOMEBREW_PREFIX/share/zsh/site-functions")
fi

# Arch Linux (y otras distros que usan el estándar)
[[ -d /usr/share/zsh/site-functions ]] && fpath+=("/usr/share/zsh/site-functions")

# ------------------------------------------------------------
# Inicializar autocompletado ANTES de cargar plugins
# ------------------------------------------------------------
autoload -Uz compinit
compinit -i   # usa -i para ignorar compdefs inválidos

# (Opcional) estilos de completion cómodos
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' 'r:|[._-]=* r:|=*'
zstyle ':completion:*' completer _extensions _complete _approximate

# ==== Antidote bootstrap
if [[ ! -d ${ZDOTDIR:-$HOME}/.antidote ]]; then
  git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-$HOME}/.antidote
fi
source ${ZDOTDIR:-$HOME}/.antidote/antidote.zsh

# ==== Lista de plugins declarativa (se crea si no existe)
ZPLUGINS="${ZDOTDIR:-$HOME}/.zsh_plugins.txt"
if [[ ! -f "$ZPLUGINS" ]]; then
  cat > "$ZPLUGINS" <<'EOF'
romkatv/powerlevel10k
zdharma-continuum/fast-syntax-highlighting
# En macOS usamos completion de Docker vía plugin:
docker/cli           kind:completion
# Plugin git de Oh My Zsh
ohmyzsh/ohmyzsh path:plugins/git
EOF
fi

# ==== Cargar plugins (elige UNA forma; esta usa carga directa)
antidote load
# Alternativa (cache explícito):
# antidote bundle < "$ZPLUGINS" > ~/.zsh_plugins.zsh
# source ~/.zsh_plugins.zsh

# ------------------------------------------------------------
# fzf keybindings/completions (macOS + Arch)
# ------------------------------------------------------------
# macOS (brew)
if command -v brew >/dev/null 2>&1; then
  FZF_PREFIX="$HOMEBREW_PREFIX/opt/fzf"
  [[ -r "$FZF_PREFIX/shell/key-bindings.zsh" ]] && source "$FZF_PREFIX/shell/key-bindings.zsh"
  [[ -r "$FZF_PREFIX/shell/completion.zsh"   ]] && source "$FZF_PREFIX/shell/completion.zsh"
fi
# Arch Linux
[[ -r /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh
[[ -r /usr/share/fzf/completion.zsh   ]] && source /usr/share/fzf/completion.zsh

# ------------------------------------------------------------
# Modo vi + asegurar que TAB completa
# ------------------------------------------------------------
bindkey -v
bindkey '^I' expand-or-complete

# Bracketed paste (pegado “seguro”)
autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic

# ==== Aliases/Functions (Stow los deja en $HOME)
[[ -r ~/.aliases.zsh   ]] && source ~/.aliases.zsh
[[ -r ~/.functions.zsh ]] && source ~/.functions.zsh

# ==== p10k config
[[ -r ~/.p10k.zsh ]] && source ~/.p10k.zsh

