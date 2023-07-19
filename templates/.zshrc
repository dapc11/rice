# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# Enable autocompletionsource ~/powerlevel10k/powerlevel10k.zsh-theme
autoload -Uz compinit; compinit
export ZSH="${HOME}/.oh-my-zsh"
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
[[ ! -f ~/powerlevel10k/powerlevel10k.zsh-theme ]] || source ~/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f $ZSH/oh-my-zsh.sh ]] || source $ZSH/oh-my-zsh.sh
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
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

ZLE_RPROMPT_INDENT=0
if [[ -r "${XDG_CACHE_HOME:-${HOME}/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-${HOME}/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export PATH="${PATH}:${HOME}/bin:$(du "${HOME}/.local/bin/" | cut -f2 | grep -v pycache | tr '\n' ':' | sed 's/:*$//')"
export PATH=${PATH}:/usr/local/go/bin:"${HOME}/.config/git/scripts"
export PATH=${PATH}:$GOROOT/bin:$GOPATH/bin

# Default programs:
export NVM_DIR="${HOME}/.nvm"
export GOPATH="${HOME}/go"
export EDITOR="{{editor}}"
export GIT_EDITOR="${EDITOR}"
export KUBE_EDITOR="${EDITOR}"
export TERMINAL="{{terminal}}"
export BROWSER="{{browser}}"
export SHELL="{{shell}}"
export TERM="xterm-256color"

# Other program settings:
export PYTHONDONTWRITEBYTECODE=1
export LESSHISTFILE="-"
export TMUX_TMPDIR="$XDG_RUNTIME_DIR"
export MOZ_USE_XINPUT2="1"		# Mozilla smooth scrolling/touchpads.

[ -s "${HOME}/.local/share/JetBrains/Toolbox/scripts" ] && export PATH="${PATH}:${HOME}/.local/share/JetBrains/Toolbox/scripts"

plugins=(
  git
  zsh-autosuggestions
  helm
  kubectl
  docker
  fd
  ripgrep
)

if type rg &> /dev/null; then
  # --files: List files that would be searched but do not search
  # --no-ignore: Do not respect .gitignore, etc...
  # --hidden: Search hidden files and folders
  # --follow: Follow symlinks
  # --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
  export FZF_DEFAULT_COMMAND='rg --no-binary --files --no-ignore --hidden --follow --glob "!.git/*"'
  export FZF_DEFAULT_OPTS='-m --height 50% --layout=reverse'
fi

_gen_fzf_default_opts() {
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
" --color=fg:$color03,header:$color0D,info:$color0A,pointer:$color0C"\
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
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

function clear-scrollback-and-screen () {
  zle clear-screen
  tmux clear-history
}
zle -N clear-scrollback-and-screen
bindkey -v '^L' clear-scrollback-and-screen

# Aliases
alias n="nvim"
alias nvim="lvim"
alias vim="lvim"
alias wezterm='flatpak run org.wezfurlong.wezterm'
alias ssh='TERM=xterm-color ssh'
alias sshk="ssh -o ServerAliveInterval=60"
alias ducks="du -cks * | sort -rn | head | column -t"
alias gsf="git status --porcelain | cut -d' ' -f3 | xargs"
alias watch="watch "
alias git-clean="git checkout -- \$(gsf)"
alias icat="kitty +kitten icat"

eval "$(zoxide init zsh)"
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

_attach_completion() {
  local cur_word
  cur_word="${COMP_WORDS[COMP_CWORD]}"
  local prev_word
  prev_word="${COMP_WORDS[COMP_CWORD-1]}"
  local options
  case "$prev_word" in
    -n)
      # Provide completion for namespace names
      options=$(kubectl get namespaces -o jsonpath='{.items[*].metadata.name}')
      COMPREPLY=($(compgen -W "${options}" -- "${cur_word}"))
      return
      ;;
    *)
      local namespace_flag
      namespace_flag=$(printf '%s\n' "${COMP_WORDS[@]}" | grep -e '\(-n\|--namespace\)')
      if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "-n" || "$prev_word" == "attach" ]]; then
        # Provide completion for pod names
        if [[ -n "$namespace_flag" ]]; then
          options=$(kubectl get pods --namespace "${prev_word}" --no-headers -o custom-columns=":metadata.name")
        else
          options=$(kubectl get pods --no-headers -o custom-columns=":metadata.name")
        fi
        COMPREPLY=($(compgen -W "${options}" -- "${cur_word}"))
        return
      else
        local pod_name
        pod_name="$prev_word"
        if [[ -n "$namespace_flag" ]]; then
          options=$(kubectl get pods --namespace "${COMP_WORDS[COMP_CWORD-2]}" $pod_name --no-headers -o jsonpath="{.spec.containers[*].name}")
        else
          options=$(kubectl get pods $pod_name --no-headers -o jsonpath="{.spec.containers[*].name}")
        fi
        COMPREPLY=($(compgen -W "${options}" -- "${cur_word}"))
        return
      fi
      ;;
  esac
}

