local M = {}

M.vault_path = "~/Documents/Obsidian-Vault/"
M.math_path = "~/Documents/Obsidian-Vault/02-math/"
M.math_template = [[
---
id: %s
aliases:
  - %s
  - %s
tags:
  - math
  - topology
sources: []
---

# %s

]]

local function process_names(name)
  local words = {}
  for word in string.gmatch(name, "%S+") do
    table.insert(words, word)
  end

  -- 生成 s1：单词全小写，空格替换为 "-"
  local filename = table.concat({}, "-")
  if #words > 0 then
    local s1_words = {}
    for _, word in ipairs(words) do
      table.insert(s1_words, string.lower(word))
    end
    filename = table.concat(s1_words, "-")
  end

  -- 生成 s2：首单词首字母大写，其余小写，保留空格
  local title = ""
  if #words > 0 then
    local s2_words = {}
    for i, word in ipairs(words) do
      if i == 1 then
        local first = string.sub(word, 1, 1)
        local rest = string.sub(word, 2)
        s2_words[i] = string.upper(first) .. string.lower(rest)
      else
        s2_words[i] = string.lower(word)
      end
    end
    title = table.concat(s2_words, " ")
  end

  -- 生成 s3：所有单词全小写，保留空格
  local alias = table.concat({}, " ")
  if #words > 0 then
    local s3_words = {}
    for _, word in ipairs(words) do
      table.insert(s3_words, string.lower(word))
    end
    alias = table.concat(s3_words, " ")
  end

  return filename, title, alias
end

M.add_math = function()
  local name = vim.fn.input("Enter note name: ")
  if name == "" then
    vim.notify("Note name cannot be empty!", vim.log.levels.ERROR)
    return
  end
  local path = vim.fn.expand(M.math_path .. name .. ".md")

  local filename, title, alias = process_names(name)
  local template = string.format(M.math_template, filename, title, alias, title)

  if vim.fn.filereadable(path) == 0 then
    local file = io.open(path, "w")
    if file then
      file:write(template)
      file:close()
      vim.notify("Note created at: " .. path, vim.log.levels.INFO)
      vim.cmd("edit " .. path)
    else
      vim.notify("Error creating file: " .. path, vim.log.levels.ERROR)
    end
  else
    vim.notify("Note already exists: " .. path, vim.log.levels.INFO)
  end
end

M.open_source = function(source)
  local expanded_source = source
  if source:sub(1, 1) == "~" then
    expanded_source = os.getenv("HOME") .. source:sub(2)
  end
  local escaped_path = vim.fn.shellescape(expanded_source)
  local open_cmd
  if vim.loop.os_uname().sysname == "Darwin" then
    open_cmd = "open"
  else
    open_cmd = "xdg-open"
  end
  local cmd = table.concat({ open_cmd, escaped_path, "&" }, " ")
  vim.fn.jobstart(cmd, { detach = true })
end

M.open_sources_from_frontmatter = function()
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
  elseif #sources == 1 then
    M.open_source(sources[1])
  else
    Snacks.picker.select(sources, {
      prompt = "Select a source",
    }, function(choice)
      local source = choice
      if source then
        M.open_source(source)
      end
    end)
  end
end

M.get_unfinished_todos = function()
  local yesterday = os.date("%Y-%m-%d", os.time() - 86400)
  local yesterday_file = vim.fn.expand("~/Documents/Obsidian-Vault/01-dailies/") .. yesterday .. ".md"
  -- 读取昨天的笔记内容
  local y_lines = {}
  local y_file = io.open(yesterday_file, "r")
  if not y_file then
    vim.notify("❌ 昨天的笔记不存在: " .. yesterday_file, vim.log.levels.WARN)
    return ""
  end
  for line in y_file:lines() do
    table.insert(y_lines, line)
  end
  y_file:close()

  local todos = {}
  local in_todo_section = false

  for _, line in ipairs(y_lines) do
    if line:match("^##%s*%d*%s*TODO") then
      in_todo_section = true
    elseif in_todo_section then
      if line:match("^#+ ") then -- 遇到新标题时退出
        in_todo_section = false
      elseif line:match("^%s*- %[ %]") then
        table.insert(todos, line) -- 收集未完成项
      end
    end
  end
  return table.concat(todos, "\n")
end

local function is_in_vault(file_path)
  if file_path == "" then
    return false
  end

  local docs_dir = vim.fn.expand("~/Documents/Obsidian-Vault/")
  local full_path = vim.fn.fnamemodify(file_path, ":p")

  docs_dir = vim.fn.substitute(docs_dir, [[\/\+$]], "/", "")
  full_path = vim.fn.substitute(full_path, [[\/\+]], "/", "g")

  return full_path:sub(1, #docs_dir) == docs_dir
end

M.vault_commit_push = function()
  local file_path = vim.api.nvim_buf_get_name(0)
  if not is_in_vault(file_path) then
    vim.notify("Not in Obsidiaon Vault!", vim.log.levels.ERROR)
    return
  end

  local cmd = "git-vault.sh commit_push"
  vim.fn.jobstart(cmd, { detach = true })
end

M.vault_pull = function()
  local file_path = vim.api.nvim_buf_get_name(0)
  if not is_in_vault(file_path) then
    vim.notify("Not in Obsidiaon Vault!", vim.log.levels.ERROR)
    return
  end

  local cmd = "git-vault.sh pull"
  vim.fn.jobstart(cmd, { detach = true })
end

return M
