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
    -- dependencies = { "echasnovski/mini.ai" }, -- 确保 mini.ai 先加载
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
      vim.keymap.set("n", "<localleader>lt", ":call vimtex#fzf#run()<cr>")
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
      vim.api.nvim_create_user_command("ConvertToDocx", ConvertTexToDocx, {})
      vim.keymap.set("n", "<localleader>ld", ConvertTexToDocx, { desc = "convert to docx file" })
    end,
  },
}