complete -F _attach_completion attach

export FZF_COMPLETION_TRIGGER=''
export HISTORY_IGNORE="(ls|ll|cd|pwd|exit|vim|sudo reboot|history|cd -|cd ..)"

# Utility Functions
## Interactive CD
unalias g 2> /dev/null
function g() {
  if [ $# -eq 0 ] ; then
    path_to_cd=$(fd --type d --hidden --follow --exclude .git 2>/dev/null | fzf )
    [[ -z "$path_to_cd" ]] && return || cd "$path_to_cd"
  else
    cd $@
  fi
}

## Interactive Edit
unalias e 2> /dev/null
function e() {
  if [ $# -eq 0 ] ; then
    path_to_cd=$(fd --type f --hidden --follow --exclude .git 2>/dev/null | fzf )
    [[ -z "$path_to_cd" ]] && return || vim "$path_to_cd"
  else
    cd $@
  fi
}

## Kill Line Ctrl+k in Bash
function pb-kill-line() {
  zle kill-line
  echo -n $CUTBUFFER | xclip -selection clipboard
}

zle -N pb-kill-line
bindkey '^K' pb-kill-line
bindkey -e

## Archive Extraction
### usage: ex <file>
function ex ()
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

## Repo switcher
function p() {
  # The directory where we expect the projects to be in.
  proj_dir=${PROJ_DIR:-~/repos}

  project=$(/bin/ls $proj_dir | fzf --prompt "Switch to project: ")
  [ -n "$project" ] && cd $proj_dir/$project
}

## Easily switch between tmux session.
function sw() {
  session=$(tmux ls -F "#S" | fzf --prompt "Switch to tmux session: ")

  [ -n "$session" ] && tmux switch-client -t $session
}

hxs() {
  RG_PREFIX="rg -i --no-binary --hidden --files-with-matches"
  local files
  files="$(
    FZF_DEFAULT_COMMAND="$RG_PREFIX '$1'" \
      fzf --multi 3 --print0 --sort --preview="[[ ! -z {} ]] && rg --hidden --pretty --ignore-case --context 5 {q} {}" \
        --phony -i -q "$1" \
        --bind "change:reload:$RG_PREFIX {q}" \
        --preview-window="70%:wrap" \
        --bind 'ctrl-a:select-all'
  )"
  [[ "$files" ]] && hx --vsplit $(echo $files | tr \\0 " ")
}

hxa() {
  RG_PREFIX="rg --no-binary -i --hidden --files"
  local files
  files="$(
    rg -i --hidden --files |\
      fzf --sort
  )"
  [[ "$files" ]] && hx --vsplit $(echo $files | tr \\0 " ")
}
 
#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="${HOME}/.sdkman"
[[ -s "${HOME}/.sdkman/bin/sdkman-init.sh" ]] && source "${HOME}/.sdkman/bin/sdkman-init.sh"
sdk use java 17.0.4-oracle &> /dev/null

fpath+=~/.zfunc
