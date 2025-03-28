local M = {}
M.ConvertToZhihuMarkdown = function()
  -- 获取当前buffer内容
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local new_lines = {}

  -- 1. 移除YAML头部
  local header_processed = {}
  local in_header = false
  for _, line in ipairs(lines) do
    if line:match("^%-%-%-$") then
      in_header = not in_header
    else
      if not in_header then
        table.insert(header_processed, line)
      end
    end
  end

  -- 2. 处理行间公式
  local math_processed = {}
  local in_math = false
  local math_content = {}

  for _, line in ipairs(header_processed) do
    -- 检测行间公式的开始/结束标记
    local is_start = line:match("^%s*%$%$")
    local is_end = line:match("%$%$%s*$")

    if is_start and not in_math then
      in_math = true
      table.insert(math_content, line:gsub("^%s*%$%$", ""):gsub("%$%$%s*$", ""))
    elseif is_end and in_math then
      in_math = false
      table.insert(math_content, line:gsub("^%s*%$%$", ""):gsub("%$%$%s*$", ""))

      -- 插入处理后的公式块
      table.insert(math_processed, "")
      table.insert(math_processed, "$$")
      for _, l in ipairs(math_content) do
        if l ~= "" then -- 跳过空行
          table.insert(math_processed, l)
        end
      end
      table.insert(math_processed, "$$")
      table.insert(math_processed, "")
      math_content = {}
    elseif in_math then
      table.insert(math_content, line)
    else
      table.insert(math_processed, line)
    end
  end

  -- 3. 处理行内公式
  for i, line in ipairs(math_processed) do
    -- 替换单$公式为双$，同时避免转义字符
    math_processed[i] = line:gsub("%$([^$]-)%$", "$$%1$$")
  end

  -- 更新buffer内容
  vim.api.nvim_buf_set_lines(0, 0, -1, false, math_processed)
  vim.notify("知乎格式转换完成！", vim.log.levels.INFO)
end

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
  local current_file = vim.fn.expand("%:p")
  local new_file = current_file:gsub("%.md$", "_zhihu.md")

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
