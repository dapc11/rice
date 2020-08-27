#!/bin/sh

# xinitrc runs automatically when you run startx.

[ -f "${XDG_CONFIG_HOME:-$HOME}/.xprofile" ] && . "${XDG_CONFIG_HOME:-$HOME}/.xprofile"

# exec i3
