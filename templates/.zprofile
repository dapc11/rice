#!/bin/zsh

# zsh profile file. Runs on login. Environmental variables are set here.

export PATH="$PATH:$HOME/bin:$(du "$HOME/.local/bin/" | cut -f2 | tr '\n' ':' | sed 's/:*$//')"

# Default programs:
export VISUAL="{{editor}}"
export EDITOR="{{editor}}"
export TERMINAL="{{terminal}}"
export BROWSER="{{browser}}"
export SHELL="/usr/bin/zsh"
export TERM="xterm-256color"

# Other program settings:
export LESSHISTFILE="-"
export TMUX_TMPDIR="$XDG_RUNTIME_DIR"
export FZF_DEFAULT_OPTS="--layout=reverse"
export MOZ_USE_XINPUT2="1"		# Mozilla smooth scrolling/touchpads.
if type rg &> /dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files -g "!.git"'
  export FZF_DEFAULT_OPTS='-m --height 50% --border'
fi
if type kubectl &> /dev/null; then
  source <(kubectl completion zsh)
fi
if type helm &> /dev/null; then
  source <(helm completion zsh)
fi

# Start graphical server on tty1 if not already running.
# [ "$(tty)" = "/dev/tty1" ] && ! ps -e | grep -qw Xorg && exec startx
