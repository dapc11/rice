---@diagnostic disable: undefined-global
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- Widgets
local battery_widget = require("widgets.battery-widget.battery")
local docker_widget = require("widgets.docker-widget.docker")
local volume_widget = require("widgets.volume-widget.volume")
local logout_menu_widget = require("widgets.logout-menu-widget.logout-menu")

--  Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
	naughty.notify({
		preset = naughty.config.presets.critical,
		title = "Oops, there were errors during startup!",
		text = awesome.startup_errors,
	})
end

-- Handle runtime errors after startup
do
	local in_error = false
	awesome.connect_signal("debug::error", function(err)
		-- Make sure we don't go into an endless error loop
		if in_error then
			return
		end
		in_error = true

		naughty.notify({
			preset = naughty.config.presets.critical,
			title = "Oops, an error happened!",
			text = tostring(err),
		})
		in_error = false
	end)
end
--

--  Variable definitions
-- Themes define colours, icons, font and wallpapers.
-- local file = io.open("/home/dapc/awesome.log", "w")
-- file:write(gears.filesystem.get_themes_dir() .. "default/theme.lua")
-- file:close()
local theme_path = os.getenv("HOME") .. "/.config/awesome/theme.lua"
if not beautiful.init(theme_path) then
	error("Unable to load " .. theme_path)
end
local theme = require("theme")
local terminal = "alacritty"
local modkey = "Mod4"

awful.layout.layouts = {
	awful.layout.suit.tile,
	awful.layout.suit.tile.bottom,
	awful.layout.suit.floating,
	awful.layout.suit.fair,
	awful.layout.suit.max,
	awful.layout.suit.magnifier,
}

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it

--  Wibar
-- Create a textclock widget
local mytextclock = wibox.widget.textclock("   %Y-%m-%d  %H:%M:%S", 1)

local function set_wallpaper(s)
	if beautiful.wallpaper then
		local wallpaper = beautiful.wallpaper
		-- If wallpaper is a function, call it with the screen
		if type(wallpaper) == "function" then
			wallpaper = wallpaper(s)
		end
		gears.wallpaper.maximized(wallpaper, s, true)
	end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

local separator = wibox.widget({
	font = font,
	text = "|",
	opacity = 0.3,
	forced_width = 20,
	valign = "center",
	align = "center",
	widget = wibox.widget.textbox,
})

awful.screen.connect_for_each_screen(function(s)
	set_wallpaper(s)

	-- Each screen has its own tag table.
	awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])
	s.mypromptbox = awful.widget.prompt()
	-- Create an imagebox widget which will contain an icon indicating which layout we're using.
	-- We need one layoutbox per screen.
	s.mylayoutbox = awful.widget.layoutbox(s)
	s.mylayoutbox:buttons(gears.table.join(
		awful.button({}, 1, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 3, function()
			awful.layout.inc(-1)
		end),
		awful.button({}, 4, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 5, function()
			awful.layout.inc(-1)
		end)
	))

	s.mytaglist = require("taglist").create(s)
	s.mytasklist = awful.widget.tasklist({
		screen = s,
		filter = awful.widget.tasklist.filter.currenttags,
		buttons = tasklist_buttons,
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

	s.mywibox = awful.wibar({
		position = "top",
		screen = s,
	})

	-- Add widgets to the wibox
	s.mywibox:setup({
		layout = wibox.layout.align.horizontal,
		expand = "none",
		{ -- Left widgets
			layout = wibox.layout.fixed.horizontal,
			spacing = 20,
			{ layout = wibox.layout.fixed.horizontal },
			{ layout = wibox.layout.fixed.horizontal, spacing = 5, s.mylayoutbox, s.mytaglist },
			s.mypromptbox,
		},
		{
			layout = wibox.layout.flex.horizontal,
			s.mytasklist, -- Middle widget
		},
		{ -- Right widgets
			layout = wibox.layout.fixed.horizontal,
			volume_widget({
				font = "{{font}} 11",
				unselected = "{{base03}}",
				selected = "{{base08}}",
			}),
			separator,
			docker_widget({}),
			separator,
			battery_widget({
				font = "{{font}} 11",
				show_current_level = true,
			}),
			separator,
			mytextclock,
			separator,
			wibox.widget.systray(),
			separator,
			logout_menu_widget(),
		},
	})
end)

root.buttons(gears.table.join(awful.button({}, 4, awful.tag.viewnext), awful.button({}, 5, awful.tag.viewprev)))

local keybinds = require("keybinds")

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
local globalkeys
for i = 1, 9 do
	globalkeys = gears.table.join(
		keybinds.globalkeys, -- View tag only.
		awful.key({ modkey }, "#" .. i + 9, function()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				tag:view_only()
			end
		end, {
			description = "view tag #" .. i,
			group = "tag",
		}), -- Toggle tag display.
		awful.key({ modkey, "Control" }, "#" .. i + 9, function()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				awful.tag.viewtoggle(tag)
			end
		end, {
			description = "toggle tag #" .. i,
			group = "tag",
		}), -- Move client to tag.
		awful.key({ modkey, "Shift" }, "#" .. i + 9, function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
		end, {
			description = "move focused client to tag #" .. i,
			group = "tag",
		}), -- Toggle tag on focused client.
		awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9, function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:toggle_tag(tag)
				end
			end
		end, {
			description = "toggle focused client on tag #" .. i,
			group = "tag",
		})
	)
