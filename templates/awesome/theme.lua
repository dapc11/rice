local xresources = require("beautiful.xresources")
local gears = require("gears")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir() .. "/icons/"

local theme = {}
local font_size = 11
theme.modkey = "Mod4"
theme.terminal = "alacritty"

theme.font = "{{font}} " .. font_size
theme.wallpaper = os.getenv("HOME") .. "/.local/background.jpg"
-- Background
theme.bg_normal = "{{base01}}"
theme.bg_dark = "{{base00}}"
theme.bg_focus = "{{base02}}"
theme.bg_urgent = "{{base08}}"
theme.bg_minimize = "{{base03}}"

-- Foreground
theme.fg_normal = "{{base06}}"
theme.fg_focus = ""
theme.fg_urgent = "{{base00}}"
theme.fg_minimize = "{{base05}}"

-- Window Gap Distance
theme.useless_gap = dpi(7)

-- Do Not Show Gaps if Only One Client is Visible
theme.gap_single_client = false

-- Window Borders
theme.border_width = dpi(1)
theme.border_normal = theme.bg_normal
theme.border_focus = "{{base04}}"
theme.border_marked = theme.fg_urgent

-- Tasklist
theme.tasklist_font = theme.font

-- Notifications
theme.notification_max_width = dpi(500)
theme.notification_bg = "{{base01}}"
theme.notification_shape = gears.shape.rounded_rect
theme.notification_font = theme.font

-- System Tray
theme.bg_systray = theme.bg_normal
theme.systray_icon_spacing = dpi(5)

-- Titlebars
theme.titlebars_enabled = false
-- Define the image to load
theme.titlebar_close_button_normal = themes_path .. "titlebar/close_normal.png"
theme.titlebar_close_button_focus = themes_path .. "titlebar/close_focus.png"

theme.titlebar_minimize_button_normal = themes_path .. "titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus = themes_path .. "titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive = themes_path .. "titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive = themes_path .. "titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = themes_path .. "titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active = themes_path .. "titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = themes_path .. "titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive = themes_path .. "titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = themes_path .. "titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active = themes_path .. "titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = themes_path .. "titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive = themes_path .. "titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = themes_path .. "titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active = themes_path .. "titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = themes_path .. "titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive = themes_path .. "titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = themes_path .. "titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active = themes_path .. "titlebar/maximized_focus_active.png"

return theme
