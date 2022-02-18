# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

plugins=(
    git
    zsh-autosuggestions
    virtualenv
)

# Enable autocompletion
autoload -Uz compinit; compinit
export ZSH="$HOME/.oh-my-zsh"
export ZSH_THEME="powerlevel10k/powerlevel10k"
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

_gen_fzf_default_opts() {

local color00='{{base00}}'
local color01='{{base01}}'
local color02='{{base02}}'
local color03='{{base03}}'
local color04='{{base04}}'
local color05='{{base05}}'
local color06='{{base06}}'
local color07='{{base07}}'
local color08='{{base08}}'
local color09='{{base09}}'
local color0A='{{base0A}}'
local color0B='{{base0B}}'
local color0C='{{base0C}}'
local color0D='{{base0D}}'
local color0E='{{base0E}}'
local color0F='{{base0F}}'

export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS"\
" --color=bg+:$color01,bg:$color00,spinner:$color0C,hl:$color0D"\
" --color=fg:$color04,header:$color0D,info:$color0A,pointer:$color0C"\
" --color=marker:$color0C,fg+:$color06,prompt:$color0A,hl+:$color0D"
}
# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

_gen_fzf_default_opts

setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
set -g hist_ignore_dups
# Enable Home & End in rxvt-unicode-256color
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

# Aliases
alias k="kubectl"
compdef __start_kubectl k
alias vim="nvim"
alias ssh='TERM=xterm-color ssh'
alias sshk="ssh -o ServerAliveInterval=60"
alias ducks="du -cks * | sort -rn | head | column -t"
alias gsf="git status --porcelain | cut -d' ' -f3 | xargs"

# interactive cd
unalias g 2> /dev/null
g() {
  if [ $# -eq 0 ] ; then
    path_to_cd=$(fd --type d --hidden --follow --exclude .git 2>/dev/null | fzf )
    [[ -z "$path_to_cd" ]] && return || cd "$path_to_cd"
  else
    cd $@
  fi
}

# interactive edit
unalias e 2> /dev/null
e() {
  if [ $# -eq 0 ] ; then
    path_to_cd=$(fd --type f --hidden --follow --exclude .git 2>/dev/null | fzf )
    [[ -z "$path_to_cd" ]] && return || n "$path_to_cd"
  else
    cd $@
  fi
}


# alias git-clean="git checkout -- $(gsf)"

function pb-kill-line () {
  zle kill-line
  echo -n $CUTBUFFER | xclip -selection clipboard
}
zle -N pb-kill-line
bindkey '^K' pb-kill-line

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
[[ ! -f ~/powerlevel10k/powerlevel10k.zsh-theme ]] || source ~/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/dev/bin/activate ]] || source ~/dev/bin/activate
[[ ! -f ~/.fzf.zsh ]] || source ~/.fzf.zsh
eval "$(zoxide init zsh)"
ZLE_RPROMPT_INDENT=0
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/zsh_completion" ] && \. "$NVM_DIR/zsh_completion"  # This loads nvm bash_completion

if type kubectl &> /dev/null; then
  source <(kubectl completion zsh)
fi
if type helm &> /dev/null; then
  source <(helm completion zsh)
fi
