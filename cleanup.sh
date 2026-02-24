#!/usr/bin/env bash
set -euo pipefail

BACKUP_DIR="$HOME/.dotfiles_backup"
TS="$(date +%Y%m%d%H%M%S)"
DEST_DIR="$BACKUP_DIR/$TS"
mkdir -p "$DEST_DIR"

FILES_TO_MOVE=(
  ".zshrc"
  ".zprofile"
  ".aliases.zsh"
  ".functions.zsh"
  ".tmux.conf"
  ".gitconfig"
  ".gitignore_global"
  ".wezterm.lua"
  ".config/starship.toml"
  ".config/nvim"
  ".local/state/nvim"
  ".local/share/nvim"
  ".vimrc"
  ".vim"
  ".viminfo"
  ".vim_mru_files"
)

echo "[INFO] Moviendo dotfiles conflictivos a $DEST_DIR ..."

for f in "${FILES_TO_MOVE[@]}"; do
  if [[ -e "$HOME/$f" && ! -L "$HOME/$f" ]]; then
    echo "  -> $f"
    mkdir -p "$DEST_DIR/$(dirname "$f")"
    mv "$HOME/$f" "$DEST_DIR/$f"
  fi
done

for f in "$HOME"/.zcompdump* "$HOME"/.zsh_sessions; do
  if [[ -e "$f" && ! -L "$f" ]]; then
    echo "  -> $(basename "$f")"
    mv "$f" "$DEST_DIR/"
  fi
done

echo "[OK] Limpieza completada. Backups creados en $DEST_DIR"

