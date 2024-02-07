# Plugins ===============================================
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"
plug "zsh-users/zsh-autosuggestions"
plug "marlonrichert/zsh-edit"

# Prompt ===============================================
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )

zstyle ':vcs_info:*'     enable            git
zstyle ':vcs_info:git:*' formats           ' %F%B%u%c%F{magenta}%B %b'
zstyle ':vcs_info:git:*' actionformats     ' %F%B%u%c%F{magenta}%B %b'
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' get-revision      true
zstyle ':vcs_info:git:*' stagedstr         '%F{green}'
zstyle ':vcs_info:git:*' unstagedstr       '%F{red}'

export PROMPT=$'%F{blue}[%(6~.%-1~/…/%4~.%5~)$vcs_info_msg_0_%f%b%F{blue}] %(?..%?%F{red}%B⨯ %b%F{reset})%B%(#.%F{red}#.%F{blue}$)%b%F{reset} '

# Options ===============================================
setopt prompt_subst auto_menu always_to_end complete_in_word share_history autocd
unsetopt flow_control menu_complete
export WORDCHARS=${WORDCHARS//\/} # Don't consider certain characters part of the word
# configure `time` format
export TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S\ncpu\t%P'
autoload -U select-word-style
select-word-style bash

# History ===============================================
setopt HIST_FIND_NO_DUPS HIST_IGNORE_ALL_DUPS

# force zsh to show the complete history
alias history="history 0"
export HISTSIZE=1000000
export SAVEHIST=1000000
export HISTORY_IGNORE="(ls|ll|cd|pwd|exit|vim|sudo reboot|history|cd -|cd ..)"
export HISTFILE=~/.zsh_history
export DEBIAN_PREVENT_KEYBOARD_CHANGES=yes

# Keymaps ===============================================
# Kill Line Ctrl+k in Bash
function pb-kill-line() {
  zle kill-line
  echo -n $CUTBUFFER | xclip -selection clipboard
}

function pb-yank() {
  CUTBUFFER=$(xsel -ob)
  zle yank

  BUFFER=$BUFFER$CUTBUFFER
  zle end-of-line
  zle reset-prompt
}

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
zle -N pb-kill-line
zle -N pb-yank
bindkey '^Y' pb-yank
bindkey '^K' pb-kill-line
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search
bindkey "^[[3~" delete-char                       # delete
bindkey '^[[5~' beginning-of-buffer-or-history    # page up
bindkey '^[[6~' end-of-buffer-or-history          # page down
bindkey '^[[Z' undo                               # shift + tab undo last action
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

bindkey -s "^[x" "tmux-sessionizer\n"

if [ -f ~/.zsh/colors.zsh ]; then
    source ~/.zsh/colors.zsh
else
    print "~/.zsh/colors.zsh not found"
fi

if [ -x /usr/bin/dircolors ]; then
    # test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    # export LS_COLORS="$LS_COLORS:ow=30;44:" # fix ls color for folders with 777 permissions

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

  # export FZF_DEFAULT_OPTS="--layout=reverse \
  # --color=bg+:#414559,bg:#303446,spinner:#f2d5cf,hl:#e78284 \
  # --color=fg:#c6d0f5,header:#e78284,info:#ca9ee6,pointer:#f2d5cf \
  # --color=marker:#f2d5cf,fg+:#c6d0f5,prompt:#ca9ee6,hl+:#e78284"
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
alias cls="printf '\033[2J\033[3J\033[1;1H'"
alias -- -='cd -'
alias -- ..='cd ..'
alias ssh='TERM=xterm-color ssh'
alias sshk="ssh -o ServerAliveInterval=60"
alias ducks="du -cks * | sort -rn | head | column -t"
alias gsf="git status --porcelain | cut -d' ' -f3 | xargs"
alias watch="watch "
alias git-clean="git checkout -- \$(gsf)"
alias ls='ls --color=auto'
alias ll='ls -talF'
alias la='ls -A'
alias l='ls -CF'
alias k='kubectl'
alias kns='kubectl -n ${NAMESPACE}'
alias catp='kitten icat'

function kresetns() {
    kubectl delete namespace $1
    kubectl create namespace $1
}

function gsearch()
{
  term=$1
  shift
  git grep --heading $@ $term $(git rev-list --all) |  awk '{split($0,a,":"); print a[1],a[2],a[3]}'
}

function gsum()
{
  git log $@ --numstat --pretty="%ae %H" | sed 's/@.*//g' | awk '{ if (NF == 1){ name = $1}; if(NF == 3) {plus[name] += $1; minus[name] += $2}} END { for (name in plus) {print name": +"plus[name]" -"minus[name]}}' | sort -k2 -gr | column -t
}

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
#compdef kubectl
compdef _kubectl kubectl

# Copyright 2016 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#compdef kubectl

# zsh completion for kubectl                              -*- shell-script -*-

__kubectl_debug()
{
    local file="$BASH_COMP_DEBUG_FILE"
    if [[ -n ${file} ]]; then
        echo "$*" >> "${file}"
    fi
}

_kubectl()
{
    local shellCompDirectiveError=1
    local shellCompDirectiveNoSpace=2
    local shellCompDirectiveNoFileComp=4
    local shellCompDirectiveFilterFileExt=8
    local shellCompDirectiveFilterDirs=16

    local lastParam lastChar flagPrefix requestComp out directive comp lastComp noSpace
    local -a completions

    __kubectl_debug "\n========= starting completion logic =========="
    __kubectl_debug "CURRENT: ${CURRENT}, words[*]: ${words[*]}"

    # The user could have moved the cursor backwards on the command-line.
    # We need to trigger completion from the $CURRENT location, so we need
    # to truncate the command-line ($words) up to the $CURRENT location.
    # (We cannot use $CURSOR as its value does not work when a command is an alias.)
    words=("${=words[1,CURRENT]}")
    __kubectl_debug "Truncated words[*]: ${words[*]},"

    lastParam=${words[-1]}
    lastChar=${lastParam[-1]}
    __kubectl_debug "lastParam: ${lastParam}, lastChar: ${lastChar}"

    # For zsh, when completing a flag with an = (e.g., kubectl -n=<TAB>)
    # completions must be prefixed with the flag
    setopt local_options BASH_REMATCH
    if [[ "${lastParam}" =~ '-.*=' ]]; then
        # We are dealing with a flag with an =
        flagPrefix="-P ${BASH_REMATCH}"
    fi

    # Prepare the command to obtain completions
    requestComp="${words[1]} __complete ${words[2,-1]}"
    if [ "${lastChar}" = "" ]; then
        # If the last parameter is complete (there is a space following it)
        # We add an extra empty parameter so we can indicate this to the go completion code.
        __kubectl_debug "Adding extra empty parameter"
        requestComp="${requestComp} \"\""
    fi

    __kubectl_debug "About to call: eval ${requestComp}"

    # Use eval to handle any environment variables and such
    out=$(eval ${requestComp} 2>/dev/null)
    __kubectl_debug "completion output: ${out}"

    # Extract the directive integer following a : from the last line
    local lastLine
    while IFS='\n' read -r line; do
        lastLine=${line}
    done < <(printf "%s\n" "${out[@]}")
    __kubectl_debug "last line: ${lastLine}"

    if [ "${lastLine[1]}" = : ]; then
        directive=${lastLine[2,-1]}
        # Remove the directive including the : and the newline
        local suffix
        (( suffix=${#lastLine}+2))
        out=${out[1,-$suffix]}
    else
        # There is no directive specified.  Leave $out as is.
        __kubectl_debug "No directive found.  Setting do default"
        directive=0
    fi

    __kubectl_debug "directive: ${directive}"
    __kubectl_debug "completions: ${out}"
    __kubectl_debug "flagPrefix: ${flagPrefix}"

    if [ $((directive & shellCompDirectiveError)) -ne 0 ]; then
        __kubectl_debug "Completion received error. Ignoring completions."
        return
    fi

    local activeHelpMarker="_activeHelp_ "
    local endIndex=${#activeHelpMarker}
    local startIndex=$((${#activeHelpMarker}+1))
    local hasActiveHelp=0
    while IFS='\n' read -r comp; do
        # Check if this is an activeHelp statement (i.e., prefixed with $activeHelpMarker)
        if [ "${comp[1,$endIndex]}" = "$activeHelpMarker" ];then
            __kubectl_debug "ActiveHelp found: $comp"
            comp="${comp[$startIndex,-1]}"
            if [ -n "$comp" ]; then
                compadd -x "${comp}"
                __kubectl_debug "ActiveHelp will need delimiter"
                hasActiveHelp=1
            fi

            continue
        fi

        if [ -n "$comp" ]; then
            # If requested, completions are returned with a description.
            # The description is preceded by a TAB character.
            # For zsh's _describe, we need to use a : instead of a TAB.
            # We first need to escape any : as part of the completion itself.
            comp=${comp//:/\\:}

            local tab="$(printf '\t')"
            comp=${comp//$tab/:}

            __kubectl_debug "Adding completion: ${comp}"
            completions+=${comp}
            lastComp=$comp
        fi
    done < <(printf "%s\n" "${out[@]}")

    # Add a delimiter after the activeHelp statements, but only if:
    # - there are completions following the activeHelp statements, or
    # - file completion will be performed (so there will be choices after the activeHelp)
    if [ $hasActiveHelp -eq 1 ]; then
        if [ ${#completions} -ne 0 ] || [ $((directive & shellCompDirectiveNoFileComp)) -eq 0 ]; then
            __kubectl_debug "Adding activeHelp delimiter"
            compadd -x "--"
            hasActiveHelp=0
        fi
    fi

    if [ $((directive & shellCompDirectiveNoSpace)) -ne 0 ]; then
        __kubectl_debug "Activating nospace."
        noSpace="-S ''"
    fi

    if [ $((directive & shellCompDirectiveFilterFileExt)) -ne 0 ]; then
        # File extension filtering
        local filteringCmd
        filteringCmd='_files'
        for filter in ${completions[@]}; do
            if [ ${filter[1]} != '*' ]; then
                # zsh requires a glob pattern to do file filtering
                filter="\*.$filter"
            fi
            filteringCmd+=" -g $filter"
        done
        filteringCmd+=" ${flagPrefix}"

        __kubectl_debug "File filtering command: $filteringCmd"
        _arguments '*:filename:'"$filteringCmd"
    elif [ $((directive & shellCompDirectiveFilterDirs)) -ne 0 ]; then
        # File completion for directories only
        local subdir
        subdir="${completions[1]}"
        if [ -n "$subdir" ]; then
            __kubectl_debug "Listing directories in $subdir"
            pushd "${subdir}" >/dev/null 2>&1
        else
            __kubectl_debug "Listing directories in ."
        fi

        local result
        _arguments '*:dirname:_files -/'" ${flagPrefix}"
        result=$?
        if [ -n "$subdir" ]; then
            popd >/dev/null 2>&1
        fi
        return $result
    else
        __kubectl_debug "Calling _describe"
        if eval _describe "completions" completions $flagPrefix $noSpace; then
            __kubectl_debug "_describe found some completions"

            # Return the success of having called _describe
            return 0
        else
            __kubectl_debug "_describe did not find completions."
            __kubectl_debug "Checking if we should do file completion."
            if [ $((directive & shellCompDirectiveNoFileComp)) -ne 0 ]; then
                __kubectl_debug "deactivating file completion"

                # We must return an error code here to let zsh know that there were no
                # completions found by _describe; this is what will trigger other
                # matching algorithms to attempt to find completions.
                # For example zsh can match letters in the middle of words.
                return 1
            else
                # Perform file completion
                __kubectl_debug "Activating file completion"

                # We must return the result of this command, so it must be the
                # last command, or else we must store its result to return it.
                _arguments '*:filename:_files'" ${flagPrefix}"
            fi
        fi
    fi
}

# don't run the completion function when being source-ed or eval-ed
if [ "$funcstack[1]" = "_kubectl" ]; then
    _kubectl
fi

kc() {
    [ -e "~/.kube/last_ns" ] || touch ~/.kube/last_ns
    last_namespace=$(cat ~/.kube/last_ns)
    current_context=$(kubectl config current-context)
    if [ $# -eq 0 ]; then
        kubectl config get-contexts
    elif [ "$1" = "-" ]; then
        kubectl config get-contexts ${current_context} --no-headers | cut -d" " -f15 > ~/.kube/last_ns
        kubectl config set-context $current_context --namespace="$last_namespace"
        echo "Switched to previous context: $current_context:$last_namespace"
    else
        current_ns=$(kubectl config get-contexts ${current_context} --no-headers | cut -d" " -f15)
        [ "$current_ns" = "$1" ] && return

        echo $current_ns > ~/.kube/last_ns
        kubectl config set-context $current_context --namespace="$1"
        echo "Switched to context: $current_context:$1"
    fi
}
_kc_autocomplete() {
    namespaces=$(kubectl get namespaces --no-headers | awk '{print $1}')
    COMPREPLY=($(compgen -W "$namespaces -" -- "${COMP_WORDS[COMP_CWORD]}"))
}

complete -F _kc_autocomplete kc


