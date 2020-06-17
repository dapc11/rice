#!/usr/bin/env bash

function main
{
    if [[ "$1" == "-k" ]] || [[ "$1" == "--kill-all" ]]; then
        killall -q polybar &>/dev/null ; shift
        local i=0;
        while (( ++i < 5 )) && pgrep -x polybar >/dev/null; do sleep 1; done
    fi

    local config="$1" ; shift
    local -a bars=("${@}")

    for bar in ${bars[*]}; do
        echo $bar
        polybar "$bar" -c "$config" -r 2>"$HOME/.config/polybar/stderr" &

    done

}

main "$@"
