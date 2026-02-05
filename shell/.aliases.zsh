# Aliases

alias ..='cd ..'; alias ...='cd ../..'; alias ....='cd ../../..'
alias ll='eza -l --git --icons';
alias ls='eza -la --git --icons'
unalias cs 2>/dev/null
alias python='python3'; alias pip='pip3'
alias vim='nvim'
alias vi='nvim'

# ==== Laravel / PHP
alias pa="php artisan"
alias artisan='docker compose exec app php artisan'
alias mfs="php artisan migrate:fresh --seed"
alias log="tail -f storage/logs/laravel.log"
alias cpy="composer install && npm install"

alias gcm="git commit -m"
alias gaa="git add ."

alias ff='fd --max-depth 1 --type f --hidden --exclude .git'
alias fv='fd --type f --hidden --exclude .git | fzf | xargs -r nvim'
