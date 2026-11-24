#!/bin/sh
# alacritty abre tmux con esto: se une a lo que haya, deja que resurrect restaure
# o crea 0default si no hay nada guardado
PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

if tmux has-session 2>/dev/null; then
  tmux attach
elif [ -e "$HOME/.local/share/tmux/resurrect/last" ]; then
  # sesión temporal: resurrect elimina la sesión "0" al restaurar desde cero
  tmux new-session -s 0
else
  tmux new-session -s 0default
fi

# al hacer detach (C-a d) la sesión sigue viva y queda una zsh normal en la
# ventana (p. ej. para ssh + tmux remoto); `tmux attach` para volver
exec /bin/zsh -l
