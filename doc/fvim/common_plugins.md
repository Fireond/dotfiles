# 插件

`alpha.lua`
```lua
return {
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    opts = function()
        local dashboard = require("alpha.themes.dashboard")
        local logo = [[
        ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗  
        ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║  
        ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║  
        ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║  
        ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║  
        ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝  
                          ⟦ 𝔽𝕚𝕣𝕖𝕠𝕟𝕕 ⟧                      
        ]]

        dashboard.section.header.val = vim.split(logo, "\n", {})
        dashboard.section.buttons.val = {
          dashboard.button("f", " " .. " Find file", ":Telescope find_files <CR>"),
          dashboard.button("n", " " .. " New file", ":ene <BAR> startinsert <CR>"),
          dashboard.button("r", " " .. " Recent files", ":Telescope oldfiles <CR>"),
          dashboard.button("g", " " .. " Find text", ":Telescope live_grep <CR>"),
          dashboard.button("s", "勒" .. " Restore Session", [[:lua require("persistence").load() <cr>]]),
          dashboard.button("l", "鈴" .. " Lazy", ":Lazy<CR>"),
          dashboard.button("q", " " .. " Quit", ":qa<CR>"),
        }
        for _, button in ipairs(dashboard.section.buttons.val) do
          button.opts.hl = "AlphaButtons"
          button.opts.hl_shortcut = "AlphaShortcut"
        end
        dashboard.section.footer.opts.hl = "Type"
        dashboard.section.header.opts.hl = "AlphaHeader"
        dashboard.section.buttons.opts.hl = "AlphaButtons"
        dashboard.opts.layout[1].val = 8
        return dashboard
      end,
    config = function(_, dashboard)
      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          pattern = "AlphaReady",
          callback = function()
            require("lazy").show()
          end,
        })
      end

      require("alpha").setup(dashboard.opts)

      vim.api.nvim_create_autocmd("User", {
        pattern = "NeovimStarted",
        callback = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          local now = os.date "%d-%m-%Y %H:%M:%S"
          local version = "   v" .. vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch
          local fortune = require "alpha.fortune"
          local quote = table.concat(fortune(), "\n")
          local plugins = "⚡Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
          local footer = "\t" .. version ..   "\t" .. plugins .. "\n" .. now .. "\n" .. quote
          dashboard.section.footer.val = footer
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
    end,
  }
}
```
`ui.lua`
```lua
return {
  { "MunifTanjim/nui.nvim" },
  { "nvim-tree/nvim-web-devicons" },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      -- char = "▏",
      char = "│",
      filetype_exclude = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy" },
      show_trailing_blankline_indent = false,
      show_current_context = false,
    },
  },
  {
    "echasnovski/mini.indentscope",
    version = false, -- wait till new 0.7.0 release to put it back on semver
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      -- symbol = "▏",
      symbol = "│",
      options = { try_as_border = true },
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason" },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
    config = function(_, opts)
      require("mini.indentscope").setup(opts)
    end,
  },
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    keys = {
      {
        "<leader>nd",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Delete all Notifications",
      },
    },
    opts = {
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
    },
    config = function(_, opts)
      require("notify").setup(opts)
      vim.notify = require("notify")
    end
  },
}
```
`util.lua`
```lua
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
      vim.api.nvim_set_keymap("n", "<C-a>", require("dial.map").inc_normal(), { desc = "Increment", noremap = true })
      vim.api.nvim_set_keymap("n", "<C-x>", require("dial.map").dec_normal(), { desc = "Decrement", noremap = true })
      vim.api.nvim_set_keymap("v", "<C-a>", require("dial.map").inc_visual(), { desc = "Increment", noremap = true })
      vim.api.nvim_set_keymap("v", "<C-x>", require("dial.map").dec_visual(), { desc = "Decrement", noremap = true })
      vim.api.nvim_set_keymap("v", "g<C-a>", require("dial.map").inc_gvisual(), { desc = "Increment", noremap = true })
      vim.api.nvim_set_keymap("v", "g<C-x>", require("dial.map").dec_gvisual(), { desc = "Decrement", noremap = true })
    end,
  },
  { "nacro90/numb.nvim", event = "BufReadPre", config = true },
  "nvim-lua/plenary.nvim",
  "kkharji/sqlite.lua",
},
```
`which-key.lua`
```lua
return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      local keymaps = {
        -- TODO:
      }
      wk.register(keymaps)
    end,
    opts = {
      key_labels = {
        ["<leader>"] = "SPC",
        ["<tab>"] = "TAB",
      },
    },
  },
}
```
使用"`"键来回到标记，使用“键来查看寄存器，使用z=来查看拼写检查

