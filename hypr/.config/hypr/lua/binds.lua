local terminal = "~/.config/khypr/launchers/launch-terminal.sh"
local fileManager = "~/.config/khypr/launchers/launch-file-manager.sh"
local menu = "~/.config/khypr/launchers/launch-launcher.sh"
local browser = "~/.config/khypr/launchers/launch-browser.sh"
local scripts = "~/.config/khypr/scripts"

local mainMod = "SUPER"

hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("uwsm app -- " .. terminal))
hl.bind(
	mainMod .. " + SHIFT + T",
	hl.dsp.exec_cmd("uwsm app -- " .. terminal, { float = true, center = true, size = "1000 800" })
)
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + F4", hl.dsp.exec_cmd("uwsm stop"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("uwsm app -- " .. fileManager))
hl.bind(
	mainMod .. " + SHIFT + E",
	hl.dsp.exec_cmd("uwsm app -- " .. fileManager, { float = true, center = true, size = "1000 800" })
)
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("uwsm app -- " .. browser))
hl.bind(mainMod .. " + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd('pkill -fx "' .. menu .. '" || ' .. menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + M", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind(mainMod .. " + G", hl.dsp.layout("togglesplit"))
hl.bind(
	mainMod .. " + V",
	hl.dsp.exec_cmd("cliphist list | rofi -dmenu -display-columns 2 | cliphist decode | wl-copy")
)
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd("rofi -show calc -modi calc -no-show-match -no-sort | wl-copy"))

hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + SHIFT + h", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + l", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + k", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + j", hl.dsp.window.move({ direction = "down" }))

hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.resize({ x = 40, y = 0, relative = true }))
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.resize({ x = -40, y = 0, relative = true }))
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.resize({ x = 0, y = -40, relative = true }))
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.resize({ x = 0, y = 40, relative = true }))

for i = 1, 10 do
	local key = i % 10
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("hyprshot -m region"))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("hyprshot -m output"))

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind(
	mainMod .. " + SHIFT + mouse_down",
	hl.dsp.exec_cmd(
		[[hyprctl keyword cursor:zoom_factor $(awk "BEGIN {print $(hyprctl getoption cursor:zoom_factor | grep 'float:' | awk '{print $2}') + 0.5}")]]
	)
)
hl.bind(
	mainMod .. " + SHIFT + mouse_up",
	hl.dsp.exec_cmd(
		[[hyprctl keyword cursor:zoom_factor $(awk "BEGIN {print $(hyprctl getoption cursor:zoom_factor | grep 'float:' | awk '{print $2}') - 0.5}")]]
	)
)
hl.bind(mainMod .. " + SHIFT + Z", hl.dsp.exec_cmd("hyprctl keyword cursor:zoom_factor 1"))

hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd(scripts .. "/volume.sh output up 5"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd(scripts .. "/volume.sh output down 5"),
	{ locked = true, repeating = true }
)
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(scripts .. "/volume.sh output toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(scripts .. "/volume.sh input toggle"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(scripts .. "/brightness.sh up 5"), { locked = true, repeating = true })
hl.bind(
	"XF86MonBrightnessDown",
	hl.dsp.exec_cmd(scripts .. "/brightness.sh down 5"),
	{ locked = true, repeating = true }
)
hl.bind("XF86RefreshRateToggle", hl.dsp.exec_cmd(scripts .. "/toggle_refresh_rate.sh"), { release = true })

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

hl.bind("ALT + TAB", hl.dsp.window.cycle_next({ next = true }))
hl.bind("ALT + SHIFT + TAB", hl.dsp.window.cycle_next({ next = false }))
