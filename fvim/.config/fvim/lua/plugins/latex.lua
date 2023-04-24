return {
	{
		"ryleelyman/latex.nvim",
		opts = {
			conceals = {
				add = {
					["colon"] = ":",
					["coloneqq"] = "≔",
					[","] = " ",
				},
			},
			imaps = {
				add = { ["\\emptyset"] = "0", ["\\Alpha"] = "A" },
				default_leader = ";",
			},
			-- surrounds = { enabled = true },
		},
		ft = "tex",
	},

	-- inverse serach for LaTeX
	{
		"f3fora/nvim-texlabconfig",
		config = true,
		build = "go build",
		ft = "tex",
	},
}
