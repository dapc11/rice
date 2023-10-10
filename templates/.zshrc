# Set up the prompt
autoload -Uz add-zsh-hook vcs_info

# Run the `vcs_info` hook to grab git info before displaying the prompt
add-zsh-hook precmd vcs_info

# Style the vcs_info message
zstyle ':vcs_info:*'     enable            git
zstyle ':vcs_info:git:*' formats           '%B%u %c%B%F %b'
zstyle ':vcs_info:git:*' actionformats     '%B%u %c%B%F %b'
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' get-revision      true
zstyle ':vcs_info:git:*' stagedstr         ' %F{green}✓ '
zstyle ':vcs_info:git:*' unstagedstr       ' %F{red}±'

RPROMPT=''
PROMPT='%B%F{green}%n%f:%F{blue}%2~%f%b%F{8}$vcs_info_msg_0_%f %(?.%#.%F{red}%#)%f '

setopt HIST_FIND_NO_DUPS HIST_IGNORE_ALL_DUPS prompt_subst auto_menu always_to_end complete_in_word
unsetopt flow_control menu_complete

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=100000
SAVEHIST=10000
HISTORY_IGNORE="(ls|ll|cd|pwd|exit|vim|sudo reboot|history|cd -|cd ..)"
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path $ZSH_CACHE_DIR
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

eval "$(zoxide init zsh)"

bindkey '^[[1;5C' emacs-forward-word
bindkey '^[[1;5D' emacs-backward-word

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

  FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS}"\
" --color=bg+:${color01},bg:${color00},spinner:${color0C},hl:${color0D}"\
" --color=fg:${color03},header:${color0D},info:${color0A},pointer:${color0C}"\
" --color=marker:${color0C},fg+:${color06},prompt:${color0A},hl+:${color0D}"
}

_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

_gen_fzf_default_opts
[[ ! -f ~/.fzf.zsh ]] || source ~/.fzf.zsh
# FZF ===============================================

# ENVIRONMENT =======================================
GOPATH="${HOME}/go"
EDITOR="nvim -u ~/.nvim_editor.lua"
GIT_EDITOR="${EDITOR}"
KUBE_EDITOR="${EDITOR}"
TERMINAL="{{terminal}}"
BROWSER="{{browser}}"
PYTHONDONTWRITEBYTECODE=1
LESSHISTFILE="-"
TMUX_TMPDIR="$XDG_RUNTIME_DIR"
PATH="${PATH}:${HOME}/bin:${HOME}/.local/bin:\
/usr/local/go/bin:\
${HOME}/.config/git/scripts:\
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
    [[ -z "$path_to_cd" ]] && return || vim "$path_to_cd"
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

# UTILS =============================================
#
# #THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
# SDKMAN_DIR="${HOME}/.sdkman"
# [[ -s "${HOME}/.sdkman/bin/sdkman-init.sh" ]] && source "${HOME}/.sdkman/bin/sdkman-init.sh"
# sdk use java 17.0.4-oracle &> /dev/null
