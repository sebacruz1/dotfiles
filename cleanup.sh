#!/usr/bin/env bash
set -euo pipefail

BACKUP_DIR="$HOME/.dotfiles_backup"
rm -rf $HOME/.dotfiles_backup
mkdir -p "$BACKUP_DIR"

FILES_TO_MOVE=(
  ".zshrc"
  ".zprofile"
  ".vimrc"
  ".vim"
  ".tmux.conf"
  ".gitconfig"
  ".gitignore_global"
  ".viminfo"
  ".vim_mru_files"
)

echo "[INFO] Moviendo dotfiles conflictivos a $BACKUP_DIR ..."


for f in "${FILES_TO_MOVE[@]}"; do
  if [[ -e "$HOME/$f" && ! -L "$HOME/$f" ]]; then
    echo "  -> $f"
    mv "$HOME/$f" "$BACKUP_DIR/"
  fi
done

# Archivos temporales de Zsh (pueden ser varios con sufijos distintos)
for f in "$HOME"/.zcompdump* "$HOME"/.zsh_sessions; do
  if [[ -e "$f" ]]; then
    echo "  -> $(basename "$f")"
    mv "$f" "$BACKUP_DIR/"
  fi
done

echo "[OK] Limpieza completada. Ahora puedes correr ./install.sh sin conflictos."

