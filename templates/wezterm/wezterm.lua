local wezterm = require("wezterm")

local colors = {
    bg = "{{base00}}",
    fg = "{{base06}}",
    black = "{{base00}}",
    red = "{{base08}}",
    green = "{{base0B}}",
    yellow = "{{base0A}}",
    blue = "{{base0C}}",
    magenta = "{{base0E}}",
    cyan = "{{base0D}}",
    white = "{{base07}}",
    cursor = "{{base05}}",
}

local colors_normal = {
    colors.black,
    colors.red,
    colors.green,
    colors.yellow,
    colors.blue,
    colors.magenta,
    colors.cyan,
    colors.white,
}

local colors_bright = {
    "{{base02}}", -- black
    "{{base08}}", -- red
    "{{base0B}}", -- green
    "{{base0A}}", -- yellow
    "{{base0C}}", -- blue
    "{{base0E}}", -- magenta
    "{{base0D}}", -- cyan
    "{{base07}}", -- white
}

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
    return " " .. tab.active_pane.title .. " "
end)

return {
    font = wezterm.font("{{font}}"),
    font_size = 12,
    window_close_confirmation = "NeverPrompt",
    window_padding = { left = 5, right = 5, top = 5, bottom = 5 },
    tab_max_width = 25,
    force_reverse_video_cursor = true,
    colors = {
        foreground = colors.fg,
        background = colors.bg,
        ansi = colors_normal,
        -- cursor_fg = colors.cursor,
        -- cursor_bg = colors.cursor,
        -- cursor_border = colors.cursor,
        brights = colors_bright,
        tab_bar = {
            background = colors.bg,
            active_tab = {
                bg_color = colors.black,
                fg_color = colors.fg,
                intensity = "Bold",
            },
            inactive_tab = {
                bg_color = "#282828",
                fg_color = colors.fg,
            },
            inactive_tab_hover = {
                bg_color = "#282828",
                fg_color = colors.fg,
                -- italic = true,
            },
        },
    },
    leader = { key="k", mods="CTRL" },
    keys = {
        { key = "a",          mods = "CTRL",        action=wezterm.action{SendString="\x01"}},
        { key = "h",          mods = "CTRL",        action=wezterm.action{SplitVertical={domain="CurrentPaneDomain"}}},
        { key = "v",          mods = "CTRL",        action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}}},
        { key = "z",          mods = "CTRL",        action="TogglePaneZoomState" },
        { key = "+",          mods = "CTRL",        action="IncreaseFontSize"},
        { key = "l",          mods = "CTRL",        action=wezterm.action{ClearScrollback="ScrollbackAndViewport"}},
        { key = "t",          mods = "CTRL|SHIFT",  action=wezterm.action{SpawnTab="CurrentPaneDomain"}},
        { key = "LeftArrow",  mods = "CTRL",        action=wezterm.action{ActivatePaneDirection="Left"}},
        { key = "DownArrow",  mods = "CTRL",        action=wezterm.action{ActivatePaneDirection="Down"}},
        { key = "UpArrow",    mods = "CTRL",        action=wezterm.action{ActivatePaneDirection="Up"}},
        { key = "RightArrow", mods = "CTRL",        action=wezterm.action{ActivatePaneDirection="Right"}},
        { key = "LeftArrow",  mods = "CTRL|SHIFT",  action=wezterm.action{AdjustPaneSize={"Left", 5}}},
        { key = "DownArrow",  mods = "CTRL|SHIFT",  action=wezterm.action{AdjustPaneSize={"Down", 5}}},
        { key = "UpArrow",    mods = "CTRL|SHIFT",  action=wezterm.action{AdjustPaneSize={"Up", 5}}},
        { key = "RightArrow", mods = "CTRL|SHIFT",  action=wezterm.action{AdjustPaneSize={"Right", 5}}},
        { key = "1",          mods = "CTRL",        action=wezterm.action{ActivateTab=0}},
        { key = "2",          mods = "CTRL",        action=wezterm.action{ActivateTab=1}},
        { key = "3",          mods = "CTRL",        action=wezterm.action{ActivateTab=2}},
        { key = "4",          mods = "CTRL",        action=wezterm.action{ActivateTab=3}},
        { key = "5",          mods = "CTRL",        action=wezterm.action{ActivateTab=4}},
        { key = "6",          mods = "CTRL",        action=wezterm.action{ActivateTab=5}},
        { key = "7",          mods = "CTRL",        action=wezterm.action{ActivateTab=6}},
        { key = "8",          mods = "CTRL",        action=wezterm.action{ActivateTab=7}},
        { key = "9",          mods = "CTRL",        action=wezterm.action{ActivateTab=8}},
        { key = "&",          mods = "CTRL|SHIFT",  action=wezterm.action{CloseCurrentTab={confirm=true}}},
        { key = "q",          mods = "CTRL",        action=wezterm.action{CloseCurrentPane={confirm=true}}},
        { key = "Tab",        mods = "CTRL",        action=wezterm.action{ActivateTabRelative=1}},
        { key = "Tab",        mods = "CTRL|SHIFT",  action=wezterm.action{ActivateTabRelative=-1}},
    },
    show_tab_index_in_tab_bar = false,
    hide_tab_bar_if_only_one_tab = true,
    exit_behavior = "Close",
    window_background_opacity = 0.5,
    default_prog = {"{{shell}}"},
}
