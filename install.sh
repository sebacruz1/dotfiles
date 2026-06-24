#!/bin/bash
set -e

KITTY_DIR="$HOME/.config/kitty"

if [[ "$(uname)" == "Darwin" ]]; then
  ln -sf "$KITTY_DIR/macos.conf" "$KITTY_DIR/platform.conf"
  echo "kitty: platform.conf -> macos.conf"
elif [[ "$(uname)" == "Linux" ]]; then
  ln -sf "$KITTY_DIR/linux.conf" "$KITTY_DIR/platform.conf"
  echo "kitty: platform.conf -> linux.conf"
fi
