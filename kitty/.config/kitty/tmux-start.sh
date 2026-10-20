#!/bin/sh
# kitty abre tmux con esto: se une a lo que haya, deja que resurrect restaure
# o crea 0default si no hay nada guardado
PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

if tmux has-session 2>/dev/null; then
  exec tmux attach
elif [ -e "$HOME/.local/share/tmux/resurrect/last" ]; then
  # sesión temporal: resurrect elimina la sesión "0" al restaurar desde cero
  exec tmux new-session -s 0
else
  exec tmux new-session -s 0default
fi
