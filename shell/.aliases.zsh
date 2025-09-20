# Aliases

alias ..='cd ..'; alias ...='cd ../..'; alias ....='cd ../../..'
alias ll='eza -l --git --icons';
alias ls='eza -la --git --icons'
cs() {
  cd "$1" && ls
}
alias python='python3'; alias pip='pip3'
alias please='sudo $(fc -ln -1)'

