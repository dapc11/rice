plugins=(
    git
    zsh-autosuggestions
)

export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

function git_prompt_info() {
  local ref
  if [[ "$(command git config --get oh-my-zsh.hide-status 2>/dev/null)" != "1" ]]; then
    ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return 0
    echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
  fi
}

ZSH_THEME="{{zsh_theme}}"
HIST_STAMPS="mm/dd/yyyy"
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
alias vim="nvim"
alias sshk="ssh -o ServerAliveInterval=60"
alias ducks="du -cks * | sort -rn | head"
alias fzf_history="history | fzf"
alias fzf_find="find . | fzf"
alias fzf_ps="ps -ef | fzf"

# Utils
bookmark_file="$HOME/.local/bookmarks"
function bookmark_add {
    mkdir -p $HOME/.local
    touch $bookmark_file
    grep -qF -- "$1" "$bookmark_file" || echo "$1" >> "$bookmark_file"
}

function bookmark {
    cd $(cat $bookmark_file | fzf)
}

function b {
    bookmark
}

function fzf_branches {
  local branches branch
  branches=$(git for-each-ref --count=30 --sort=-committerdate refs/heads/ --format="%(refname:short)") &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# fco_preview - checkout git branch/tag, with a preview showing the commits between the tag/branch and HEAD
function fzf_checkout_preview {
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

alias glNoGraph='git log --color=always --format="%C(auto)%h%d %C(auto)%<(20)%an %s %C(black)%C(bold)%cr" "$@"'
_gitLogLineToHash="echo {} | grep -o '[a-f0-9]\{7\}' | head -1"
_viewGitLogLine="$_gitLogLineToHash | xargs -I % sh -c 'git show --color=always %'"


function fzf_checkout {
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

function fzf_show {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
      --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF"
}

function fzf_checkout_commit {
  local commits commit
  commits=$(git log --pretty=oneline --abbrev-commit --reverse) &&
  commit=$(echo "$commits" | fzf --tac +s +m -e) &&
  git checkout $(echo "$commit" | sed "s/ .*//")
}


function fzf_show_preview {
    glNoGraph |
        fzf --no-sort --reverse --tiebreak=index --no-multi \
            --ansi --preview="$_viewGitLogLine" \
                --header "enter to view, alt-y to copy hash" \
                --bind "enter:execute:$_viewGitLogLine   | less -R" \
                --bind "alt-y:execute:$_gitLogLineToHash | xclip"
}

function fzf_tag_preview {
  local tags target
  tags=$(
    git --no-pager tag | awk '{print "\x1b[35;1mtag\x1b[m\t" $1}') || return
  target=$(git --no-pager tag | fzf --no-hscroll --no-multi -n 2 --ansi --preview="git --no-pager log -150 --color=always --oneline '{1}..HEAD'") || return
  git checkout $(awk '{print $1}' <<<"$target" )
}

function fzf_docker_attach {
  local cid
  cid=$(docker ps -a | sed 1d | fzf -1 -q "$1" | awk '{print $1}')

  [ -n "$cid" ] && docker start "$cid" && docker exec -it "$cid" bash
}

function fzf_docker_stop {
  local cid
  cid=$(docker ps | sed 1d | fzf -q "$1" | awk '{print $1}')

  [ -n "$cid" ] && docker stop "$cid"
}

function fzf_docker_rm {
  local cid
  cid=$(docker ps -a | sed 1d | fzf -q "$1" | awk '{print $1}')

  [ -n "$cid" ] && docker rm "$cid"
}

function fzf_tmux_attach {
    local sessions
    sessions="$(tmux ls|fzf --exit-0 --multi)"  || return $?
    local i
    for i in "${(f@)sessions}"
    do
        [[ $i =~ '([^:]*):.*' ]] && {
            echo "Attaching to $match[1]"
            tmux attach-session -t "$match[1]"
        }
    done
}

function fzf_tmux_kill {
    local sessions
    sessions="$(tmux ls|fzf --exit-0 --multi)"  || return $?
    local i
    for i in "${(f@)sessions}"
    do
        [[ $i =~ '([^:]*):.*' ]] && {
            echo "Killing $match[1]"
            tmux kill-session -t "$match[1]"
        }
    done
}
function c() {
  local cols sep
  cols=$(( COLUMNS / 3 ))
  sep='{::}'

  cp -f ~/.config/google-chrome/Default/History /tmp/h

  sqlite3 -separator $sep /tmp/h \
    "select substr(title, 1, $cols), url
     from urls order by last_visit_time desc" |
  awk -F $sep '{printf "%-'$cols's  \x1b[36m%s\x1b[m\n", $1, $2}' | grep -v "file" |
  fzf --ansi --multi | sed 's#.*\(https*://\)#\1#' | xargs -I {} xdg-open "{}"
}
