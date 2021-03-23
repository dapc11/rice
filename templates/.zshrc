plugins=(
    git
    zsh-autosuggestions
    virtualenv
)

# Enable autocompletion
autoload -Uz compinit
compinit

export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if type rg &> /dev/null; then
    # --files: List files that would be searched but do not search
    # --no-ignore: Do not respect .gitignore, etc...
    # --hidden: Search hidden files and folders
    # --follow: Follow symlinks
    # --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
    export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'
fi

function git_prompt_info() {
  local ref
  if [[ "$(command git config --get oh-my-zsh.hide-status 2>/dev/null)" != "1" ]]; then
    ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return 0
    echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
  fi
}

ZSH_THEME="{{zsh_theme}}"
ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[blue]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"
PROMPT=' %{${fg[green]}%}%3~%{$reset_color%}$(git_prompt_info)%{$reset_color%}%(?..%{$fg[red]%})› %{$reset_color%}'
RPROMPT='${return_code} '

setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
set -g hist_ignore_dups
# Enable Home & End in rxvt-unicode-256color
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

# Aliases
alias vim="nvim -u ~/.vimrc"
alias ssh='TERM=xterm-color ssh'
alias sshk="ssh -o ServerAliveInterval=60"
alias ducks="du -cks * | sort -rn | head | column -t"

function pb-kill-line () {
  zle kill-line
  echo -n $CUTBUFFER | xclip -selection clipboard
}

zle -N pb-kill-line

bindkey '^K' pb-kill-line
