user_home="/home/${USER}"

export TERM="xterm-256color"
export ZSH="${user_home}/.oh-my-zsh"

ZSH_THEME="robbyrussell"

# see 'man strftime' for details.
HIST_STAMPS="mm/dd/yyyy"

# Add wisely, as too many plugins slow down shell startup.
plugins=(
 git
 wd
)

source $ZSH/oh-my-zsh.sh

# User configuration

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
conda="${user_home}/anaconda3/bin/conda"
__conda_setup="$(${conda} 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "${user_home}/anaconda3/etc/profile.d/conda.sh" ]; then
        . "${user_home}/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="${user_home}/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
unset conda
# <<< conda initialize <<<

export PATH=${user_home}/software/jdk1.8.0_221/bin:$PATH
export PATH=${user_home}/.local/share/JetBrains/Toolbox/bin:$PATH
export PATH=${user_home}/bin:$PATH
export JAVA_HOME=${user_home}/software/jdk1.8.0_221
export M2_HOME=${user_home}/software/apache-maven-3.6.1
export M2=$M2_HOME/bin
export MAVEN_OPTS="-Xms256m -Xmx512m"
export PATH=$M2:$PATH
export VISUAL=vim
export EDITOR="$VISUAL"

# Aliases
alias sshk="ssh -o ServerAliveInterval=60"
alias ducks="du -cks * | sort -rn | head"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# Enable Home & End in tmux xterm-256color
bindkey "\E[1~" beginning-of-line
bindkey "\E[4~" end-of-line

if [ /usr/local/bin/kubectl ]; then source <(kubectl completion zsh); fi
if [ /usr/local/bin/helm ]; then source <(helm completion zsh); fi
set -g hist_ignore_dups
setopt HIST_FIND_NO_DUPS
