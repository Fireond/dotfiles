return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    opts = function()
      local uname = vim.loop.os_uname()
      local is_ubuntu = uname.sysname == "Linux" and string.find(uname.release, "ubuntu")
      local parsers = {
        "typst",
        "bash",
        "c",
        "cpp",
        "html",
        "json",
        "lua",
        "luap",
        "markdown",
        "make",
        "markdown_inline",
        "scala",
        "python",
        "latex",
        "query",
        "toml",
        "regex",
        "vim",
        "yaml",
      }
      -- 只有不是 Ubuntu 才加 latex
      if not is_ubuntu then
        table.insert(parsers, "latex")
      end
      return {
        highlight = {
          enable = true,
          disable = { "latex" },
          -- additional_vim_regex_highlighting = { "markdown" },
        },
        ignore_install = { "latex" },
        indent = { enable = true, disable = { "python" } },
        context_commentstring = { enable = true, enable_autocmd = false },
        ensure_installed = parsers,
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<cr>",
            node_incremental = "<cr>",
            scope_incremental = "\\",
            node_decremental = "<bs>",
          },
        },
      }
    end,
    rainbow = {
      enable = true,
      -- list of languages you want to disable the plugin for
      disable = { "jsx", "cpp" },
      -- Which query to use for finding delimiters
      query = "rainbow-parens",
      -- Highlight the entire buffer all at once
    },

    keys = function()
      return {
        { "<cr>", desc = "Increment selection" },
        { "<bs>", desc = "Decrement selection", mode = "x" },
      }
    end,
  },
}
