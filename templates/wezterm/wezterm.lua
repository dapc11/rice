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
	cursor = "{{base66}}",
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
	font = wezterm.font("Sauce Code Pro Nerd Font"),
	font_size = 10,
	window_close_confirmation = "NeverPrompt",
	window_padding = { left = 5, right = 5, top = 5, bottom = 5 },
	tab_max_width = 25,
	colors = {
		foreground = colors.fg,
		background = colors.bg,
		ansi = colors_normal,
		brights = colors_bright,
		tab_bar = {
			background = "{{base01}}",
			active_tab = {
				bg_color = "{{base03}}",
				fg_color = "{{base00}}",
			},
			inactive_tab = {
				bg_color = "{{base01}}",
				fg_color = colors.fg,
			},
			inactive_tab_hover = {
				bg_color = "{{base02}}",
				fg_color = colors.fg,
				italic = true,
			},
			new_tab = {
				bg_color = "{{base03}}",
				fg_color = "{{base00}}",
				bold = true,
			},
			new_tab_hover = {
				bg_color = "{{base04}}",
				fg_color = "{{base00}}",
				italic = true,
			},
		},
	},
	leader = { key = "ö", mods = "CTRL" },
	keys = {
		{ key = "a", mods = "ALT", action = wezterm.action({ SendString = "\x01" }) },
		{
			key = "h",
			mods = "ALT",
			action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }),
		},
		{
			key = "v",
			mods = "ALT",
			action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }),
		},
		{ key = "z", mods = "ALT", action = "TogglePaneZoomState" },
		{ key = "+", mods = "ALT", action = "IncreaseFontSize" },
		{ key = "l", mods = "ALT", action = wezterm.action({ ClearScrollback = "ScrollbackAndViewport" }) },
		{ key = "t", mods = "CTRL", action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }) },
		{ key = "LeftArrow", mods = "ALT", action = wezterm.action({ ActivatePaneDirection = "Left" }) },
		{ key = "DownArrow", mods = "ALT", action = wezterm.action({ ActivatePaneDirection = "Down" }) },
		{ key = "UpArrow", mods = "ALT", action = wezterm.action({ ActivatePaneDirection = "Up" }) },
		{ key = "RightArrow", mods = "ALT", action = wezterm.action({ ActivatePaneDirection = "Right" }) },
		{ key = "LeftArrow", mods = "ALT|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Left", 5 } }) },
		{ key = "DownArrow", mods = "ALT|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Down", 5 } }) },
		{ key = "UpArrow", mods = "ALT|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Up", 5 } }) },
		{ key = "RightArrow", mods = "ALT|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Right", 5 } }) },
		{ key = "1", mods = "ALT", action = wezterm.action({ ActivateTab = 0 }) },
		{ key = "2", mods = "ALT", action = wezterm.action({ ActivateTab = 1 }) },
		{ key = "3", mods = "ALT", action = wezterm.action({ ActivateTab = 2 }) },
		{ key = "4", mods = "ALT", action = wezterm.action({ ActivateTab = 3 }) },
		{ key = "5", mods = "ALT", action = wezterm.action({ ActivateTab = 4 }) },
		{ key = "6", mods = "ALT", action = wezterm.action({ ActivateTab = 5 }) },
		{ key = "7", mods = "ALT", action = wezterm.action({ ActivateTab = 6 }) },
		{ key = "8", mods = "ALT", action = wezterm.action({ ActivateTab = 7 }) },
		{ key = "9", mods = "ALT", action = wezterm.action({ ActivateTab = 8 }) },
		{ key = "&", mods = "ALT|SHIFT", action = wezterm.action({ CloseCurrentTab = { confirm = true } }) },
		{ key = "q", mods = "ALT", action = wezterm.action({ CloseCurrentPane = { confirm = true } }) },
		{ key = "Tab", mods = "CTRL", action = wezterm.action({ ActivateTabRelative = 1 }) },
		{ key = "Tab", mods = "CTRL|SHIFT", action = wezterm.action({ ActivateTabRelative = -1 }) },
	},
	show_tab_index_in_tab_bar = false,
	hide_tab_bar_if_only_one_tab = true,
	exit_behavior = "Close",
	window_background_opacity = 0.92,
	default_prog = { "{{shell}}" },
}
