local Util = require("util")

return {
	"nvim-telescope/telescope.nvim",
	cmd = "Telescope",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope-frecency.nvim",
		-- "nvim-telescope/telescope-file-browser.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"tsakirist/telescope-lazy.nvim",
	},
	keys = {
		-- short
		{ "<leader>,", Util.tele_builtin("buffers", { show_all_buffers = true }), desc = "Switch Buffer" },
		{ "<leader>/", Util.tele_builtin("live_grep"), desc = "Find in Files (Grep)" },
		{ "<leader>:", Util.tele_builtin("command_history"), desc = "Command History" },
		{ "<leader><space>", Util.tele_builtin("find_files"), desc = "Find Files (root dir)" },
		-- git
		{ "<leader>fgc", Util.tele_builtin("git_commits"), desc = "commits" },
		{ "<leader>fgs", Util.tele_builtin("git_status"), desc = "status" },
		-- find
		{ "<leader>fb", Util.tele_builtin("buffers"), desc = "Buffers" },
		{ "<leader>fr", Util.tele_extn("frecency"), desc = "Recent" },
		-- { "<leader>e", Util.tele_extn("file_browser", { path = "%:p:h" }), desc = "File Browser" },
		-- { "<leader>E", Util.tele_extn("file_browser"), desc = "File Browser" },
		{ "<leader>fa", Util.tele_builtin("autocommands"), desc = "Auto Commands" },
		{ "<leader>fc", Util.tele_builtin("commands"), desc = "Commands" },
		{ "<leader>fd", Util.tele_builtin("diagnostics"), desc = "Diagnostics" },
		{ "<leader>fh", Util.tele_builtin("help_tags"), desc = "Help Pages" },
		{ "<leader>fH", Util.tele_builtin("highlights"), desc = "Search Highlight Groups" },
		{ "<leader>fk", Util.tele_builtin("keymaps"), desc = "Key Maps" },
		{ "<leader>fm", Util.tele_builtin("marks"), desc = "Jump to Mark" },
		{ "<leader>fo", Util.tele_builtin("vim_options"), desc = "Options" },
		{ "<leader>fl", Util.tele_extn("lazy"), desc = "Lazy" },
		{
			"<leader>uc",
			Util.tele_builtin("colorscheme", { enable_preview = true }),
			desc = "Colorscheme with preview",
		},
		{
			"<leader>fs",
			Util.telescope("lsp_document_symbols", {
				symbols = {
					"Class",
					"Function",
					"Method",
					"Constructor",
					"Interface",
					"Module",
					"Struct",
					"Trait",
					"Field",
					"Property",
				},
			}),
			desc = "Goto Symbol",
		},
		{
			"<leader>fS",
			Util.telescope("lsp_workspace_symbols", {
				symbols = {
					"Class",
					"Function",
					"Method",
					"Constructor",
					"Interface",
					"Module",
					"Struct",
					"Trait",
					"Field",
					"Property",
				},
			}),
			desc = "Goto Symbol (Workspace)",
		},
	},
	config = function(_, _)
		-- local fb_actions = require("telescope._extensions.file_browser.actions")
		local opts = {
			defaults = {
				prompt_prefix = " ",
				selection_caret = " ",
				file_ignore_patterns = { "%.jpeg$", "%.jpg$", "%.png$", ".DS_Store", "%.aux" },
			},
			extensions = {
				-- file_browser = {
				-- 	-- theme = "dropdown",
				-- 	hijack_netrw = true,
				-- 	mappings = {
				-- 		["n"] = {
				-- 			["c"] = fb_actions.create,
				-- 			["r"] = fb_actions.rename,
				-- 			["m"] = fb_actions.move,
				-- 			["y"] = fb_actions.copy,
				-- 			["d"] = fb_actions.remove,
				-- 			["o"] = fb_actions.open,
				-- 			["<bs>"] = fb_actions.goto_parent_dir,
				-- 			["e"] = fb_actions.goto_home_dir,
				-- 			["w"] = fb_actions.goto_cwd,
				-- 			["t"] = fb_actions.change_cwd,
				-- 			["f"] = fb_actions.toggle_browser,
				-- 			["h"] = fb_actions.toggle_hidden,
				-- 			["s"] = fb_actions.toggle_all,
				-- 		},
				-- 	},
				-- },
				frecency = {
					show_scores = true,
					workspaces = {
						["conf"] = vim.fn.expand("~") .. "/.config",
						["doc"] = vim.fn.expand("~") .. "/Documents",
						["cor"] = vim.fn.expand("~") .. "/Documents/Courses",
					},
				},
			},
		}
		local telescope = require("telescope")
		telescope.setup(opts)

		local extns = { "frecency", "fzf", "lazy" }
		for _, extn in ipairs(extns) do
			telescope.load_extension(extn)
		end
	end,
}
