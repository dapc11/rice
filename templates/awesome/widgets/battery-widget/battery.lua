local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local naughty = require("naughty")
local watch = require("awful.widget.watch")
local wibox = require("wibox")
local gfs = require("gears.filesystem")
local gs = require("gears.shape")

-- acpi sample outputs
-- Battery 0: Discharging, 75%, 01:51:38 remaining
-- Battery 0: Charging, 53%, 00:57:43 until charged

local HOME = os.getenv("HOME")
local WIDGET_DIR = HOME .. "/.config/awesome/widgets/battery-widget/"
local ICON_DIR = HOME .. "/.config/awesome/icons/battery/"

local battery_widget = {}
local function worker(user_args)
	local args = user_args or {}

	local path_to_icons = ICON_DIR
	local show_current_level = args.show_current_level or false
	local margin_left = args.margin_left or 0
	local margin_right = args.margin_right or 0

	local display_notification = args.display_notification or false
	local display_notification_onClick = args.display_notification_onClick or true
	local timeout = args.timeout or 10

	local warning_msg_title = args.warning_msg_title or "Huston, we have a problem"
	local warning_msg_text = args.warning_msg_text or "Battery is dying"
	local warning_msg_position = args.warning_msg_position or "bottom_right"
	local warning_msg_icon = args.warning_msg_icon or WIDGET_DIR .. "/spaceman.jpg"
	local enable_battery_warning = args.enable_battery_warning
	if enable_battery_warning == nil then
		enable_battery_warning = true
	end

	if not gfs.dir_readable(path_to_icons) then
		naughty.notify({
			title = "Battery Widget",
			text = "Folder with icons doesn't exist: " .. path_to_icons,
			preset = naughty.config.presets.critical,
		})
	end

	local icon_widget = wibox.widget({
		{
			id = "icon",
			widget = wibox.widget.imagebox,
			resize = false,
		},
		valign = "center",
		layout = wibox.container.place,
	})
	local level_widget = wibox.widget({
		widget = wibox.widget.textbox,
	})

	battery_widget = wibox.widget({
		icon_widget,
		level_widget,
		layout = wibox.layout.fixed.horizontal,
	})
	-- Popup with battery info
	-- One way of creating a pop-up notification - naughty.notify
	local popup = awful.popup({
		ontop = true,
		visible = false,
		shape = function(cr, width, height)
			gears.shape.rounded_rect(cr, width, height)
		end,
		border_width = 1,
		border_color = beautiful.bg_focus,
		maximum_width = 400,
		offset = { y = 5 },
		widget = {},
	})
	local notification
	local function build_header_row(text)
		return wibox.widget({
			{
				text = text,
				align = "center",
				widget = wibox.widget.textbox,
			},
			bg = beautiful.bg_normal,
			widget = wibox.container.background,
		})
	end
	local function show_battery_status(batteryType)
		local rows = { layout = wibox.layout.fixed.vertical }

		awful.spawn.easy_async([[bash -c 'acpi']], function(stdout, _, _, _)
			for i = 0, #rows do
				rows[i] = nil
			end

			table.insert(rows, build_header_row("Battery Status"))

			local row = wibox.widget({
				{
					{
						{
							image = path_to_icons .. batteryType .. ".svg",
							resize = false,
							widget = wibox.widget.imagebox,
						},
						{
							text = stdout,
							widget = wibox.widget.textbox,
						},
						spacing = 12,
						layout = wibox.layout.fixed.horizontal,
					},
					margins = 8,
					layout = wibox.container.margin,
				},
				bg = beautiful.bg_normal,
				widget = wibox.container.background,
			})

			row:connect_signal("mouse::enter", function(c)
				c:set_bg(beautiful.bg_focus)
			end)
			row:connect_signal("mouse::leave", function(c)
				c:set_bg(beautiful.bg_normal)
			end)

			local old_cursor, old_wibox
			row:connect_signal("mouse::enter", function()
				local wb = mouse.current_wibox
				old_cursor, old_wibox = wb.cursor, wb
				wb.cursor = "hand1"
			end)
			row:connect_signal("mouse::leave", function()
				if old_wibox then
					old_wibox.cursor = old_cursor
					old_wibox = nil
				end
			end)

			row:buttons(awful.util.table.join(awful.button({}, 1, function()
				popup.visible = not popup.visible
			end)))

			table.insert(rows, row)
			popup:setup(rows)
			popup:connect_signal("mouse::leave", function()
				if popup.visible then
					popup.visible = not popup.visible
				end
			end)
		end)
	end

	local function show_battery_warning()
		naughty.notify({
			shape = gs.rounded_rect,
			icon = warning_msg_icon,
			icon_size = 100,
			text = warning_msg_text,
			title = warning_msg_title,
			timeout = 25, -- show the warning for a longer time
			hover_timeout = 0.5,
			position = warning_msg_position,
			border_width = 1,
			border_color = beautiful.bg_focus,
			width = 300,
			screen = mouse.screen,
		})
	end
	local last_battery_check = os.time()
	local batteryType = "battery-good-symbolic"

	watch("acpi -i", timeout, function(widget, stdout)
		local battery_info = {}
		local capacities = {}
		for s in stdout:gmatch("[^\r\n]+") do
			local status, charge_str, _ = string.match(s, ".+: (%a+), (%d?%d?%d)%%,?(.*)")
			if status ~= nil then
				table.insert(battery_info, { status = status, charge = tonumber(charge_str) })
			else
				local cap_str = string.match(s, ".+:.+last full capacity (%d+)")
				table.insert(capacities, tonumber(cap_str))
			end
		end

		local capacity = 0
		for _, cap in ipairs(capacities) do
			capacity = capacity + cap
		end

		local charge = 0
		local status
		for i, batt in ipairs(battery_info) do
			if capacities[i] ~= nil then
				if batt.charge >= charge then
					status = batt.status -- use most charged battery status
					-- this is arbitrary, and maybe another metric should be used
				end

				charge = charge + batt.charge * capacities[i]
			end
		end

		charge = charge / capacity

		if charge == 0 then
			charge = 100
		end

		if show_current_level then
			level_widget.text = string.format("%d%%", charge)
		end

		if charge >= 1 and charge < 15 then
			batteryType = "battery-empty%s-symbolic"
			if enable_battery_warning and status ~= "Charging" and os.difftime(os.time(), last_battery_check) > 300 then
				-- if 5 minutes have elapsed since the last warning
				last_battery_check = os.time()

				show_battery_warning()
			end
		elseif charge >= 15 and charge < 40 then
			batteryType = "battery-caution%s-symbolic"
		elseif charge >= 40 and charge < 60 then
			batteryType = "battery-low%s-symbolic"
		elseif charge >= 60 and charge < 80 then
			batteryType = "battery-good%s-symbolic"
		elseif charge >= 80 and charge <= 100 then
			batteryType = "battery-full%s-symbolic"
		end

		if status == "Charging" then
			batteryType = string.format(batteryType, "-charging")
		else
			batteryType = string.format(batteryType, "")
		end

		widget.icon:set_image(path_to_icons .. batteryType .. ".svg")

		-- Update popup text
		-- battery_popup.text = string.gsub(stdout, "\n$", "")
	end, icon_widget)

	if display_notification then
		battery_widget:connect_signal("mouse::enter", function()
			show_battery_status(batteryType)
		end)
		battery_widget:connect_signal("mouse::leave", function()
			naughty.destroy(notification)
		end)
	elseif display_notification_onClick then
		battery_widget:connect_signal("button::press", function(_, _, _, button)
			if button == 1 then
				show_battery_status(batteryType)
			end
		end)
		battery_widget:connect_signal("mouse::leave", function()
			naughty.destroy(notification)
		end)
	end

	battery_widget:buttons(awful.util.table.join(awful.button({}, 1, function()
		if popup.visible then
			popup.visible = not popup.visible
		else
			popup:move_next_to(mouse.current_widget_geometry)
		end
	end)))
	battery_widget:connect_signal("mouse::leave", function()
		if popup.visible then
			popup.visible = not popup.visible
		end
	end)

	return wibox.container.margin(battery_widget, margin_left, margin_right)
end

return setmetatable(battery_widget, {
	__call = function(_, ...)
		return worker(...)
	end,
})
