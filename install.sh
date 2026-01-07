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

# Backup que además despeja el path para que stow no choque:
# mueve ~/<ruta> a ~/.dotfiles_backup/<ruta>.YYYYmmddHHMMSS
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

# Runtime dirs para Neovim (XDG)
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

  if ! need_cmd brew; then
    log "Instalando Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    ok "Homebrew instalado."

    # cargar brew en Apple Silicon (y no rompe en Intel)
    if [[ -x /opt/homebrew/bin/brew ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x /usr/local/bin/brew ]]; then
      eval "$(/usr/local/bin/brew shellenv)"
    fi
  fi

  if [[ -f "$REPO_DIR/Brewfile.mac" ]]; then
    log "Instalando fórmulas desde Brewfile.mac..."
    brew bundle --file="$REPO_DIR/Brewfile.mac"
    ok "brew bundle completo."
  else
    warn "No se encontró Brewfile.mac. Saltando."
  fi

  # Asegurar Neovim (por si no está en Brewfile)
  if ! need_cmd nvim; then
    log "Instalando Neovim..."
    brew install neovim
    ok "Neovim instalado."
  fi

  if brew list fzf >/dev/null 2>&1; then
    log "Configurando fzf keybindings/completion..."
    "$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-update-rc || true
    ok "fzf configurado."
  fi
}

### ===============================
### stow y symlinks
### ===============================
apply_stow() {
  if ! need_cmd stow; then
    log "Instalando stow..."
    brew install stow
    ok "stow instalado."
  fi

  # Backups (mueve lo existente para que stow no falle)
  backup ".zshrc"; backup ".zprofile"
  backup ".aliases.zsh"; backup ".functions.zsh"
  backup ".tmux.conf"
  backup ".gitconfig"; backup ".gitignore_global"

  # Neovim (lo importante)
  backup ".config/nvim"
  backup ".local/state/nvim"
  backup ".local/share/nvim"

  # Vim legacy (por si existía de antes)
  backup ".vimrc"; backup ".vim"

  pushd "$REPO_DIR" >/dev/null

  # Aplica stow para los paquetes presentes
  for pkg in shell nvim tmux git; do
    if [[ -d "$pkg" ]]; then
      log "stow $pkg -> \$HOME"
      stow -v -R -t "$HOME" "$pkg"
    fi
  done

  popd >/dev/null
  ok "Symlinks aplicados con Stow."
}

### ===============================
### git global config
### ===============================
setup_git() {
  if [[ -L "$HOME/.gitignore_global" || -f "$HOME/.gitignore_global" ]]; then
    log "Configurando Git para usar ~/.gitignore_global..."
    git config --global core.excludesfile "$HOME/.gitignore_global"
    ok "Git configurado con excludesfile."
  else
    warn "No se encontró ~/.gitignore_global después de stow."
  fi
}

### ===============================
### extras (TPM, mensajes)
### ===============================
ensure_tpm() {
  if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
    log "Instalando tmux plugin manager (TPM)..."
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    ok "TPM instalado. Dentro de tmux, ejecuta: prefix + I"
  fi
}

final_tips() {
  echo
  ok "Instalación base completada."
  echo -e "${BLUE}Siguientes pasos recomendados:${NC}"
  echo "  - Abre una nueva shell para que se apliquen los cambios."
  echo "  - En tmux: presiona 'prefix + I' para instalar plugins (TPM)."
  echo "  - En Neovim: corre ':Lazy sync' para sincronizar los plugins."
}

main() {
  install_macos
  apply_stow
  setup_git
  setup_runtime
  ensure_tpm
  final_tips
}

main "$@"
