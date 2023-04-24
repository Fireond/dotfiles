return {
	{
		"nvim-treesitter/nvim-treesitter",
		version = false, -- last release is way too old and doesn't work on Windows
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = { "nvim-treesitter/nvim-treesitter-textobjects", "HiPhish/nvim-ts-rainbow2" },
		opts = {
			highlight = { enable = true },
			indent = { enable = true, disable = { "python" } },
			context_commentstring = { enable = true, enable_autocmd = false },
			ensure_installed = {
				"bash",
				"bibtex",
				"c",
				"html",
				"javascript",
				"json",
				"latex",
				"lua",
				"luap",
				"markdown",
				"markdown_inline",
				"python",
				"query",
				"regex",
				"tsx",
				"typescript",
				"vim",
				"yaml",
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<cr>",
					node_incremental = "<cr>",
					scope_incremental = "<nop>",
					node_decremental = "<bs>",
				},
			},
			rainbow = {
				enable = false,
				disable = { "jsx", "cpp" },
				-- query = {
				-- 	latex = "rainbow-parens",
				-- },
				-- strategy = {
				-- 	-- Use global strategy by default
				-- 	require("ts-rainbow").strategy["global"],
				-- 	-- Use local for HTML
				-- 	html = require("ts-rainbow").strategy["local"],
				-- 	-- Pick the strategy for LaTeX dynamically based on the buffer size
				-- 	latex = function()
				-- 		-- Disabled for very large files, global strategy for large files,
				-- 		-- local strategy otherwise
				-- 		if vim.fn.line("$") > 10000 then
				-- 			return nil
				-- 		elseif vim.fn.line("$") > 1000 then
				-- 			return require("ts-rainbow").strategy["global"]
				-- 		end
				-- 		return require("ts-rainbow").strategy["local"]
				-- 	end,
				-- },
			},
		},
		config = function(_, opts)
			-- Folding
			vim.opt.foldmethod = "expr"
			vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
			vim.opt.foldenable = false
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
}
