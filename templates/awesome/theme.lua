local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gears = require("gears")
local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

local theme = {}

theme.font = "{{font}} 11"
theme.bg_focus = "{{base03}}"
theme.bg_urgent = "{{base08}}"
theme.bg_minimize = "{{base01}}"
theme.bg_normal = "{{base02}}"
theme.fg_normal = "{{base06}}"
theme.fg_focus = "{{base06}}"
theme.tasklist_shape = gears.shape.rounded_bar
theme.tasklist_spacing = 10
theme.taglist_spacing = 2
theme.taglist_bg_focus = theme.bg_focus
theme.taglist_bg_urgent = "{{base06}}"
theme.taglist_fg_urgent = "{{base03}}"
theme.taglist_bg_occupied = "{{base04}}"
theme.useless_gap = dpi(5)
theme.border_width = dpi(1)
theme.border_normal = "{{base02}}"
theme.border_focus = "{{base04}}"
theme.border_marked = "{{base08}}"
theme.menu_height = dpi(15)
theme.menu_width = dpi(100)
theme.wallpaper = gears.filesystem.get_configuration_dir() .. "background.jpg"

local config_dir = gears.filesystem.get_configuration_dir()
-- You can use your own layout icons like this:
theme.layout_fairh = config_dir .. "icons/fairh.png"
theme.layout_fairv = config_dir .. "icons/fairv.png"
theme.layout_floating = config_dir .. "icons/floating.png"
theme.layout_magnifier = config_dir .. "icons/magnifier.png"
theme.layout_max = config_dir .. "icons/max.png"
theme.layout_tilebottom = config_dir .. "icons/tilebottom.png"
theme.layout_tileleft = config_dir .. "icons/tileleft.png"
theme.layout_tile = config_dir .. "icons/tile.png"
theme.layout_tiletop = config_dir .. "icons/tiletop.png"

-- Define the image to load
theme.titlebar_close_button_normal = config_dir ..
                                         "icons/titlebar/close_normal.png"
theme.titlebar_close_button_focus = config_dir ..
                                        "icons/titlebar/close_focus.png"
theme.titlebar_minimize_button_normal = config_dir ..
                                            "icons/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus = config_dir ..
                                           "icons/titlebar/minimize_focus.png"
theme.titlebar_minimize_button_active = config_dir ..
                                            "icons/titlebar/minimize_focus.png"
theme.titlebar_maximized_button_normal_inactive =
    config_dir .. "icons/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive =
    config_dir .. "icons/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active =
    config_dir .. "icons/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active =
    config_dir .. "default/titlebar/maximized_focus_active.png"
theme.tooltip_bg = "{{base02}}"
theme.tooltip_fg = "{{base06}}"
theme.tooltip_border_width = 0
theme.tooltip_shape = gears.shape.rounded_rect

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
