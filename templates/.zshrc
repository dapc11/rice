# Plugins ===============================================
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"
plug "zsh-users/zsh-autosuggestions"

# Prompt ===============================================
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )

zstyle ':vcs_info:*'     enable            git
zstyle ':vcs_info:git:*' formats           '%B%u%c %B%F %b'
zstyle ':vcs_info:git:*' actionformats     '%B%u%c %B%F %b'
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' get-revision      true
zstyle ':vcs_info:git:*' stagedstr         '%F{green}✓'
zstyle ':vcs_info:git:*' unstagedstr       '%F{red}±'

export PROMPT=$'┌──${debian_chroot:+($debian_chroot)──}%B%F{%(#.red.blue)}%n%(#.💀.@)%m%b%F{%(#.blue.green)} %B%F{reset}[%(6~.%-1~/…/%4~.%5~)$vcs_info_msg_0_%f] %(?..%?%F{red}%B⨯%b%F{reset})\n└─%B%(#.%F{red}#.%F{blue}$)%b%F{reset} '

# Options ===============================================
setopt prompt_subst auto_menu always_to_end complete_in_word share_history autocd
unsetopt flow_control menu_complete
export WORDCHARS=${WORDCHARS//\/} # Don't consider certain characters part of the word
# configure `time` format
export TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S\ncpu\t%P'

# History ===============================================
setopt HIST_FIND_NO_DUPS HIST_IGNORE_ALL_DUPS

# force zsh to show the complete history
alias history="history 0"
export HISTSIZE=1000000
export SAVEHIST=1000000
export HISTORY_IGNORE="(ls|ll|cd|pwd|exit|vim|sudo reboot|history|cd -|cd ..)"
export HISTFILE=~/.zsh_history

# Keymaps ===============================================
# Kill Line Ctrl+k in Bash
function pb-kill-line() {
  zle kill-line
  echo -n $CUTBUFFER | xclip -selection clipboard
}

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
zle -N pb-kill-line
bindkey '^K' pb-kill-line
bindkey '^[[1;5C' emacs-forward-word
bindkey '^[[1;5D' emacs-backward-word
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search
bindkey "^[[3~" delete-char                       # delete
bindkey '^[[5~' beginning-of-buffer-or-history    # page up
bindkey '^[[6~' end-of-buffer-or-history          # page down
bindkey '^[[Z' undo                               # shift + tab undo last action
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey '^[[1;5C' forward-word                    # ctrl + ->
bindkey '^[[C' forward-word                       # ctrl + ->
bindkey '^[[1;5D' backward-word                   # ctrl + <-
bindkey '^[[D' backward-word                      # ctrl + <-

if [ -f ~/.zsh/colors.zsh ]; then
    source ~/.zsh/colors.zsh
else
    print "~/.zsh/colors.zsh not found"
fi

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    export LS_COLORS="$LS_COLORS:ow=30;44:" # fix ls color for folders with 777 permissions

    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias diff='diff --color=auto'
    alias ip='ip --color=auto'

    export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
    export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
    export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
    export LESS_TERMCAP_so=$'\E[01;33m'    # begin reverse video
    export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
    export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
    export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

    # Take advantage of $LS_COLORS for completion as well
    zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
    zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
fi

# FZF ===============================================
if type rg &> /dev/null; then
  # --files: List files that would be searched but do not search
  # --no-ignore: Do not respect .gitignore, etc...
  # --hidden: Search hidden files and folders
  # --follow: Follow symlinks
  # --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
  export FZF_DEFAULT_COMMAND='rg --no-binary --files --no-ignore --hidden --follow --glob "!.git/*"'
  export FZF_DEFAULT_OPTS='--layout=reverse'
fi

_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}
# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'tree -C {} | head -200'   "$@" ;;
    export|unset) fzf --preview "eval 'echo \$'{}"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview 'bat -n --color=always {}' "$@" ;;
  esac
}

[[ ! -f ~/.fzf.zsh ]] || source ~/.fzf.zsh

# Environment =======================================
export GOPATH="${HOME}/go"
export EDITOR="NVIM_APPNAME=nvim_editor nvim -u ~/.nvim_editor.lua"
export GIT_EDITOR="${EDITOR}"
export KUBE_EDITOR="${EDITOR}"
export TERMINAL="wezterm"
export TERM="xterm-256color"
export BROWSER="firefox"
export PYTHONDONTWRITEBYTECODE=1
export LESSHISTFILE="-"
export TMUX_TMPDIR="$XDG_RUNTIME_DIR"
export PATH="${PATH}:\
${HOME}/bin:\
${HOME}/.local/bin:\
${HOME}/.config/git/scripts:\
/usr/local/go/bin:\
${GOPATH}/bin"

# Alias =============================================
alias -- -='cd -'
alias ssh='TERM=xterm-color ssh'
alias sshk="ssh -o ServerAliveInterval=60"
alias ducks="du -cks * | sort -rn | head | column -t"
alias gsf="git status --porcelain | cut -d' ' -f3 | xargs"
alias watch="watch "
alias git-clean="git checkout -- \$(gsf)"
alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias -- ..='cd ..'

# Utils =============================================
## Interactive Edit
unalias e 2> /dev/null
function e() {
  if [ $# -eq 0 ] ; then
    path_to_cd=$(fd --type f --hidden --follow --exclude .git 2>/dev/null | fzf )
    [[ -z "$path_to_cd" ]] && return || nvim "$path_to_cd"
  else
    cd $@
  fi
}

## Archive Extraction
function ex()
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

# Completion ========================================
autoload -Uz compinit
compinit -d ~/.cache/zcompdump
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' rehash true
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose false
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

_k8s_tool_completion() {
  eval $(env _TYPER_COMPLETE_ARGS="${words[1,$CURRENT]}" _K8S_TOOL_COMPLETE=complete_zsh k8s_tool)
}
compdef _k8s_tool_completion k8s_tool

_it_tool_completion() {
  eval $(env _TYPER_COMPLETE_ARGS="${words[1,$CURRENT]}" _IT_TOOL_COMPLETE=complete_zsh it_tool)
}
compdef _it_tool_completion it_tool

_3pp_tool_completion() {
  eval $(env _TYPER_COMPLETE_ARGS="${words[1,$CURRENT]}" _3PP_TOOL_COMPLETE=complete_zsh 3pp_tool)
}
compdef _3pp_tool_completion 3pp_tool
compdef __start_kubectl k

eval "$(zoxide init zsh)"

# #THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="${HOME}/.sdkman"
[[ -s "${HOME}/.sdkman/bin/sdkman-init.sh" ]] && source "${HOME}/.sdkman/bin/sdkman-init.sh"
#sdk use java 17.0.4-oracle &> /dev/null