end

local clientbuttons = gears.table.join(
	awful.button({}, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", {
			raise = true,
		})
	end),
	awful.button({ modkey }, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", {
			raise = true,
		})
		awful.mouse.client.move(c)
	end),
	awful.button({ modkey }, 3, function(c)
		c:emit_signal("request::activate", "mouse_click", {
			raise = true,
		})
		awful.mouse.client.resize(c)
	end)
)

-- Set keys
root.keys(globalkeys)

--  Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = { -- All clients will match this rule.
	{
		rule = {},
		properties = {
			border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			focus = awful.client.focus.filter,
			raise = true,
			keys = keybinds.clientkeys,
			buttons = clientbuttons,
			screen = awful.screen.preferred,
			placement = awful.placement.no_overlap + awful.placement.no_offscreen,
		},
	}, -- Floating clients.
	{
		rule_any = {
			instance = {
				"DTA", -- Firefox addon DownThemAll.
				"copyq", -- Includes session name in class.
				"pinentry",
			},
			class = {
				"Arandr",
				"Blueman-manager",
				"Gpick",
				"Kruler",
				"MessageWin", -- kalarm.
				"Sxiv",
				"Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
				"Wpa_gui",
				"veromix",
				"xtightvncviewer",
				"rofi",
				"Rofi",
			},
			-- Note that the name property shown in xprop might be set slightly after creation of the client
			-- and the name shown there might not match defined rules here.
			name = {
				"Event Tester", -- xev.
			},
			role = {
				"AlarmWindow", -- Thunderbird's calendar.
				"ConfigManager", -- Thunderbird's about:config.
				"pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
			},
		},
		properties = {
			floating = true,
		},
	}, -- Add titlebars to normal clients and dialogs
	{
		rule_any = {
			type = { "normal", "dialog" },
		},
		properties = {
			titlebars_enabled = theme.titlebars_enabled,
		},
	},
	{
		rule = {
			class = "Google-chrome",
		},
		properties = {
			screen = 1,
			tag = "2",
		},
	},
	{
		rule = {
			class = "Firefox",
		},
		properties = {
			screen = 1,
			tag = "2",
		},
	},
	{
		rule = {
			class = "Evolution",
		},
		properties = {
			screen = 1,
			tag = "1",
		},
	},
	{
		rule = {
			class = "Jetbrains-idea-ce",
		},
		properties = {
			screen = 1,
			tag = "3",
		},
	},
	{
		rule = {
			class = "Jetbrains-pycharm-ce",
		},
		properties = {
			screen = 1,
			tag = "3",
		},
	},
	{
		rule = {
			class = "Wfica",
		},
		properties = {
			screen = 1,
			tag = "6",
		},
	},
	{
		rule = {
			class = "wfica",
		},
		properties = {
			screen = 1,
			tag = "6",
		},
	},
	{
		rule = {
			class = "Libreoffice-writer",
		},
		properties = {
			screen = 1,
			tag = "7",
		},
	},
	{
		rule = {
			class = "Thunar",
		},
		properties = {
			screen = 1,
			tag = "",
		},
	},
	{
		rule = {
			class = "PulseUi",
		},
		properties = {
			screen = 1,
			tag = "8",
		},
	},
	{
		rule = {
			class = "Pidgin",
		},
		properties = {
			screen = 1,
			tag = "9",
		},
	},
	{
		rule = {
			class = "Telegram",
		},
		properties = {
			screen = 1,
			tag = "9",
		},
	},
	{
		rule = {
			class = "Teams-for-linux",
		},
		properties = {
			screen = 1,
			tag = "9",
		},
	},
	{
		rule = {
			name = "Microsoft Teams Notification",
		},
		properties = {
			screen = 1,
			tag = "9",
		},
	},
}

