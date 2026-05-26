hl.window_rule({
	name = "suppress-maximize-events",
	match = { class = ".*" },
	suppress_event = "maximize",
})

hl.window_rule({
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},
	no_focus = true,
})

hl.window_rule({
	name = "move-hyprland-run",
	match = { class = "hyprland-run" },
	move = "20 monitor_h-120",
	float = true,
})

-- Make windows with this class float
hl.window_rule({
	name = "floating-center-window",
	match = { class = "floating-center-window" },
	float = true,
	center = true,
	size = "1400 1200",
})

-- -- Make Thunar Rename dialog floating
-- hl.window_rule({
-- 	match = {
-- 		class = "^(Thunar)$",
-- 		title = "^(.*[Rr]ename.*)$",
-- 	},
-- 	float = true,
-- 	center = true,
-- })
