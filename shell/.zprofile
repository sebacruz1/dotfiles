# ====================================================================
#  .zprofile — login shell (zsh) | universal macOS + Linux, minimal
#  Sin aliases/funciones/plugins: eso va en .zshrc
# ====================================================================

# ----- Locale (UTF-8) ------------------------------------------------
# Respeta valores existentes; solo define por defecto si están vacíos.
: "${LANG:=en_US.UTF-8}"
export LANG
: "${LC_ALL:=en_US.UTF-8}"       # CUIDADO: LC_ALL domina sobre otros LC_*
export LC_ALL
# Si prefieres evitar LC_ALL global, comenta la línea anterior y usa:
# export LC_CTYPE="${LC_CTYPE:-en_US.UTF-8}"

# ----- XDG Base Directory spec ---------------------------------------
# No sobrescribe si el usuario ya los definió.
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

# ----- Homebrew (solo macOS) -----------------------------------------
# Carga brew si existe (Apple Silicon / Intel). Esto ajusta PATH, MANPATH, etc.
if [[ "$OSTYPE" == darwin* ]]; then
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

# ----- PATH básico del usuario ---------------------------------------
# Añade ~/.local/bin al frente si existe y aún no está en PATH.
if [[ -d "$HOME/.local/bin" ]]; then
  case ":$PATH:" in
    *":$HOME/.local/bin:"*) : ;;                               # ya está
    *) export PATH="$HOME/.local/bin:${PATH:-/usr/bin:/bin}" ;; # lo antepone
  esac
fi

# (Opcional) También es común incluir ~/bin si existe:
# if [[ -d "$HOME/bin" && ":$PATH:" != *":$HOME/bin:"* ]]; then
#   export PATH="$HOME/bin:$PATH"
# fi

# ----- Overrides por máquina (no versionado) -------------------------
# Hook final para ajustes locales (hosts distintos, secretos, etc.)
[[ -r "$HOME/.zprofile.local" ]] && source "$HOME/.zprofile.local"

