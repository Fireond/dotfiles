return {
	"nvim-tree/nvim-tree.lua",
	cmd = { "NvimTreeToggle" },
	keys = {
		{ "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Explorer" },
	},
	opts = {
		respect_buf_cwd = true,
		view = {
			width = 40,
			number = true,
			relativenumber = true,
		},
		root_dirs = { "~/Documents" },
		filters = {
			custom = { ".git", ".aux", ".log" },
			dotfiles = true,
		},
		sync_root_with_cwd = true,
		update_focused_file = {
			enable = true,
			update_root = true,
		},
		actions = {
			open_file = {
				quit_on_open = true,
			},
		},
	},
}
