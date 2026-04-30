local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.font_size = 13
config.font = wezterm.font("monospace")

-- config.colors = {
-- 	foreground = "#C0CAF5",
-- 	background = "#000008",
-- }

config.color_scheme = "Catppuccin Mocha"
-- config.front_end = "Software"

config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false

-- config.window_background_opacity = 0

config.window_close_confirmation = "NeverPrompt"

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

config.mouse_bindings = {
	-- Disable the default click behavior
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "NONE",
		action = wezterm.action.CompleteSelection("ClipboardAndPrimarySelection"),
	},
	-- Ctrl-click will open the link under the mouse cursor
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = wezterm.action.OpenLinkAtMouseCursor,
	},
	-- Disable the Ctrl-click down event to stop programs from seeing it when a URL is clicked
	{
		event = { Down = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = wezterm.action.Nop,
	},
}

-- config.saturation = 1.0 -- Default is often 0.9, making it look "grayer"
-- -- Add this line to hide the top bar:
-- config.window_decorations = "RESIZE"

return config
