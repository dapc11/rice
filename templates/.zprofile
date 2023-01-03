#!/bin/zsh

# zsh profile file. Runs on login. Environmental variables are set here.

export PATH="$PATH:$HOME/bin:$(du "$HOME/.local/bin/" | cut -f2 | tr '\n' ':' | sed 's/:*$//')"
export PATH=$PATH:/usr/local/go/bin:"$HOME/.config/git/scripts"

# Default programs:
export EDITOR="$(which lvim)"
export GIT_EDITOR="$(which lvim)"
export KUBE_EDITOR="$(which lvim)"
export TERMINAL="{{terminal}}"
export BROWSER="{{browser}}"
export SHELL="/usr/bin/zsh"
export TERM="xterm-256color"

# Other program settings:
export PYTHONDONTWRITEBYTECODE=1
export LESSHISTFILE="-"
export TMUX_TMPDIR="$XDG_RUNTIME_DIR"
export MOZ_USE_XINPUT2="1"		# Mozilla smooth scrolling/touchpads.

[ -s "${HOME}/.local/share/JetBrains/Toolbox/scripts" ] && export PATH="$PATH:${HOME}/.local/share/JetBrains/Toolbox/scripts"
[ -s "/usr/bin/python3" ] && export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
[ -s "${HOME}/.env" ] && export WORKON_HOME="${HOME}/.envs"
[ -s "${HOME}/.local/bin/virtualenvwrapper.sh" ] && export VIRTUALENVWRAPPER_SCRIPT="${HOME}/.local/bin/virtualenvwrapper.sh"
[ -s "${HOME}/.local/bin/virtualenvwrapper.sh" ] && source ${HOME}/.local/bin/virtualenvwrapper.sh
