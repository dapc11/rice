user_home="/home/${USER}"

export TERM="xterm-256color"
export ZSH="${user_home}/.oh-my-zsh"

ZSH_THEME="{{zsh_theme}}"

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

if [ -e /usr/local/bin/kubectl ]; then source <(kubectl completion zsh); fi
if [ -e /usr/local/bin/helm ]; then source <(helm completion zsh); fi

setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
set -g hist_ignore_dups

function git_prompt_info() {
  local ref
  if [[ "$(command git config --get oh-my-zsh.hide-status 2>/dev/null)" != "1" ]]; then
    ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return 0
    echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
  fi
}

function conda_env()
{
    if [ -n $(command -v conda) ]; then
        local conda="🅒 $(command conda info | grep "active environment" | cut -d" " -f9)"
        echo "%{$FG[003]%}${conda}%{$reset_color%}"
    fi
}

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[blue]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"

RPROMPT='${return_code}'

########################## fzf
# fbr - checkout git branch
fbr() {
  local branches branch
  branches=$(git --no-pager branch -vv) &&
  branch=$(echo "$branches" | fzf +m) &&
  git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
}

# fbr - checkout git branch (including remote branches)
fbr() {
  local branches branch
  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# fbr - checkout git branch (including remote branches), sorted by most recent commit, limit 30 last branches
fbr() {
  local branches branch
  branches=$(git for-each-ref --count=30 --sort=-committerdate refs/heads/ --format="%(refname:short)") &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# fco - checkout git branch/tag
fco() {
  local tags branches target
  branches=$(
    git --no-pager branch --all \
      --format="%(if)%(HEAD)%(then)%(else)%(if:equals=HEAD)%(refname:strip=3)%(then)%(else)%1B[0;34;1mbranch%09%1B[m%(refname:short)%(end)%(end)" \
    | sed '/^$/d') || return
  tags=$(
    git --no-pager tag | awk '{print "\x1b[35;1mtag\x1b[m\t" $1}') || return
  target=$(
    (echo "$branches"; echo "$tags") |
    fzf --no-hscroll --no-multi -n 2 \
        --ansi) || return
  git checkout $(awk '{print $2}' <<<"$target" )
}

fshow() {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
      --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF"
}

fcoc() {
  local commits commit
  commits=$(git log --pretty=oneline --abbrev-commit --reverse) &&
  commit=$(echo "$commits" | fzf --tac +s +m -e) &&
  git checkout $(echo "$commit" | sed "s/ .*//")
}


# fco_preview - checkout git branch/tag, with a preview showing the commits between the tag/branch and HEAD
fco_preview() {
  local tags branches target
  branches=$(
    git --no-pager branch --all \
      --format="%(if)%(HEAD)%(then)%(else)%(if:equals=HEAD)%(refname:strip=3)%(then)%(else)%1B[0;34;1mbranch%09%1B[m%(refname:short)%(end)%(end)" \
    | sed '/^$/d') || return
  tags=$(
    git --no-pager tag | awk '{print "\x1b[35;1mtag\x1b[m\t" $1}') || return
  target=$(
    (echo "$branches"; echo "$tags") |
    fzf --no-hscroll --no-multi -n 2 \
        --ansi --preview="git --no-pager log -150 --pretty=format:%s '..{2}'") || return
  git checkout $(awk '{print $2}' <<<"$target" )
}

alias glNoGraph='git log --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr% C(auto)%an" "$@"'
_gitLogLineToHash="echo {} | grep -o '[a-f0-9]\{7\}' | head -1"
_viewGitLogLine="$_gitLogLineToHash | xargs -I % sh -c 'git show --color=always %'"

# fcoc_preview - checkout git commit with previews
fcoc_preview() {
  local commit
  commit=$( glNoGraph |
    fzf --no-sort --reverse --tiebreak=index --no-multi \
        --ansi --preview="$_viewGitLogLine" ) &&
  git checkout $(echo "$commit" | sed "s/ .*//")
}

# fshow_preview - git commit browser with previews
fshow_preview() {
    glNoGraph |
        fzf --no-sort --reverse --tiebreak=index --no-multi \
            --ansi --preview="$_viewGitLogLine" \
                --header "enter to view, alt-y to copy hash" \
                --bind "enter:execute:$_viewGitLogLine   | less -R" \
                --bind "alt-y:execute:$_gitLogLineToHash | xclip"
}

ftag_preview() {
  local tags target
  tags=$(
    git --no-pager tag | awk '{print "\x1b[35;1mtag\x1b[m\t" $1}') || return
  target=$(git --no-pager tag | fzf --no-hscroll --no-multi -n 2 --ansi --preview="git --no-pager log -150 --color=always --oneline '{1}..HEAD'") || return
  git checkout $(awk '{print $1}' <<<"$target" )
}


# Select a docker container to start and attach to
function da() {
  local cid
  cid=$(docker ps -a | sed 1d | fzf -1 -q "$1" | awk '{print $1}')

  [ -n "$cid" ] && docker start "$cid" && docker exec -it "$cid" bash
}
# Select a running docker container to stop
function ds() {
  local cid
  cid=$(docker ps | sed 1d | fzf -q "$1" | awk '{print $1}')

  [ -n "$cid" ] && docker stop "$cid"
}
# Select a docker container to remove
function drm() {
  local cid
  cid=$(docker ps -a | sed 1d | fzf -q "$1" | awk '{print $1}')

  [ -n "$cid" ] && docker rm "$cid"
}
PROMPT=' %{${fg[green]}%}%3~%{$reset_color%}$(git_prompt_info) %{$FG[059]%}$(conda_env) %{$reset_color%}%(?..%{$fg[red]%})› %{$reset_color%}'
local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

RPROMPT='${return_code} '
