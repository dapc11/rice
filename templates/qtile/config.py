"""Dapc11 qtile config"""

from typing import List

from libqtile import bar, layout, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy

mod = "mod4"

keys = [
    # Switch between windows in current stack pane
    Key([mod], "Down", lazy.layout.down()),
    Key([mod], "Up", lazy.layout.up()),
    Key([mod], "Left", lazy.layout.left()),
    Key([mod], "Right", lazy.layout.right()),
    # Move windows up or down in current stack
    Key([mod, "control"], "Down", lazy.layout.shuffle_down()),
    Key([mod, "control"], "Up", lazy.layout.shuffle_up()),
    # Switch window focus to other pane(s) of stack
    Key([mod], "space", lazy.layout.next()),
    # Swap panes of split stack
    Key([mod, "shift"], "space", lazy.layout.rotate()),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key([mod, "shift"], "Return", lazy.layout.toggle_split()),
    Key([mod], "Return", lazy.spawn("{{terminal}} -e tmux new-session -A -s main")),
    Key([mod, "shift"], "Return", lazy.spawn("{{terminal}}")),
    Key(
        [mod],
        "d",
        lazy.spawn(
            "rofi -show drun -display-drun -modi drun -theme ~/.config/rofi/config",
        ),
    ),
    Key([mod], "s", lazy.spawn("rofi -show window -theme ~/.config/rofi/config")),
    Key([mod], "l", lazy.spawn("systemctl suspend")),
    Key([mod], "n", lazy.spawn("nightmode")),
    Key([mod], "w", lazy.spawn("{{browser}}")),
    Key([mod], "p", lazy.spawn("rofi-randr")),
    # Toggle between diffrent layouts as defined below
    Key([mod], "space", lazy.next_layout()),
    Key([mod], "Tab", lazy.screen.togglegroup()),
    Key([mod], "q", lazy.window.kill()),
    Key([mod, "control"], "r", lazy.restart()),
    Key([mod, "control"], "q", lazy.shutdown()),
    Key([mod], "r", lazy.spawncmd()),
    Key([], "XF86AudioRaiseVolume", lazy.spawn("amixer -c 0 -q set Master 2dB+")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("amixer -c 0 -q set Master 2dB-")),
    Key([], "XF86AudioMute", lazy.spawn("amixer set Master toggle")),
]

groups = [
    Group("1", layout="monadtall"),
    Group("2", layout="monadtall", matches=[Match(wm_class=["firefox"])]),
    Group("3", layout="monadtall"),
    Group("4", layout="monadtall"),
    Group("5", layout="monadtall"),
]

for i in groups:
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key([mod], i.name, lazy.group[i.name].toscreen()),
            # mod1 + shift + letter of group = switch to & move focused window to group
            Key([mod, "shift"], i.name, lazy.window.togroup(i.name, switch_group=True)),
            # Or, use below if you prefer not to switch to that group.
            # # mod1 + shift + letter of group = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name)),
        ],
    )

layouts = [
    layout.Max(),
    layout.Stack(
        num_stacks=2,
        border_focus="{{base03}}",
        border_normal="{{base01}}",
        border_width=1,
        margin=15,
    ),
    layout.Bsp(
        border_focus="{{base03}}",
        border_normal="{{base01}}",
        border_width=1,
        margin=15,
    ),
    layout.MonadTall(
        border_focus="{{base03}}",
        border_normal="{{base01}}",
        border_width=1,
        margin=15,
    ),
    layout.MonadWide(
        border_focus="{{base03}}",
        border_normal="{{base01}}",
        border_width=1,
        margin=15,
    ),
    layout.TreeTab(
        bg_color="{{base01}}",
        active_bg="{{base02}}",
        active_fg="{{base06}}",
        inactive_bg="{{base01}}",
        inactive_fg="{{base06}}",
        border_focus="{{base03}}",
        border_normal="{{base01}}",
        border_width=1,
        margin=15,
    ),
]

widget_defaults = dict(
    font="{{font}}",
    fontsize=14,
    padding=3,
    background="{{base01}}",
    foreground="{{base06}}",
)
extension_defaults = widget_defaults.copy()

SEPARATOR = widget.TextBox(text="|")

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.GroupBox(
                    active="{{base05}}",
                    inactive="{{base03}}",
                    this_current_screen_border="{{base05}}",
                    highlight_method="line",
                    highlight_color=["{{base01}}", "{{base01}}"],
                    center_aligned=True,
                ),
                widget.WindowName(),
                widget.Mpris2(
                    name="spotify",
                    objname="org.mpris.MediaPlayer2.spotify",
                    display_metadata=["xesam:title", "xesam:artist"],
                    scroll_chars=None,
                    stop_pause_text="",
                    **widget_defaults,
                ),
                SEPARATOR,
                widget.TextBox(text="墳"),
                widget.Volume(),
                SEPARATOR,
                widget.Battery(
                    format=" {percent:2.0%}",
                    low_foreground="{{base08}}",
                ),
                SEPARATOR,
                widget.Wlan(
                    foreground="{{base06}}",
                    interface="wlan0",
                    format="直 {essid}",
                ),
                SEPARATOR,
                widget.Clock(format="%Y-%m-%d %H:%M:%S"),
                SEPARATOR,
                widget.CurrentLayoutIcon(),
                SEPARATOR,
                widget.Systray(),
            ],
            24,
            background="{{base01}}",
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod],
        "Button3",
        lazy.window.set_size_floating(),
        start=lazy.window.get_size(),
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
main = None
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        {"wmclass": "confirm"},
        {"wmclass": "dialog"},
        {"wmclass": "download"},
        {"wmclass": "error"},
        {"wmclass": "file_progress"},
        {"wmclass": "notification"},
        {"wmclass": "splash"},
        {"wmclass": "toolbar"},
        {"wmclass": "confirmreset"},  # gitk
        {"wmclass": "makebranch"},  # gitk
        {"wmclass": "maketag"},  # gitk
        {"wname": "branchdialog"},  # gitk
        {"wname": "pinentry"},  # GPG key password entry
        {"wmclass": "ssh-askpass"},  # ssh-askpass
    ],
)
auto_fullscreen = True
focus_on_window_activation = "smart"

# Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
