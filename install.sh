#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BLUE='\033[1;34m'; GREEN='\033[1;32m'; YELLOW='\033[1;33m'; RED='\033[1;31m'; NC='\033[0m'

log()   { echo -e "${BLUE}[INFO]${NC} $*"; }
ok()    { echo -e "${GREEN}[OK]  ${NC} $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; }
error() { echo -e "${RED}[ERR] ${NC} $*"; }

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || { warn "Falta '$1'"; return 1; }
}

backup() {
  local rel="$1"
  local src="$HOME/$rel"

  if [[ -e "$src" && ! -L "$src" ]]; then
    local ts dest
    ts="$(date +%Y%m%d%H%M%S)"
    dest="$HOME/.dotfiles_backup/$rel.$ts"

    mkdir -p "$HOME/.dotfiles_backup"
    mkdir -p "$(dirname "$dest")"

    mv "$src" "$dest"
    log "Movido backup: ~/$rel -> $dest"
  fi
}

setup_runtime() {
  local base="${XDG_STATE_HOME:-$HOME/.local/state}/nvim"
  mkdir -p "$base"/{swap,undo,backup}
  chmod 700 "$base"/{swap,undo,backup} 2>/dev/null || true
  ok "Runtime Neovim: $base/{swap,undo,backup}"
}

install_macos() {
  if [[ "$OSTYPE" != "darwin"* ]]; then
    error "Este script es solo para macOS. OSTYPE=$OSTYPE"
    exit 1
  fi

  log "Detectado macOS."

  # Asegurar que sea Apple Silicon (arm64)
  if [[ "$(uname -m)" != "arm64" ]]; then
    error "Este instalador solo soporta macOS Apple Silicon (arm64)."
    exit 1
  fi

  if ! need_cmd brew; then
    log "Instalando Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    ok "Homebrew instalado."

    if [[ -x /opt/homebrew/bin/brew ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x /usr/local/bin/brew ]]; then
      eval "$(/usr/local/bin/brew shellenv)"
    fi
  fi

  if [[ -f "$REPO_DIR/Brewfile.mac" ]]; then
    log "Instalando fórmulas desde Brewfile.mac..."
    brew bundle --file="$REPO_DIR/Brewfile.mac" --no-upgrade
    ok "brew bundle completo."
  else
    warn "No se encontró Brewfile.mac. Saltando."
  fi

  if brew list fzf >/dev/null 2>&1; then
    log "Configurando fzf keybindings/completion..."
    "$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-update-rc || true
    ok "fzf configurado."
  fi
}

apply_stow() {

  backup ".zshrc"; backup ".zprofile"
  backup ".aliases.zsh"; backup ".functions.zsh"
  backup ".tmux.conf"
  backup ".gitconfig"; backup ".gitignore_global"

  backup ".config/starship.toml"
  backup ".config/kitty"

  backup ".config/nvim"
  backup ".local/state/nvim"
  backup ".local/share/nvim"

  backup ".vimrc"; backup ".vim"

  pushd "$REPO_DIR" >/dev/null

  for pkg in shell nvim tmux git starship kitty; do
    if [[ -d "$pkg" ]]; then
      log "stow $pkg -> \$HOME"
      stow -v -R -t "$HOME" "$pkg"
    fi
  done

  popd >/dev/null
  ok "Symlinks aplicados con Stow."
}
setup_git() {
  if [[ -L "$HOME/.gitignore_global" || -f "$HOME/.gitignore_global" ]]; then
    log "Configurando Git para usar ~/.gitignore_global..."
    git config --global core.excludesfile '~/.gitignore_global'
    ok "Git configurado con excludesfile."
  else
    warn "No se encontró ~/.gitignore_global después de stow."
  fi

  if [[ ! -f "$HOME/.gitconfig.local" ]]; then
    cat > "$HOME/.gitconfig.local" <<'EOF'
[user]
    name = Tu Nombre
    email = tu-email@example.com
EOF
    chmod 600 "$HOME/.gitconfig.local" 2>/dev/null || true
    warn "Creado ~/.gitconfig.local con placeholders. Edita ese archivo con tus credenciales."
  fi
}

ensure_antidote() {
  local plugins_file="$HOME/.zsh_plugins.txt"
  if [[ ! -f "$plugins_file" ]]; then
    warn "No se encontró ~/.zsh_plugins.txt."
  fi
}

ensure_tpm() {
  if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
    log "Instalando tmux plugin manager (TPM)..."
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    ok "TPM instalado."
  fi

  log "Instalando plugins de tmux..."
  "$HOME/.tmux/plugins/tpm/bin/install_plugins" || true
  ok "Plugins de tmux instalados."
}

final_tips() {
  echo
  echo -e "${BLUE}Instalación completada${NC}"
}

main() {
  install_macos
  apply_stow
  setup_git
  setup_runtime
  ensure_antidote
  ensure_tpm
  final_tips
}

main "$@"
