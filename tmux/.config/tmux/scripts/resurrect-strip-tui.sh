#!/usr/bin/env bash
# Hook post-save-all de tmux-resurrect.
# Borra del archivo de contenidos los panes que estaban corriendo un programa
# (nvim, claude, servidores...). Su contenido es una pantalla TUI que al
# restaurar se imprime con `cat` y queda cortada/rota; además resurrect vuelve
# a lanzar el programa encima. Los panes con solo shell conservan su historial.
set -euo pipefail

dir="${1:-$HOME/.local/share/tmux/resurrect}"
last="$dir/last"
archive="$dir/pane_contents.tar.gz"
[ -f "$last" ] && [ -f "$archive" ] || exit 0

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

tar xzf "$archive" -C "$tmp"

# Campos de la línea "pane" (separados por tab):
# 2=session 3=window 6=pane_index ... 11=full_command (":" si solo hay shell)
awk -F'\t' '$1 == "pane" && $11 != ":" { print "pane-" $2 ":" $3 "." $6 }' "$last" |
	while IFS= read -r f; do
		rm -f "$tmp/pane_contents/$f"
	done

tar cf - -C "$tmp" ./pane_contents/ | gzip >"$archive.tmp"
mv "$archive.tmp" "$archive"
