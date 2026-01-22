# Aliases

alias ..='cd ..'; alias ...='cd ../..'; alias ....='cd ../../..'
alias ll='eza -l --git --icons';
alias ls='eza -la --git --icons'
unalias cs 2>/dev/null
cs() {
  cd "$1" && ls
}
alias python='python3'; alias pip='pip3'
alias vim='nvim'

