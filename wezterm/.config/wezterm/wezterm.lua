local wezterm = require("wezterm")
local act = wezterm.action

local config = {
	font_size = 20,
	font = wezterm.font_with_fallback({
		{ family = "DejaVuSansMono Nerd Font", weight = "Book" },
		{ family = "Fira Code", weight = "Book" },
	}),
	window_decorations = "RESIZE",
	use_fancy_tab_bar = false,
	hide_tab_bar_if_only_one_tab = true,

	color_scheme = "Catppuccin Mocha",
}

if wezterm.target_triple == "aarch64-apple-darwin" then
	-- macos
elseif wezterm.target_triple == "x86_64-pc-windows-msvc" then
	-- windows
	config.set_environment_variables = {
		COMSPEC = "C:\\Users\\18248\\AppData\\Local\\Programs\\nu\\bin\\nu.exe",
	}
	config.keys = {
		{ key = "w", mods = "CTRL", action = act.CloseCurrentTab({ confirm = false }) },
		{ key = "t", mods = "CTRL", action = act.SpawnTab("DefaultDomain") },
	}
	for i = 1, 8 do
		table.insert(config.keys, {
			key = tostring(i),
			mods = "CTRL",
			action = act.ActivateTab(i - 1),
		})
	end
	config.mouse_bindings = {
		{
			event = { Up = { streak = 1, button = "Left" } },
			mods = "CTRL",
			action = act.OpenLinkAtMouseCursor,
		},
	}
end

return config
