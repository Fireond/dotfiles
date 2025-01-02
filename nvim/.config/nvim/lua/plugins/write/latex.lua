return {
  {
    "ryleelyman/latex.nvim",
    enabled = false,
    opts = {
      conceals = {
        add = {
          ["colon"] = ":",
          ["coloneqq"] = "≔",
          ["pdv"] = "∂",
          ["odv"] = "d",
          ["sqrt"] = "√",
          ["|"] = "⫴",
          ["{"] = "{",
          ["}"] = "}",
          ["nmid"] = "∤",
          ["implies"] = "⇨",

          -- hide
          [","] = "",
          [" "] = "",
          ["vb"] = "",
          ["va"] = "",
          ["qq"] = "",
          ["mathrm"] = "",
          ["displaystyle"] = "",
          ["limits"] = "",
          ["ab"] = "",
          ["ab*"] = "",
          -- ["bra"] = "",
          -- ["ket"] = "",
          -- ["braket"] = "",
          -- ["ketbra"] = "",
        },
      },
      imaps = {
        enabled = false,
        -- add = { ["\\emptyset"] = "1", ["\\Alpha"] = "A" },
        -- default_leader = ";",
      },
      surrounds = { enabled = false },
    },
    ft = "tex",
  },
  {
    "lervag/vimtex",
    init = function()
      vim.keymap.set("n", "<localleader>lt", ":call vimtex#fzf#run()<cr>")

      vim.g.vimtex_syntax_conceal_disable = 0
      vim.g.vimtex_mappings_disable = { ["n"] = { "K" } } -- disable `K` as it conflicts with LSP hover
      vim.g.vimtex_quickfix_method = vim.fn.executable("pplatex") == 1 and "pplatex" or "latexlog"
      vim.g.vimtex_compiler_silent = 1
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_compiler_latexmk = {
        aux_dir = "",
        out_dir = "",
        callback = 1,
        continuous = 1,
        executable = "latexmk",
        hooks = {},
        options = {
          "-verbose",
          "-file-line-error",
          "-synctex=1",
          "-interaction=nonstopmode",
          "--shell-escape",
        },
      }

      vim.g.vimtex_quickfix_ignore_filters = { "^Overfull", "^Underfull" }
      vim.g.vimtex_quickfix_open_on_warning = 0

      if vim.loop.os_uname().sysname == "Darwin" then
        vim.g.vimtex_view_method = "skim"
        vim.g.vimtex_view_skim_sync = 1
      elseif vim.loop.os_uname().sysname == "Linux" then
        vim.g.vimtex_view_method = "zathura"
      end

      vim.keymap.set({ "x", "o" }, "it", "<plug>(vimtex-i$)", { desc = "vimtex-i$" })
      vim.keymap.set({ "x", "o" }, "at", "<plug>(vimtex-a$)", { desc = "vimtex-a$" })
    end,
  },
  {
    "rpapallas/illustrate.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    keys = function()
      local illustrate = require("illustrate")
      local illustrate_finder = require("illustrate.finder")

      return {
        {
          "<leader>i",
          "",
          desc = "+illustrate",
        },
        {
          "<leader>is",
          function()
            illustrate.create_and_open_svg()
          end,
          desc = "Create and open a new SVG file with provided name.",
        },
        {
          "<leader>ia",
          function()
            illustrate.create_and_open_ai()
          end,
          desc = "Create and open a new Adobe Illustrator file with provided name.",
        },
        {
          "<leader>io",
          function()
            illustrate.open_under_cursor()
          end,
          desc = "Open file under cursor (or file within environment under cursor).",
        },
        {
          "<leader>if",
          function()
            illustrate_finder.search_and_open()
          end,
          desc = "Use telescope to search and open illustrations in default app.",
        },
        {
          "<leader>ic",
          function()
            illustrate_finder.search_create_copy_and_open()
          end,
          desc = "Use telescope to search existing file, copy it with new name, and open it in default app.",
        },
      }
    end,
    opts = {
      -- optionally define options.
      text_templates = { -- Default code template for each vector type (svg/ai) and each document (tex/md)
        svg = {
          tex = [[
\begin{figure}[h]
  \centering
  \includesvg[width=0.5\textwidth]{$FILE_PATH}
  \caption{Caption}
  \label{fig:}
\end{figure}
            ]],
          md = "![caption]($FILE_PATH)",
        },
        ai = {
          tex = [[
\begin{figure}[h]
  \centering
  \includegraphics[width=0.5\linewidth]{$FILE_PATH}
  \caption{Caption}
  \label{fig:}
\end{figure}
            ]],
          md = "![caption]($FILE_PATH)",
        },
      },
    },
  },
}
