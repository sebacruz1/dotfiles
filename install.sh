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
  local p="$1"
  if [[ -e "$HOME/$p" && ! -L "$HOME/$p" ]]; then
    mkdir -p "$HOME/.dotfiles_backup"
    cp -a "$HOME/$p" "$HOME/.dotfiles_backup/"
    log "Backup de ~/$p -> ~/.dotfiles_backup/"
  fi
}
setup_runtime() {
  mkdir -p "$HOME/.vim"/{swap,undo,backup}
  chmod 700 "$HOME/.vim"/{swap,undo,backup} 2>/dev/null || true
}

### ===============================
### paquetes por SO
### ===============================
install_macos() {
  log "Detectado macOS."
  if ! need_cmd brew; then
    log "Instalando Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    ok "Homebrew instalado."
    if [[ -x /opt/homebrew/bin/brew ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
  fi

  if [[ -f "$REPO_DIR/Brewfile.mac" ]]; then
    log "Instalando fórmulas desde Brewfile.mac..."
    brew bundle --file="$REPO_DIR/Brewfile.mac"
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

install_arch() {
  log "Detectado Arch Linux."
  need_cmd pacman || { error "pacman no disponible. Abortando."; exit 1; }

  log "Actualizando índices y sistema..."
  sudo pacman -Syu --noconfirm || true

  if [[ -f "$REPO_DIR/packages.arch" ]]; then
    log "Instalando paquetes oficiales (pacman)..."
    sudo pacman -S --needed --noconfirm - < "$REPO_DIR/packages.arch" || {
      warn "Algún paquete de pacman falló. Revisa 'packages.arch'."
    }
    ok "Paquetes oficiales instalados."
  else
    warn "No se encontró packages.arch. Saltando pacman."
  fi

  if [[ -f "$REPO_DIR/aur-packages.arch" ]]; then
    if need_cmd yay; then
      log "Instalando paquetes AUR (yay)..."
      yay -S --needed --noconfirm - < "$REPO_DIR/aur-packages.arch" || {
        warn "Algún paquete AUR falló. Revisa 'aur-packages.arch'."
      }
      ok "Paquetes AUR instalados."
    else
      warn "No se encontró 'yay'. Para instalarlo:\n  git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si\nLuego vuelve a correr ./install.sh"
    fi
  else
    log "No hay aur-packages.arch. Saltando AUR."
  fi
}

install_other_linux() {
  warn "Distro Linux no-Arch detectada. Este script no instala paquetes automáticamente aquí."
  warn "Puedes adaptar uno para apt/dnf/pacman según tu sistema."
}

### ===============================
### stow y symlinks
### ===============================
apply_stow() {
  if ! need_cmd stow; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
      brew install stow
    elif [[ -f /etc/arch-release ]]; then
      sudo pacman -S --needed --noconfirm stow
    fi
  fi

  # Backups defensivos
  backup ".zshrc"; backup ".zprofile"
  backup ".zsh_aliases"; backup ".zshfunctions";
  backup ".vimrc"; backup ".vim"
  backup ".tmux.conf"
  backup ".gitconfig"; backup ".gitignore_global"

  # Aplicar stow por paquetes presentes
  pushd "$REPO_DIR" >/dev/null
  for pkg in shell vim tmux git; do
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
  if [[ "$OSTYPE" == "darwin"* ]]; then
    install_macos
  elif [[ -f /etc/arch-release ]]; then
    install_arch
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    install_other_linux
  else
    warn "SO no reconocido: $OSTYPE"
  fi

  apply_stow
  setup_git
  setup_runtime
  ensure_tpm
  final_tips
}

main "$@"

