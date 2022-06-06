local gears = require("gears")
local awful = require("awful")
local m = {}
function m.create(screen)
	return awful.widget.tasklist({
		screen = screen,
		filter = awful.widget.tasklist.filter.currenttags,
		style = {
			fg_normal = "{{base03}}",
			bg_normal = "{{base01}}",
			fg_focus = "{{base06}}",
			bg_focus = "{{base01}}",
			fg_urgent = "{{base02}}",
			bg_urgent = "{{base08}}",
			fg_minimize = "{{base01}}",
			bg_minimize = "{{base01}}",
			spacing = 1,
			tasklist_disable_icon = true,
			shape = gears.shape.rounded_rect,
		},
	})
end

return m
