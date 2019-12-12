# Dapc11 Ricer

## TODO

### Intellij Dotfile
TODO

### Zsh -> fish

    sudo apt-add-repository ppa:fish-shell/release-2
    sudo apt-get update
    sudo apt-get install fish

    > which
    /usr/bin/fish
    > chsh -s /usr/bin/fish

    mkdir -p ~/.config/fish
    vim ~/.config/fish/config.fish
    set -g -x PATH /usr/local/bin $PATH

Launch webserver to config:

    fish_config
