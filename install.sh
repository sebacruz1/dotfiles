#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
KITTY_DIR="$HOME/.config/kitty"

PACKAGES=(git kitty nvim shell starship tmux)

echo "==> Aplicando stow..."
for pkg in "${PACKAGES[@]}"; do
  stow -d "$DOTFILES_DIR" -t "$HOME" "$pkg"
  echo "    stow: $pkg"
done

echo "==> Configurando kitty platform.conf..."
if [[ "$(uname)" == "Darwin" ]]; then
  ln -sf "$KITTY_DIR/macos.conf" "$KITTY_DIR/platform.conf"
  echo "    kitty: platform.conf -> macos.conf"
elif [[ "$(uname)" == "Linux" ]]; then
  ln -sf "$KITTY_DIR/linux.conf" "$KITTY_DIR/platform.conf"
  echo "    kitty: platform.conf -> linux.conf"
fi

echo "==> Listo."
