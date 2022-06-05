local gears = require("gears")
local awful = require("awful")
local awful = require("awful")
local wibox = require("wibox")
local theme = require("theme")
local m = {}

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
	awful.button({}, 1, function(t)
		t:view_only()
	end),
	awful.button({ theme.modkey }, 1, function(t)
		if client.focus then
			client.focus:move_to_tag(t)
		end
	end),
	awful.button({}, 3, awful.tag.viewtoggle),
	awful.button({ theme.modkey }, 3, function(t)
		if client.focus then
			client.focus:toggle_tag(t)
		end
	end),
	awful.button({}, 4, function(t)
		awful.tag.viewnext(t.screen)
	end),
	awful.button({}, 5, function(t)
		awful.tag.viewprev(t.screen)
	end)
)

function m.create(screen)
	return awful.widget.taglist({
		screen = screen,
		filter = awful.widget.taglist.filter.noempty,
		buttons = taglist_buttons,
		style = {
			fg_focus = "{{base06}}",
			bg_focus = "{{base03}}",
			fg_urgent = "{{base02}}",
			bg_urgent = "{{base08}}",
			bg_occupied = "{{base01}}",
			fg_occupied = "{{base05}}",
			bg_empty = nil,
			fg_empty = nil,
			spacing = 3,
			bg_volatile = "{{base0D}}",
			fg_volatile = "{{base01}}",
			shape = gears.shape.circle,
		},
		widget_template = {
			{
				{
					{
						{
							id = "icon_role",
							widget = wibox.widget.imagebox,
						},
						widget = wibox.container.margin,
					},
					{
						id = "text_role",
						widget = wibox.widget.textbox,
					},
					layout = wibox.layout.fixed.horizontal,
				},
				left = 7,
				right = 7,
				widget = wibox.container.margin,
			},
			id = "background_role",
			widget = wibox.container.background,
			-- Add support for hover colors and an index label
			create_callback = function(self, _, _, _)
				self:connect_signal("mouse::enter", function()
					if self.bg ~= "{{base04}}" then
						self.backup = self.bg
						self.has_backup = true
					end
					self.bg = "{{base04}}"
				end)
				self:connect_signal("mouse::leave", function()
					if self.has_backup then
						self.bg = self.backup
					end
				end)
			end,
		},
	})
end

return m
