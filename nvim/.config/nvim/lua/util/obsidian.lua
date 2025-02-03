local M = {}

M.open_pdfs_from_frontmatter = function()
  local lines = vim.api.nvim_buf_get_lines(0, 0, 30, false)

  -- 提取frontmatter内容
  local frontmatter = {}
  local in_frontmatter = false
  for _, line in ipairs(lines) do
    if line == "---" then
      if in_frontmatter then
        break -- 结束frontmatter
      else
        in_frontmatter = true
      end
    elseif in_frontmatter then
      table.insert(frontmatter, line)
    end
  end

  -- 解析sources字段
  local sources = {}
  local in_sources = false
  for _, line in ipairs(frontmatter) do
    if line:match("^sources:") then
      in_sources = true
    elseif in_sources then
      -- 匹配列表项（支持带引号的路径）
      local match = line:match("^%s*%-%s*['\"]?(.*)['\"]?$")
      if match and match ~= "" then
        table.insert(sources, match)
      -- 检查是否退出sources块
      elseif not line:match("^%s") then
        in_sources = false
      end
    end
  end

  if #sources == 0 then
    print("❌ No sources found in frontmatter")
    return
  end

  for _, path in ipairs(sources) do
    path = vim.fn.expand(path)
    local cmd = "zathura" .. string.format(" %q", path) .. " &"
    -- os.execute(cmd)
    vim.api.nvim_call_function("system", { cmd })
  end
end

return M
