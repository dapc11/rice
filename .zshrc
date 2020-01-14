export ZSH="/home/${USER}/.oh-my-zsh"
export UPDATE_ZSH_DAYS=13

ZSH_THEME="robbyrussell"
HIST_STAMPS="mm/dd/yyyy"

plugins=(
    git
)

source $ZSH/oh-my-zsh.sh

# Aliases
alias ll="ls -l"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