`telescope.lua`
```lua
return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  dependencies = {
    "nvim-telescope/telescope-frecency.nvim",
    "nvim-telescope/telescope-file-browser.nvim",
  },
  keys = {
      -- short
      { "<leader>,", "<cmd>Telescope buffers show_all_buffers=true<cr>", desc = "Switch Buffer" },
      { "<leader>/", util.telescope("live_grep"), desc = "Find in Files (Grep)" },
      { "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
      { "<leader><space>", util.telescope("files"), desc = "Find Files (root dir)" },
      -- git
      { "<leader>fgc", "<cmd>Telescope git_commits<CR>", desc = "commits" },
      { "<leader>fgs", "<cmd>Telescope git_status<CR>", desc = "status" },
      -- find
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>ff", util.telescope("files"), desc = "Find Files (root dir)" },
      { "<leader>fF", util.telescope("files", { cwd = false }), desc = "Find Files (cwd)" },
      { "<leader>fr", util.tele_extn("frecency"), desc = "Recent" },
      { "<leader>fd", util.tele_extn("file_browser", { path = "%:p:h" }), desc = "File Browser" },
			{ "<leader>fD", util.tele_extn("file_browser"), desc = "File Browser" },
      { "<leader>fa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
      { "<leader>fc", "<cmd>Telescope commands<cr>", desc = "Commands" },
      { "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
      { "<leader>fH", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" },
      { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
      { "<leader>fm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
      { "<leader>fo", "<cmd>Telescope vim_options<cr>", desc = "Options" },
      { "<leader>uc", util.telescope("colorscheme", { enable_preview = true }), desc = "Colorscheme with preview" },
      {
        "<leader>fs",
        util.telescope("lsp_document_symbols", {
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
        "<leader>sS",
        util.telescope("lsp_workspace_symbols", {
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
  opts = {
    defaults = {
      prompt_prefix = " ",
      selection_caret = " ",
    },
  },
  config = function(_, opts)
    local telescope = require("telescope")
    telescope.setup(opts)

    local extns = { "file_browser", "frecency" }
    for _, extn in ipairs(extns) do
      telescope.load_extension(extn)
    end
  end,
}
```
`util/init.lua`
```lua
-- returns the root directory based on:
-- * lsp workspace folders
-- * lsp root_dir
-- * root pattern of filename of the current buffer
-- * root pattern of cwd
---@return string
function M.get_root()
  ---@type string?
  local path = vim.api.nvim_buf_get_name(0)
  path = path ~= "" and vim.loop.fs_realpath(path) or nil
  ---@type string[]
  local roots = {}
  if path then
    for _, client in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
      local workspace = client.config.workspace_folders
      local paths = workspace and vim.tbl_map(function(ws)
        return vim.uri_to_fname(ws.uri)
      end, workspace) or client.config.root_dir and { client.config.root_dir } or {}
      for _, p in ipairs(paths) do
        local r = vim.loop.fs_realpath(p)
        if path:find(r, 1, true) then
          roots[#roots + 1] = r
        end
      end
    end
  end
  table.sort(roots, function(a, b)
    return #a > #b
  end)
  ---@type string?
  local root = roots[1]
  if not root then
    path = path and vim.fs.dirname(path) or vim.loop.cwd()
    ---@type string?
    root = vim.fs.find(M.root_patterns, { path = path, upward = true })[1]
    root = root and vim.fs.dirname(root) or vim.loop.cwd()
  end
  ---@cast root string
  return root
end

---wrap of telescope builtin functions
---@param builtin string
---@param opts table?
---@return function
function M.tele_builtin(builtin, opts)
	return function()
		require("telescope.builtin")[builtin](opts or {})
	end
end

---wrap of telescope extension functions
---@param extn string
---@param opts table?
---@return function
function M.tele_extn(extn, opts)
	return function()
		require("telescope").extensions[extn][extn](opts or {})
	end
end

-- this will return a function that calls telescope.
-- cwd will default to lazyvim.util.get_root
-- for `files`, git_files or find_files will be chosen depending on .git
function M.telescope(builtin, opts)
  local params = { builtin = builtin, opts = opts }
  return function()
    builtin = params.builtin
    opts = params.opts
    opts = vim.tbl_deep_extend("force", { cwd = M.get_root() }, opts or {})
    if builtin == "files" then
      if vim.loop.fs_stat((opts.cwd or vim.loop.cwd()) .. "/.git") then
        opts.show_untracked = true
        builtin = "git_files"
      else
        builtin = "find_files"
      end
    end
    require("telescope.builtin")[builtin](opts)
  end
end
```

`treesitter.lua`
```lua
return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- last release is way too old and doesn't work on Windows
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects", "HiPhish/nvim-ts-rainbow2" },
    keys = {
      { "<cr>", desc = "Increment selection" },
      { "<bs>", desc = "Decrement selection", mode = "x" },
    },
    ---@type TSConfig
    opts = {
      highlight = { enable = true },
      indent = { enable = true, disable = { "python" } },
      context_commentstring = { enable = true, enable_autocmd = false },
      ensure_installed = {
        "bash",
        "c",
        "help",
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
          enable = true,
          query = { latex = "rainbow-parens" },
      },
    },
    ---@param opts TSConfig
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
```