--  Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
	-- Set the windows at the slave,
	-- i.e. put it at the end of others instead of setting it master.
	-- if not awesome.startup then awful.client.setslave(c) end

	if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
		-- Prevent clients from being unreachable after screen count changes.
		awful.placement.no_offscreen(c)
	end
end)

-- No border for maximized clients
local function border_adjust(c)
	if c.maximized then -- no borders if only 1 client visible
		c.border_width = 0
		c.shape = gears.shape.rectangle
	elseif #awful.screen.focused().clients > 1 then
		c.border_width = beautiful.border_width
		c.border_color = beautiful.border_focus
		c.shape = gears.shape.rounded_rect
	end
end

client.connect_signal("focus", border_adjust)
client.connect_signal("property::maximized", border_adjust)
client.connect_signal("unfocus", function(c)
	c.border_color = beautiful.border_normal
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
	-- buttons for the titlebar
	local buttons = gears.table.join(
		awful.button({}, 1, function()
			c:emit_signal("request::activate", "titlebar", {
				raise = true,
			})
			awful.mouse.client.move(c)
		end),
		awful.button({}, 3, function()
			c:emit_signal("request::activate", "titlebar", {
				raise = true,
			})
			awful.mouse.client.resize(c)
		end)
	)

	awful.titlebar(c):setup({
		{ -- Left
			awful.titlebar.widget.iconwidget(c),
			buttons = buttons,
			layout = wibox.layout.fixed.horizontal,
		},
		{ -- Middle
			{ -- Title
				align = "center",
				widget = awful.titlebar.widget.titlewidget(c),
			},
			buttons = buttons,
			layout = wibox.layout.flex.horizontal,
		},
		{ -- Right
			awful.titlebar.widget.floatingbutton(c),
			awful.titlebar.widget.maximizedbutton(c),
			awful.titlebar.widget.stickybutton(c),
			awful.titlebar.widget.ontopbutton(c),
			awful.titlebar.widget.closebutton(c),
			layout = wibox.layout.fixed.horizontal(),
		},
		layout = wibox.layout.align.horizontal,
	})
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
	c:emit_signal("request::activate", "mouse_enter", {
		raise = false,
	})
end)

client.connect_signal("focus", function(c)
	c.border_color = beautiful.border_focus
	c.skip_taskbar = false
end)
client.connect_signal("unfocus", function(c)
	c.border_color = beautiful.border_normal
	c.skip_taskbar = true
end)

awful.spawn.with_shell("dunst")
awful.spawn.with_shell("nm-applet")
awful.spawn.with_shell("picom")
