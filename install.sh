#!/bin/bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
ALACRITTY_SRC="$DOTFILES_DIR/alacritty/.config/alacritty"

PACKAGES=(alacritty git nvim shell starship tmux)

if ! command -v stow >/dev/null 2>&1; then
  echo "Error: stow no está instalado." >&2
  exit 1
fi

# platform.toml se crea dentro del paquete (está en .gitignore) con un link
# relativo, así stow lo enlaza junto al resto y funciona con o sin folding.
echo "==> Configurando alacritty platform.toml..."
case "$(uname)" in
  Darwin) PLATFORM=macos ;;
  Linux) PLATFORM=linux ;;
  *) PLATFORM="" ;;
esac
if [[ -n "$PLATFORM" ]]; then
  ln -sfn "$PLATFORM.toml" "$ALACRITTY_SRC/platform.toml"
  echo "    alacritty: platform.toml -> $PLATFORM.toml"
fi

echo "==> Aplicando stow..."
for pkg in "${PACKAGES[@]}"; do
  stow -R -d "$DOTFILES_DIR" -t "$HOME" "$pkg"
  echo "    stow: $pkg"
done

echo "==> Listo."
