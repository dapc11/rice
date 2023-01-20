# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# Enable autocompletionsource ~/powerlevel10k/powerlevel10k.zsh-theme
autoload -Uz compinit; compinit
export ZSH="$HOME/.oh-my-zsh"
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
[[ ! -f ~/powerlevel10k/powerlevel10k.zsh-theme ]] || source ~/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f $ZSH/oh-my-zsh.sh ]] || source $ZSH/oh-my-zsh.sh
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
ZLE_RPROMPT_INDENT=0
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

plugins=(
    git
    zsh-autosuggestions
    helm
    kubectl
    fd
)


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

set -g hist_ignore_dups
# Enable Home & End in rxvt-unicode-256color
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

# Aliases
alias n="nvim"
alias vim="nvim"
alias wezterm='flatpak run org.wezfurlong.wezterm'
alias ssh='TERM=xterm-color ssh'
alias sshk="ssh -o ServerAliveInterval=60"
alias ducks="du -cks * | sort -rn | head | column -t"
alias gsf="git status --porcelain | cut -d' ' -f3 | xargs"
alias watch="watch "
alias git-clean="git checkout -- \$(gsf)"

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
        [[ -z "$path_to_cd" ]] && return || vim "$path_to_cd"
    else
        cd $@
    fi
}

pb-kill-line() {
  zle kill-line
  echo -n $CUTBUFFER | xclip -selection clipboard
}

zle -N pb-kill-line
bindkey '^K' pb-kill-line

eval "$(zoxide init zsh)"
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/zsh_completion" ] && \. "$NVM_DIR/zsh_completion"  # This loads nvm bash_completion
[[ ! -f ~/.fzf.zsh ]] || source ~/.fzf.zsh

#compdef k8s_tool
_k8s_tool_completion() {
  eval $(env _TYPER_COMPLETE_ARGS="${words[1,$CURRENT]}" _K8S_TOOL_COMPLETE=complete_zsh k8s_tool)
}
compdef _k8s_tool_completion k8s_tool

#compdef it_tool
_it_tool_completion() {
  eval $(env _TYPER_COMPLETE_ARGS="${words[1,$CURRENT]}" _IT_TOOL_COMPLETE=complete_zsh it_tool)
}
compdef _it_tool_completion it_tool

#compdef 3pp_tool
_3pp_tool_completion() {
  eval $(env _TYPER_COMPLETE_ARGS="${words[1,$CURRENT]}" _3PP_TOOL_COMPLETE=complete_zsh 3pp_tool)
}
compdef _3pp_tool_completion 3pp_tool
compdef __start_kubectl k

export FZF_COMPLETION_TRIGGER=''
bindkey '^T' fzf-completion
bindkey '^I' $fzf_default_completion
export HISTORY_IGNORE="(ls|cd|pwd|exit|vim|sudo reboot|history|cd -|cd ..)"

### ARCHIVE EXTRACTION
# usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *.deb)       ar x $1      ;;
      *.tar.xz)    tar xf $1    ;;
      *.tar.zst)   unzstd $1    ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

setopt prompt_subst
setopt auto_menu
setopt always_to_end
setopt complete_in_word
unsetopt flow_control
unsetopt menu_complete

zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path $ZSH_CACHE_DIR
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats       '%B%u %c %B%F{magenta} %b'
zstyle ':vcs_info:git:*' actionformats '%B%u %c %B%F{magenta} %b'
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' get-revision true
zstyle ':vcs_info:git:*' stagedstr '%F{green}✓'
zstyle ':vcs_info:git:*' unstagedstr '%F{red}±'
function p() {
  # The directory where we expect the projects to be in.
  proj_dir=${PROJ_DIR:-~/dev}

  project=$(/bin/ls $proj_dir | fzf --prompt "Switch to project: ")
  [ -n "$project" ] && cd $proj_dir/$project
}

# Easily switch between tmux session.
function sw() {
  session=$(tmux ls -F "#S" | fzf --prompt "Switch to tmux session: ")

  [ -n "$session" ] && tmux switch-client -t $session
}
fpath+=~/.zfunc
