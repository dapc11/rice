user_home="/home/${USER}"

export TERM="xterm-256color"
export ZSH="${user_home}/.oh-my-zsh"

ZSH_THEME="robbyrussell"

# see 'man strftime' for details.
HIST_STAMPS="mm/dd/yyyy"

plugins=(
 git
)

source $ZSH/oh-my-zsh.sh

export PATH=${user_home}/.local/bin:$PATH
export PATH=${user_home}/bin:$PATH
export VISUAL=vim
export EDITOR="$VISUAL"
export FZF_DEFAULT_COMMAND="find -L"

# Aliases
alias sshk="ssh -o ServerAliveInterval=60"
alias ducks="du -cks * | sort -rn | head"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
unset user_home
