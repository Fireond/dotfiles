return {
  {
    "fireond/illustrate.nvim",
    lazy = true,
    ft = "tex",
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
  {
    "folke/snacks.nvim",
    opts = {
      image = {
        enabled = true,
        doc = {
          inline = true,
          conceal = false,
        },
        convert = {
          notify = true, -- show a notification on error
        },
        math = {
          enabled = false,
          latex = {
            font_size = "normalsize", -- see https://www.sascha-frank.com/latex-font-size.html
            packages = {
              "amsmath",
              "amssymb",
              "amsthm",
              "bbm",
              "fixdif",
              "mathtools",
              "mathrsfs",
              "physics2",
            },
            tpl = [[
            \documentclass[preview,border=2pt,varwidth,12pt]{standalone}
            \usepackage{${packages}}
            \usephysicsmodule{ab,braket,op.legacy,diagmat}
            \input{~/Documents/Latex/commands.tex}
            \begin{document}
            ${header}
            { \${font_size} \selectfont
              \color[HTML]{${color}}
            ${content}}
            \end{document}]],
          },
        },
      },
    },
  },
}
