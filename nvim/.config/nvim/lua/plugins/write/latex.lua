return {
  {
    "lervag/vimtex",
    init = function()
      function ConvertTexToDocx()
        -- 获取当前文件名
        local filepath = vim.fn.expand("%:p") -- 完整路径
        local filename = vim.fn.expand("%:t") -- 文件名
        local fileext = vim.fn.expand("%:e") -- 扩展名
        -- 确保当前文件是 .tex 文件
        if fileext ~= "tex" then
          print("Not a tex file")
          return
        end
        -- 构造输出文件名
        local output = vim.fn.expand("%:r") .. ".docx" -- 同名 .docx 文件
        -- 构造 pandoc 命令
        local cmd = string.format("pandoc '%s' -o '%s'", filepath, output)
        -- 运行命令
        vim.fn.system(cmd)
        -- 检查是否转换成功
        if vim.v.shell_error == 0 then
          vim.notify("Convertion succeed!", vim.log.levels.INFO)
        else
          vim.notify("Convertion failed!", vim.log.levels.ERROR)
        end
      end
      vim.g.vimtex_view_automatic = 0
      vim.g.vimtex_syntax_conceal_disable = 1
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

      vim.g.vimtex_quickfix_mode = 0
      vim.g.vimtex_quickfix_ignore_filters = { "^Overfull", "^Underfull" }
      vim.g.vimtex_quickfix_open_on_warning = 0

      if vim.loop.os_uname().sysname == "Darwin" then
        vim.g.vimtex_view_method = "skim"
        vim.g.vimtex_view_skim_sync = 1
      elseif vim.loop.os_uname().sysname == "Linux" then
        vim.g.vimtex_view_method = "zathura_simple"
      end

      vim.g.vimtex_env_toggle_math_map = {
        ["\\["] = "equation",
        ["equation"] = "\\[",
      }
      vim.keymap.set("n", "<leader>m", "<Plug>(vimtex-env-toggle-math)")

      vim.keymap.set({ "x", "o" }, "it", "<plug>(vimtex-i$)", { desc = "vimtex-i$" })
      vim.keymap.set({ "x", "o" }, "at", "<plug>(vimtex-a$)", { desc = "vimtex-a$" })
      vim.api.nvim_create_user_command("ConvertToDocx", ConvertTexToDocx, {})
      vim.keymap.set("n", "<localleader>ld", ConvertTexToDocx, { desc = "convert to docx file" })
    end,
  },
  {
    "let-def/texpresso.vim",
    lazy = false,
    keys = {
      { "<leader>lP", "<cmd>TeXpresso %<cr>", desc = "TeXpresso" },
    },
  },
  {
    "pxwg/math-conceal.nvim",
    enabled = false,
    branch = "preview",
    build = "cargo build --release --manifest-path service/Cargo.toml",
    main = "math-conceal",
    opts = {
      -- conceal = {},
      conceal = { "greek", "script", "math", "font", "delim", "phy" },
      ft = { "plaintex", "tex", "context", "bibtex", "markdown", "typst" },
      image = {
        enabled = false,
        filetypes = { "typst", "markdown" },
      },
    },
  },
  {
    "richwomanbtc/overleaf.nvim",
    build = "cd node && npm install --allow-git=root",
    config = function()
      require("overleaf").setup({
        env_file = vim.fn.stdpath("data") .. "/overleaf.env",
        sync_dir = vim.fn.stdpath("data") .. "/overleaf-projects",
      })

      local buffer = require("overleaf.buffer")
      local original_create = buffer.create

      buffer.create = function(doc, ...)
        local bufnr = original_create(doc, ...)

        vim.api.nvim_clear_autocmds({
          event = "BufWriteCmd",
          buffer = bufnr,
        })

        vim.api.nvim_create_autocmd("BufWriteCmd", {
          buffer = bufnr,
          callback = function()
            require("overleaf.sync").write_doc(doc)
            vim.bo[bufnr].modified = false
          end,
        })

        return bufnr
      end
    end,
  },
}
