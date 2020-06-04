#!/bin/zsh

# zsh profile file. Runs on login. Environmental variables are set here.

# Adds `~/.local/bin` to $PATH
export PATH="$PATH:$(du "$HOME/.local/bin/" | cut -f2 | tr '\n' ':' | sed 's/:*$//')"

# Default programs:
export EDITOR="{{editor}}"
export TERMINAL="{{terminal}}"
export BROWSER="{{browser}}"

export LESSHISTFILE="-"
export TMUX_TMPDIR="$XDG_RUNTIME_DIR"

# Other program settings:
export FZF_DEFAULT_OPTS="--layout=reverse"
export MOZ_USE_XINPUT2="1"		# Mozilla smooth scrolling/touchpads.

# Start graphical server on tty1 if not already running.
[ "$(tty)" = "/dev/tty1" ] && ! ps -e | grep -qw Xorg && exec startx
