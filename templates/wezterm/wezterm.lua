local wezterm = require("wezterm")
local act = wezterm.action

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
	cursor = "{{base06}}",
}

local function make_mouse_binding(dir, streak, button, mods, action)
	return {
		event = { [dir] = { streak = streak, button = button } },
		mods = mods,
		action = action,
	}
end

return {
	font = wezterm.font_with_fallback({
		"Liga SFMono Nerd Font",
		"SauceCodePro Nerd Font",
		"SF Pro Display",
		"JetBrains Mono",
		"Apple Color Emoji",
	}),
	adjust_window_size_when_changing_font_size = false,
	color_scheme = "OneDark (base16)",
	hide_tab_bar_if_only_one_tab = true,
	exit_behavior = "Close",
	window_background_opacity = 1,
	default_prog = { "{{shell}}" },
	font_size = 11,
	max_fps = 120,
	scrollback_lines = 99999,
	enable_wayland = false,
	pane_focus_follows_mouse = true,
	warn_about_missing_glyphs = false,
	show_update_window = false,
	check_for_updates = false,
	window_decorations = "RESIZE",
	audible_bell = "Disabled",
	window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},
	initial_cols = 110,
	initial_rows = 25,
	inactive_pane_hsb = {
		saturation = 1.0,
		brightness = 0.90,
	},
	enable_scroll_bar = true,
	tab_bar_at_bottom = true,
	use_fancy_tab_bar = false,
	show_new_tab_button_in_tab_bar = true,
	tab_max_width = 50,
	disable_default_key_bindings = false,
	window_close_confirmation = "NeverPrompt",
	colors = {
		background = colors.bg,
		tab_bar = {
			background = colors.bg,
			active_tab = {
				bg_color = "{{base02}}",
				fg_color = colors.fg,
				intensity = "Bold",
				underline = "None",
				italic = false,
				strikethrough = false,
			},
			inactive_tab = {
				bg_color = colors.bg,
				fg_color = colors.fg,
			},
			inactive_tab_hover = {
				bg_color = "{{base02}}",
				fg_color = colors.fg,
			},
		},
	},
	keys = {
		{ key = "s", mods = "ALT", action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
		{ key = "v", mods = "ALT", action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
		{ key = "z", mods = "ALT", action = "TogglePaneZoomState" },
		{ key = "+", mods = "ALT", action = "IncreaseFontSize" },
		{ key = "l", mods = "ALT", action = wezterm.action({ ClearScrollback = "ScrollbackAndViewport" }) },
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
		{ key = "c", mods = "CTRL|SHIFT", action = wezterm.action({ CopyTo = "Clipboard" }) },
		{ key = "v", mods = "CTRL|SHIFT", action = wezterm.action({ PasteFrom = "Clipboard" }) },
		{ key = "&", mods = "ALT|SHIFT", action = wezterm.action({ CloseCurrentTab = { confirm = true } }) },
		{ key = "q", mods = "CTRL|ALT", action = wezterm.action({ CloseCurrentPane = { confirm = true } }) },
		{ key = "Tab", mods = "ALT", action = wezterm.action({ ActivateTabRelative = 1 }) },
		{ key = "Tab", mods = "CTRL|SHIFT", action = wezterm.action({ ActivateTabRelative = -1 }) },
		{ key = "t", mods = "ALT", action = act.SpawnTab("CurrentPaneDomain") },
		{ key = "b", mods = "CTRL", action = act.RotatePanes("CounterClockwise") },
		{ key = "z", mods = "ALT", action = wezterm.action.TogglePaneZoomState },
		{ key = "n", mods = "CTRL", action = act.RotatePanes("Clockwise") },
		{ key = "w", mods = "ALT", action = wezterm.action.CloseCurrentPane({ confirm = true }) },
	},
	hyperlink_rules = {
		{
			regex = "\\b\\w+://[\\w.-]+:[0-9]{2,15}\\S*\\b",
			format = "$0",
		},
		{
			regex = "\\b\\w+://[\\w.-]+\\.[a-z]{2,15}\\S*\\b",
			format = "$0",
		},
		{
			regex = [[\b\w+@[\w-]+(\.[\w-]+)+\b]],
			format = "mailto:$0",
		},
		{
			regex = [[\bfile://\S*\b]],
			format = "$0",
		},
		{
			regex = [[\b\w+://(?:[\d]{1,3}\.){3}[\d]{1,3}\S*\b]],
			format = "$0",
		},
		{
			regex = [[\b[tT](\d+)\b]],
			format = "https://example.com/tasks/?t=$1",
		},
	},
	mouse_bindings = {
		make_mouse_binding(
			"Up",
			1,
			"Left",
			"NONE",
			wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor("ClipboardAndPrimarySelection")
		),
		make_mouse_binding(
			"Up",
			1,
			"Left",
			"SHIFT",
			wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor("ClipboardAndPrimarySelection")
		),
		make_mouse_binding("Up", 1, "Left", "ALT", wezterm.action.CompleteSelection("ClipboardAndPrimarySelection")),
		make_mouse_binding(
			"Up",
			1,
			"Left",
			"SHIFT|ALT",
			wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor("ClipboardAndPrimarySelection")
		),
		make_mouse_binding("Up", 2, "Left", "NONE", wezterm.action.CompleteSelection("ClipboardAndPrimarySelection")),
		make_mouse_binding("Up", 3, "Left", "NONE", wezterm.action.CompleteSelection("ClipboardAndPrimarySelection")),
	},
}
