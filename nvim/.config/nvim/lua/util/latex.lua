local M = {}

local MATH_NODES = {
  displayed_equation = true,
  inline_formula = true,
  math_environment = true,
}

-- 小工具：安全拿到当前节点（可能返回 nil）
local function node_at_cursor()
  -- Neovim 0.10+：直接用 get_node() 拿“光标处”节点
  -- 若当前 buffer 没有 parser/没有启用 treesitter，可能返回 nil
  local ok, node = pcall(vim.treesitter.get_node)
  if ok then
    return node
  end
  return nil
end

M.in_env_md = function(env)
  local node = node_at_cursor()
  local bufnr = vim.api.nvim_get_current_buf()
  while node do
    if node:type() == "generic_environment" then
      local begin = node:child(0)
      if begin then
        local name = begin:field("name")
        if name and name[1] then
          local text = vim.treesitter.get_node_text(name[1], bufnr)
          if text == "{" .. env .. "}" then
            return true
          end
        end
      end
    end
    node = node:parent()
  end
  return false
end

M.in_env = function(env)
  -- 仍保留你原来的 vimtex 检测
  local pos = vim.fn["vimtex#env#is_inside"](env)
  return pos[1] ~= 0 or pos[2] ~= 0
end

-- For markdown
M.in_mathzone_md = function()
  local node = node_at_cursor()
  while node do
    if MATH_NODES[node:type()] then
      return true
    end
    node = node:parent()
  end
  return false
end

M.in_text_md = function()
  return not M.in_mathzone_md()
end

-- For typst
M.in_mathzone_typ = function()
  local node = node_at_cursor()
  while node do
    if node:type() == "math" then
      return true
    end
    node = node:parent()
  end
  return false
end

M.in_mathzone = function()
  local ft = vim.bo.filetype
  if ft == "tex" then
    -- return vim.api.nvim_eval("vimtex#syntax#in_mathzone()") == 1
    return M.in_mathzone_md()
  elseif ft == "markdown" then
    return M.in_mathzone_md()
  elseif ft == "typst" then
    return M.in_mathzone_typ()
  end
end

M.in_text = function()
  return not M.in_mathzone()
end

M.in_item = function()
  return M.in_env("itemize") or M.in_env("enumerate")
end
M.in_bib = function()
  return M.in_env("thebibliography")
end
M.in_tikz = function()
  return M.in_env("tikzpicture")
end
M.in_quantikz = function()
  return M.in_env("quantikz")
end
M.in_algo = function()
  return M.in_env("algorithmic")
end

-- M.clean = function()
--   local current_dir = vim.fn.expand("%:p:h")
--   local file_types = { "aux", "log", "out", "fls", "fdb_latexmk", "bcf", "run.xml", "toc", "DS_Store", "bak*", "dvi" }
--   for _, file_type in ipairs(file_types) do
--     local command = "rm " .. current_dir .. "/*." .. file_type
--     vim.api.nvim_call_function("system", { command })
--   end
-- end
--
-- M.format = function()
--   local current_file = vim.fn.expand("%:p")
--   local latexindent = "latexindent -g /dev/null " .. current_file .. " -wd -l ~/Documents/Latex/latexindent.yaml"
--   local build = "pdflatex " .. current_file
--   vim.api.nvim_call_function("system", { build })
--   vim.cmd("w")
--   M.clean()
--   vim.api.nvim_call_function("system", { latexindent })
--   vim.cmd("e")
--   vim.cmd("normal! zz")
--   -- vim.cmd("TexlabForward")
-- end
--
-- M.sympy_calc = function()
--   local selected_text = vim.fn.getreg("v")
--   print(selected_text)
--   vim.api.nvim_out_write(selected_text)
-- end

return M
