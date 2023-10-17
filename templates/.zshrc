fpath+=($HOME/.zsh/pure)
autoload -U promptinit; promptinit
prompt pure

setopt HIST_FIND_NO_DUPS HIST_IGNORE_ALL_DUPS prompt_subst auto_menu always_to_end complete_in_word share_history
unsetopt flow_control menu_complete

HISTSIZE=1000000
SAVEHIST=1000000
HISTORY_IGNORE="(ls|ll|cd|pwd|exit|vim|sudo reboot|history|cd -|cd ..)"
HISTFILE=~/.zsh_history

autoload -Uz compinit
compinit

zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path "$ZSH_CACHE_DIR"
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

bindkey '^[[1;5C' emacs-forward-word
bindkey '^[[1;5D' emacs-backward-word
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search
bindkey "^[[3~" delete-char

if [ -f ~/.zsh/colors.zsh ]; then
    source ~/.zsh/colors.zsh
else
    print "~/.zsh/colors.zsh not found."
fi

# FZF ===============================================
if type rg &> /dev/null; then
  # --files: List files that would be searched but do not search
  # --no-ignore: Do not respect .gitignore, etc...
  # --hidden: Search hidden files and folders
  # --follow: Follow symlinks
  # --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
  FZF_DEFAULT_COMMAND='rg --no-binary --files --no-ignore --hidden --follow --glob "!.git/*"'
  FZF_DEFAULT_OPTS='-m --height 50% --layout=reverse'
fi

_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

_gen_fzf_default_opts
[[ ! -f ~/.fzf.zsh ]] || source ~/.fzf.zsh

# ENVIRONMENT =======================================
GOPATH="${HOME}/go"
EDITOR="nvim -u ~/.nvim_editor.lua"
GIT_EDITOR="${EDITOR}"
KUBE_EDITOR="${EDITOR}"
TERMINAL="wezterm"
TERM="xterm-256color"
BROWSER="firefox"
PYTHONDONTWRITEBYTECODE=1
LESSHISTFILE="-"
TMUX_TMPDIR="$XDG_RUNTIME_DIR"
PATH="${PATH}:\
${HOME}/bin:\
${HOME}/.local/bin:\
${HOME}/.config/git/scripts:\
/usr/local/go/bin:\
${GOPATH}/bin"
# ENVIRONMENT =======================================

# ALIAS =============================================
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

# UTILS =============================================
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

# COMPLETION ========================================
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
SDKMAN_DIR="${HOME}/.sdkman"
[[ -s "${HOME}/.sdkman/bin/sdkman-init.sh" ]] && source "${HOME}/.sdkman/bin/sdkman-init.sh"
#sdk use java 17.0.4-oracle &> /dev/null
