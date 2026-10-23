#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
ALACRITTY_DIR="$HOME/.config/alacritty"

PACKAGES=(alacritty git nvim shell starship tmux)

echo "==> Aplicando stow..."
for pkg in "${PACKAGES[@]}"; do
  stow -R -d "$DOTFILES_DIR" -t "$HOME" "$pkg"
  echo "    stow: $pkg"
done

echo "==> Configurando alacritty platform.toml..."
if [[ "$(uname)" == "Darwin" ]]; then
  ln -sf "$ALACRITTY_DIR/macos.toml" "$ALACRITTY_DIR/platform.toml"
  echo "    alacritty: platform.toml -> macos.toml"
elif [[ "$(uname)" == "Linux" ]]; then
  ln -sf "$ALACRITTY_DIR/linux.toml" "$ALACRITTY_DIR/platform.toml"
  echo "    alacritty: platform.toml -> linux.toml"
fi

echo "==> Listo."
