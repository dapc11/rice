plugins=(
    git
    zsh-autosuggestions
    virtualenv
)

# Enable autocompletion
autoload -Uz compinit; compinit

export ZSH="$HOME/.oh-my-zsh"
[[ ! -f $ZSH/oh-my-zsh.sh ]] || source $ZSH/oh-my-zsh.sh

if type rg &> /dev/null; then
    # --files: List files that would be searched but do not search
    # --no-ignore: Do not respect .gitignore, etc...
    # --hidden: Search hidden files and folders
    # --follow: Follow symlinks
    # --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
    export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'
    export FZF_DEFAULT_OPTS='-m --height 50% --border --layout=reverse'
fi

setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
set -g hist_ignore_dups
# Enable Home & End in rxvt-unicode-256color
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

# Aliases
alias vim="nvim"
alias ssh='TERM=xterm-color ssh'
alias sshk="ssh -o ServerAliveInterval=60"
alias ducks="du -cks * | sort -rn | head | column -t"
alias gsf="git status --porcelain | cut -d' ' -f3 | xargs"

function pb-kill-line () {
  zle kill-line
  echo -n $CUTBUFFER | xclip -selection clipboard
}
zle -N pb-kill-line
bindkey '^K' pb-kill-line

if type kubectl &> /dev/null; then
  source <(kubectl completion zsh)
fi
if type helm &> /dev/null; then
  source <(helm completion zsh)
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
[[ ! -f ~/powerlevel10k/powerlevel10k.zsh-theme ]] || source ~/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/dev/bin/activate ]] || source ~/dev/bin/activate
[[ ! -f ~/.fzf.zsh ]] || source ~/.fzf.zsh
ZLE_RPROMPT_INDENT=0
