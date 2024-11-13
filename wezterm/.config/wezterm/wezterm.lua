local wezterm = require("wezterm")

local config = {
	font_size = 20,
	font = wezterm.font_with_fallback({
		{ family = "DejaVuSansMono Nerd Font", weight = "Book" },
	}),

	color_scheme = "Catppuccin Mocha",
}

return config
