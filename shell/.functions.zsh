# Funciones personales de zsh

fedit() { local f; f=$(find . -type f 2>/dev/null | fzf) && ${EDITOR:-vim} "$f"; }
fcd()   { local d; d=$(find . -type d 2>/dev/null | fzf) && cd "$d"; }
fsel()  { local t; t=$(find . 2>/dev/null           | fzf) && echo "$t"; }

mkcd() {
  mkdir "$1" && cd "$1"
}


if [ -n "$TMUX" ]; then
    mkdir -p ~/.zsh_history_tmux
    TMUX_ID=$(tmux display-message -p '#S_#W_#P')
    HISTFILE="$HOME/.zsh_history_tmux/history_$TMUX_ID"
fi
