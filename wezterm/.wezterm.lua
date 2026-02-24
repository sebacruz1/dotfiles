local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.window_background_opacity = 0.8
config.color_scheme = "Kanagawa (Gogh)"
config.font = wezterm.font("JetBrainsMono Nerd Font")

config.font_size = 13
config.line_height = 1.1

config.harfbuzz_features = {
	"calt=0",
	"clig=0",
	"liga=0",
	"zero",
}

config.window_decorations = "RESIZE"
config.macos_window_background_blur = 40
config.window_padding = {
	left = 2,
	right = 2,
	top = 5,
	bottom = 2,
}
config.scrollback_lines = 5000
config.native_macos_fullscreen_mode = true
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = true

config.window_close_confirmation = "NeverPrompt"
config.max_fps = 144
config.hide_tab_bar_if_only_one_tab = true
config.animation_fps = 60
config.cursor_blink_rate = 250
config.window_frame = {
	font_size = 11.0,
	active_titlebar_bg = "#1f1f28",
}

config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false

config.colors = {
	tab_bar = {
		background = "#1F1F28",

		active_tab = {
			bg_color = "#2D4F67",
			fg_color = "#DCD7BA",
			intensity = "Bold",
		},

		inactive_tab = {
			bg_color = "#1F1F28",
			fg_color = "#727169",
		},

		inactive_tab_hover = {
			bg_color = "#223249",
			fg_color = "#C8C093",
		},

		new_tab = {
			bg_color = "#1F1F28",
			fg_color = "#727169",
		},
		new_tab_hover = {
			bg_color = "#223249",
			fg_color = "#C8C093",
		},
	},
}

config.keys = {
	{
		key = "r",
		mods = "CTRL|SHIFT",
		action = wezterm.action.PromptInputLine({
			description = "Nuevo nombre de pestaña:",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
}
return config
