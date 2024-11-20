local colors = require("colors")

-- Equivalent to the --bar domain
sbar.bar({
	topmost = "window",
	height = 46,
	color = colors.bar.bg,
	padding_right = 1,
	padding_left = 7,
	display = "main",
})
