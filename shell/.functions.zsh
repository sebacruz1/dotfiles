# Funciones personales de zsh

fedit() { local f; f=$(find . -type f 2>/dev/null | fzf) && ${EDITOR:-vim} "$f"; }
fcd()   { local d; d=$(find . -type d 2>/dev/null | fzf) && cd "$d"; }
fsel()  { local t; t=$(find . 2>/dev/null           | fzf) && echo "$t"; }

mkcd() {
  mkdir "$1" && cd "$1"
}

zshexit() {
    local nvim_pid=$(pgrep -P $$ nvim)

    if [[ -n "$nvim_pid" ]]; then
        kill -TERM "$nvim_pid"

    fi
}

# 2. Definimos el envoltorio para fcd
fcd-widget() {
  fcd               # Ejecuta el cambio de directorio
  zle reset-prompt  # Actualiza Starship para mostrar la nueva ruta
}

zle -N fcd-widget

bindkey '^Y' fcd-widget
