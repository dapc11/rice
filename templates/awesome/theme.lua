local assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local filesystem = require("gears.filesystem")
local themes_path = filesystem.get_themes_dir()

local theme = {}
local font_size = 11
theme.font = "{{font}} " .. font_size
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
theme.border_focus = "{{base02}}"
theme.border_marked = theme.fg_urgent

-- Tasklist
theme.tasklist_font = theme.font

-- Notification Sizing
theme.notification_max_width = dpi(350)

-- System Tray
theme.bg_systray = theme.bg_normal
theme.systray_icon_spacing = dpi(5)

-- Titlebars
theme.titlebars_enabled = false

return theme
