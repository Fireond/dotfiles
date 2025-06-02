-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

-- movement
map({ "n", "v", "o" }, "H", "^", { desc = "Use 'H' as '^'" })
map({ "n", "v", "o" }, "L", "$", { desc = "Use 'L' as '$'" })

-- indent for normal mode
map("n", "<", "v<g")
map("n", ">", "v>g")

-- buffers
map({ "n", "i" }, "<M-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
map("n", "<leader>k", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
map({ "n", "i" }, "<M-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
map("n", "<leader>j", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
map("n", "<leader>D", "<C-W>c", { desc = "Delete window" })
map("n", "<leader>d", function()
  Snacks.bufdelete()
end, { desc = "Delete buffer" })

-- windows resize
map("n", "<Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- go to files
map("n", "<leader>go", "<cmd>e ~/.config/nvim/lua/config/options.lua<cr>", { desc = "Go to options config" })
map("n", "<leader>gk", "<cmd>e ~/.config/nvim/lua/config/keymaps.lua<cr>", { desc = "Go to keymaps config" })
map("n", "<leader>ga", "<cmd>e ~/.config/nvim/lua/config/autocmds.lua<cr>", { desc = "Go to autocmds config" })
-- map("n", "<leader>gu", "<cmd>e ~/.config/nvim/lua/util/latex.lua<cr>", { desc = "Go to util config" })
map("n", "<leader>gl", "<cmd>e ~/Documents/Latex/preamble.tex<cr>", { desc = "Go to latex.nvim config" })
map("n", "<leader>gt", "<cmd>e ~/Documents/Latex/note_template.tex<cr>", { desc = "Go to latex template" })
map("n", "<leader>gi", "<cmd>e ~/Documents/Latex/latexindent.yaml<cr>", { desc = "Go to latexindent" })
map("n", "<leader>gs", function()
  require("luasnip.loaders").edit_snippet_files({})
end, { desc = "Go to luasnip config" })

map({ "n", "t" }, "<leader>fd", function()
  Snacks.picker.files({ cwd = vim.fn.expand("~/.dotfiles"), hidden = true })
end, { desc = "Find Dotfiles" })
map({ "n", "t" }, "<leader>fh", function()
  Snacks.picker.files({ cwd = vim.fn.expand("~"), hidden = true })
end, { desc = "Find home file" })
map({ "n" }, "<leader>fp", function()
  Snacks.picker.files({ cwd = vim.fn.expand("~/.config/nvim/lua/plugins"), hidden = true })
end, { desc = "Find plugins config" })
map({ "n" }, "<leader>fu", function()
  Snacks.picker.files({ cwd = vim.fn.expand("~/.dotfiles/nvim/.config/nvim/lua/util"), hidden = true })
end, { desc = "Find util config" })
map("n", "<leader>gL", function()
  require("mini.files").open(vim.fn.expand("~/.local/share/nvim/lazy/LazyVim/lua/lazyvim/"), true)
end, { desc = "Go to lazyvim config" })
map("n", "<leader>gn", function()
  require("mini.files").open(vim.fn.expand("~/Documents/Obsidian-Vault/"), true)
end, { desc = "Go to Obsidian Vault" })

-- Spell check
map("i", "<C-d>", "<C-g>u<Esc>[s1z=`]a<C-g>u", { desc = "Check spell" })
map("n", "<leader>h", "a<C-g>u<Esc>[s1z=`]a<C-g>u<Esc>", { desc = "Check spell" })
map("n", "<leader>H", "a<C-g>u<Esc>[szg`]a<C-g>u<Esc>", { desc = "Add word to dictionary" })

map("n", "<leader>L", "<cmd>:Lazy<cr>", { desc = "Lazy" })
if vim.g.vscode then
  map("n", "<space>w", "<cmd>w<cr>", { desc = "Save" })
else
  map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })
end
map({ "n", "v", "t" }, "<leader>;", "<cmd>ToggleTerm<cr>", { desc = "Toggle terminal" })
-- map("n", "<leader>uc", Util.telescope("colorscheme", { enable_preview = true }), { desc = "Colorscheme with preview" })
-- map("n", "<leader>uu", "b~ea", { desc = "Colorscheme with preview" })

map({ "n", "v" }, "<leader>a", "ggVG", { desc = "Select all" })
map("n", "<leader>+", "<C-a>", { desc = "Increase number" })
map("n", "<leader>-", "<C-x>", { desc = "Decrease number" })
-- map("n", "<leader>z", "<cmd>ZenMode<cr>", { desc = "Toggle zen mode" })
-- map("n", "<leader>z", "zt", { desc = "Top this line" })
-- map("n", "<leader>fp", function()
--   require("telescope").extensions.neoclip.default()
-- end, { desc = "Find clips" })

-- note
map("n", "<leader>n", "", { desc = "+note/obsidian" })
map("n", "<leader>nn", function()
  local ft = vim.bo.filetype
  if ft == "tex" then
    require("util.note").add_note()
  elseif ft == "markdown" then
    require("util.obsidian").add_note_picker()
  else
    return nil
  end
end, { desc = "Add new note" })
map("n", "<leader>nf", function()
  local ft = vim.bo.filetype
  if ft == "tex" then
    require("util.note").find_note()
  elseif ft == "markdown" then
    vim.cmd("ObsidianQuickSwitch")
  end
end, { desc = "Find note" })
map("n", "<leader>ns", function()
  local ft = vim.bo.filetype
  if ft == "tex" then
    require("util.note").add_section()
  elseif ft == "markdown" then
    vim.cmd("ObsidianSearch")
  else
    return nil
  end
end, { desc = "add section" })
map("n", "<leader>nO", function()
  local ft = vim.bo.filetype
  if ft == "markdown" then
    require("util.obsidian").open_sources_from_frontmatter()
  else
    vim.notify("Not a md file!", vim.log.levels.ERROR)
    return nil
  end
end, { desc = "Open Sources" })
map("n", "<leader>nz", function()
  local ft = vim.bo.filetype
  if ft == "markdown" then
    require("util.zhihu").convert()
  else
    vim.notify("Not a md file!", vim.log.levels.ERROR)
    return nil
  end
end, { desc = "Convert To Zhihu" })
map("n", "<leader>nc", function()
  local ft = vim.bo.filetype
  if ft == "markdown" then
    require("util.obsidian").vault_commit_push()
  else
    vim.notify("Not a md file!", vim.log.levels.ERROR)
    return nil
  end
end, { desc = "Vault commit push" })
map("n", "<leader>np", function()
  local ft = vim.bo.filetype
  if ft == "markdown" then
    require("util.obsidian").vault_pull()
  else
    vim.notify("Not a md file!", vim.log.levels.ERROR)
    return nil
  end
end, { desc = "Vault pull" })

map("n", "<leader>N", function()
  Snacks.notifier.show_history()
end, { desc = "Notification History" })

function _G.toggle_callout()
  -- 获取选区的开始和结束行
  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")
  -- 确保 start_line <= end_line
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end

  for lnum = start_line, end_line do
    -- 转换为 0-based
    local row = lnum - 1
    -- 获取行内容
    local lines = vim.api.nvim_buf_get_lines(0, row, row + 1, false)
    if #lines == 0 then
      goto continue
    end
    local line = lines[1]

    -- 判断行首是否为 '>'
    local new_line
    if line:sub(1, 1) == ">" then
      new_line = line:sub(2)
    else
      new_line = ">" .. line
    end

    -- 更新行内容
    vim.api.nvim_buf_set_lines(0, row, row + 1, false, { new_line })
    ::continue::
  end
  -- -- 退出可视模式（可选）
  -- vim.cmd([[normal! gv]])
end

map("x", "<leader>e", ":<C-U>lua _G.toggle_callout()<CR><esc>", { desc = "Toggle Callout" })

-- Disable default keymaps
local del = vim.keymap.del
del("n", "<leader>bb")
del("n", "<leader>wd")
del("n", "<leader>l")
del("n", "<leader>ft")
del("n", "<leader>fT")
