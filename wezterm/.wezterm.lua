local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- --- Apariencia y UI ---
config.window_background_opacity = 0.8
config.color_scheme = "Kanagawa (Gogh)"
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 13
config.line_height = 1.1

config.window_decorations = "RESIZE" -- Elimina la barra de titulo para un look minimalista
config.macos_window_background_blur = 40
config.window_padding = {
	left = 2,
	right = 2,
	top = 5,
	bottom = 2,
}
config.scrollback_lines = 5000
config.native_macos_fullscreen_mode = true

config.send_composed_key_when_left_alt_is_pressed = true
config.send_composed_key_when_right_alt_is_pressed = true

config.enable_tab_bar = false
config.window_close_confirmation = "NeverPrompt"
config.max_fps = 144
config.animation_fps = 60
config.cursor_blink_rate = 250
config.window_frame = {
	font_size = 11.0,
	active_titlebar_bg = "#1f1f28", -- sumiInk3 de tu Kanagawa Wave
}

return config
