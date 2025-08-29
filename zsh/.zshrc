if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

HISTFILE="$HOME/.zsh_history"
HISTSIZE=200000
SAVEHIST=200000
setopt sharehistory histignoredups histignorespace extendedglob 


if [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
  precmd() { print -Pn "\e]7;file://$HOST${PWD// /%20}\a" }
fi

plugins=(
  git
  fast-syntax-highlighting
  docker
  kubectl
  macos          
)
source "$ZSH/oh-my-zsh.sh"

export EDITOR=vim
export LANG=en_US.UTF-8

bindkey -v

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias ll='eza -l --git --icons'
alias la='eza -la --git --icons'

alias python='python3'
alias pip='pip3'

alias please='sudo $(fc -ln -1)'       

# alias backupmanual='bash "$HOME/Documents/BackupAutomatico/backup.sh"'

alias jukebox='ssh jukebox mpv --hwdec=vaapi'

alias ic='cd ~/Library/Mobile\ Documents/com\~apple\~CloudDocs'

if [[ -r /opt/homebrew/opt/fzf/shell/key-bindings.zsh ]]; then
  source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
fi
if [[ -r /opt/homebrew/opt/fzf/shell/completion.zsh ]]; then
  source /opt/homebrew/opt/fzf/shell/completion.zsh
fi

fedit() {
  local file
  file=$(find . -type f 2>/dev/null | fzf) && ${EDITOR:-vim} "$file"
}

fcd() {
  local dir
  dir=$(find . -type d 2>/dev/null | fzf) && cd "$dir"
}

fsel() {
  local target
  target=$(find . 2>/dev/null | fzf) && echo "$target"
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
