#!/usr/bin/env bash
rofi_command="rofi -theme ~/.config/rofi/powermenu.rasi"
uptime=$(uptime -p | sed -e 's/up //g')

# Options
exit=' '
renew=' '
lock=' '
suspend=' '
shutdown=' '

# Variable passed to rofi
options="$exit\n$renew\n$lock\n$suspend\n$shutdown"

chosen="$(echo -e "$options" | $rofi_command -p "$uptime" -dmenu -selected-row 2)"
case $chosen in
    $shutdown)
        systemctl poweroff
        ;;
    $lock)
        slock
        ;;
    $suspend)
        systemctl suspend
        ;;
    $renew)
        kill -HUP $(pidof -s {{window_manager}})
        ;;
    $exit)
        kill -TERM $(pidof -s {{window_manager}})
        ;;
esac
