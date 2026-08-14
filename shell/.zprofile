: "${LANG:=en_US.UTF-8}"
export LANG
: "${LC_ALL:=en_US.UTF-8}"
export LC_ALL

# ----- XDG Base Directory spec ---------------------------------------
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

# ----- Homebrew (solo macOS) -----------------------------------------
if [[ "$OSTYPE" == darwin* ]]; then
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

# ----- PATH básico del usuario ---------------------------------------
if [[ -d "$HOME/.local/bin" ]]; then
  case ":$PATH:" in
    *":$HOME/.local/bin:"*) : ;;
    *) export PATH="$HOME/.local/bin:${PATH:-/usr/bin:/bin}" ;;
  esac
fi

[[ -r "$HOME/.zprofile.local" ]] && source "$HOME/.zprofile.local"


# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

