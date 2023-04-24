return {
	{
		"monaqa/dial.nvim",
		keys = {
			{ "<c-a>", mode = { "n", "v" } },
			{ "<c-x>", mode = { "n", "v" } },
			{ "g<c-a>", mode = "v" },
			{ "g<c-x>", mode = "v" },
		},
		init = function()
			local keymap = vim.api.nvim_set_keymap
			keymap("n", "<C-a>", require("dial.map").inc_normal(), { desc = "Increment", noremap = true })
			keymap("n", "<C-x>", require("dial.map").dec_normal(), { desc = "Decrement", noremap = true })
			keymap("v", "<C-a>", require("dial.map").inc_visual(), { desc = "Increment", noremap = true })
			keymap("v", "<C-x>", require("dial.map").dec_visual(), { desc = "Decrement", noremap = true })
			keymap("v", "g<C-a>", require("dial.map").inc_gvisual(), { desc = "Increment", noremap = true })
			keymap("v", "g<C-x>", require("dial.map").dec_gvisual(), { desc = "Decrement", noremap = true })
		end,
	},

	{ "nacro90/numb.nvim", event = "BufReadPre", config = true },
	"nvim-lua/plenary.nvim",
	"kkharji/sqlite.lua",
	{
		"folke/persistence.nvim",
		event = "BufReadPre",
		opts = { options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals" } },
  -- stylua: ignore
    keys = {
      { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
    },
	},
	{ "tpope/vim-repeat", event = "VeryLazy" },
	{
		"dstein64/vim-startuptime",
		cmd = "StartupTime",
		config = function()
			vim.g.startuptime_tries = 10
		end,
	},
}
