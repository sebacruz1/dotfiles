# Funciones personales de zsh

fedit() { local f; f=$(find . -type f 2>/dev/null | fzf) && ${EDITOR:-vim} "$f"; }
fcd()   { local d; d=$(find . -type d 2>/dev/null | fzf) && cd "$d"; }
fsel()  { local t; t=$(find . 2>/dev/null           | fzf) && echo "$t"; }

