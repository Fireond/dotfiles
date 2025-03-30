local M = {}

function M.convert()
  -- 获取当前 buffer 内容
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  -- 1. 移除 YAML front matter
  local filtered_lines = {}
  local in_header = false
  local header_removed = false

  for _, line in ipairs(lines) do
    if not header_removed then
      if line:match("^%-%-%-") then
        if in_header then
          in_header = false
          header_removed = true
        else
          in_header = true
        end
      else
        if not in_header then
          table.insert(filtered_lines, line)
        end
      end
    else
      table.insert(filtered_lines, line)
    end
  end

  -- 合并为字符串处理
  local content = table.concat(filtered_lines, "\n")

  -- 2. 处理行间公式 (需要优先处理)
  content = content:gsub("%$%$(.-)%$%$", function(formula)
    -- 清理首尾空白并保留中间换行
    formula = formula:gsub("^%s*\n", ""):gsub("\n%s*$", "")
    return "\n\n$\n" .. formula .. "\n$\n\n"
  end)

  -- 3. 处理行内公式
  content = content:gsub("%$([^$]-)%$", "$$%1$$") -- 非贪婪匹配

  -- 清理多余空行（可选）
  content = content:gsub("\n\n\n+", "\n\n")

  -- 分割回行数组
  local processed_lines = vim.split(content, "\n")

  -- 生成新文件名
  local current_file_name = vim.fn.expand("%:t")
  local new_file_name = current_file_name:gsub("%.md$", "_zhihu.md")
  local new_file = vim.fn.expand("~/Documents/Obsidian-Vault/04-tech/zhihu/") + current_file_name

  -- 写入新文件
  local file = io.open(new_file, "w")
  if file then
    file:write(table.concat(processed_lines, "\n"))
    file:close()
    vim.notify("转换完成，保存至: " .. new_file, vim.log.levels.INFO)
  else
    vim.notify("无法写入文件: " .. new_file, vim.log.levels.ERROR)
  end
end

return M
