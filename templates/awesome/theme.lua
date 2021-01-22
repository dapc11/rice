local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gears = require("gears")
local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

local theme = {}

theme.font                  = "{{font}} 11"
theme.bg_focus              = "{{base03}}"
theme.bg_urgent             = "{{base08}}"
theme.bg_minimize           = "{{base02}}"
theme.bg_normal             = "{{base02}}"
theme.fg_normal             = "{{base06}}"
theme.tasklist_shape        = gears.shape.rounded_bar
theme.tasklist_spacing      = 10
theme.taglist_spacing       = 2
theme.taglist_bg_focus      = "{{base0E}}"
theme.taglist_bg_urgent     = "{{base08}}"
theme.taglist_bg_occupied   = "{{base02}}"
theme.useless_gap           = dpi(5)
theme.border_width          = dpi(2)
theme.border_normal         = "{{base02}}"
theme.border_focus          = "{{base04}}"
theme.border_marked         = "{{base08}}"
theme.menu_height           = dpi(15)
theme.menu_width            = dpi(100)
theme.wallpaper = gears.filesystem.get_configuration_dir() .. "background.jpg"

-- You can use your own layout icons like this:
theme.layout_fairh = themes_path.."default/layouts/fairhw.png"
theme.layout_fairv = themes_path.."default/layouts/fairvw.png"
theme.layout_floating  = themes_path.."default/layouts/floatingw.png"
theme.layout_magnifier = themes_path.."default/layouts/magnifierw.png"
theme.layout_max = themes_path.."default/layouts/maxw.png"
theme.layout_tilebottom = themes_path.."default/layouts/tilebottomw.png"
theme.layout_tileleft   = themes_path.."default/layouts/tileleftw.png"
theme.layout_tile = themes_path.."default/layouts/tilew.png"
theme.layout_tiletop = themes_path.."default/layouts/tiletopw.png"
theme.layout_cornernw = themes_path.."default/layouts/cornernww.png"


return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
