return {
	{
		"L3MON4D3/LuaSnip",
		build = "make install_jsregexp",
		-- dependencies = {
		-- 	"rafamadriz/friendly-snippets",
		-- 	config = function()
		-- 		require("luasnip.loaders.from_vscode").lazy_load()
		-- 	end,
		-- },
		opts = {
			history = true,
			delete_check_events = "TextChanged",
		},
		config = function()
			require("luasnip").config.set_config({
				enable_autosnippets = true,
				store_selection_keys = "`",
			})
			require("luasnip.loaders.from_lua").load({ paths = "~/.config/fvim/LuaSnip" })
		end,
		keys = {
			{
				"fj",
				function()
					return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next"
						or "<c-\\><c-n>:call searchpair('[([{<|]', '', '[)\\]}>|]', 'W')<cr>a"
				end,
				expr = true,
				silent = true,
				mode = "i",
			},
			{
				"fj",
				function()
					require("luasnip").jump(1)
				end,
				mode = "s",
			},
			{
				"fk",
				function()
					require("luasnip").jump(-1)
				end,
				mode = { "i", "s" },
			},
		},
	},
	{
		"hrsh7th/nvim-cmp",
		version = false, -- last release is way too old
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"saadparwaiz1/cmp_luasnip",
		},
		opts = function()
			local cmp = require("cmp")
			return {
				completion = {
					completeopt = "menu,menuone,noinsert",
				},
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
					["<S-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
					["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
					["<S-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
					["<C-n>"] = cmp.mapping.scroll_docs(-4),
					["<C-p>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<C-f>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
					["<S-f>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
					["<C-l>"] = cmp.mapping({
						i = function(fallback)
							if require("luasnip").choice_active() then
								require("luasnip.extras.select_choice")()
							else
								fallback()
							end
						end,
					}),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "buffer" },
					{ name = "path" },
					-- { name = "copilot" },
				}),
				formatting = {
					format = function(_, item)
						local icons = require("config").icons.kinds
						if icons[item.kind] then
							item.kind = icons[item.kind] .. item.kind
						end
						return item
					end,
				},
				experimental = {
					ghost_text = {
						hl_group = "LspCodeLens",
					},
				},
			}
		end,
	},
}
