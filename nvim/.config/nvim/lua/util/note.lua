local M = {}

-- Note root path
M.note_root_path = "~/Documents/Latex/Notes/"
M.note_master = [[
\documentclass[12pt]{article}
\input{~/Documents/Latex/preamble.tex}
\begin{document}
\title{}
\author{Fireond}
\date{\today}
\maketitle
\tableofcontents
\newpage


\end{document}
]]

-- Create a new note
function M.add_note()
  local name = vim.fn.input("Enter note name: ")
  if name == "" then
    vim.notify("Note name cannot be empty!", vim.log.levels.ERROR)
    return
  end
  local path = vim.fn.expand(M.note_root_path .. name)
  local master_file = path .. "/master.tex"

  -- Create the directory if it doesn't exist
  vim.fn.mkdir(path, "p")
  vim.fn.mkdir(path .. "/figures", "p")

  -- Create the master.tex file if it doesn't exist
  if vim.fn.filereadable(master_file) == 0 then
    local file = io.open(master_file, "w")
    if file then
      file:write(M.note_master)
      file:close()
      vim.notify("Note created at: " .. master_file, vim.log.levels.INFO)
      vim.cmd("edit " .. master_file)
    else
      vim.notify("Error creating file: " .. master_file, vim.log.levels.ERROR)
    end
  else
    vim.notify("Note already exists: " .. master_file, vim.log.levels.INFO)
  end
end

function M.find_note()
  local fzf = require("fzf-lua")
  local root = vim.fn.expand(M.note_root_path)

  -- 使用 fd 列出第一层目录
  fzf.fzf_exec("fd -t d -d 1 . " .. root, {
    prompt = "Select a note: ",
    actions = {
      ["default"] = function(selected)
        -- 获取选择的文件夹
        local folder = selected[1]

        -- 使用 fd 在文件夹中列出文件
        fzf.fzf_exec("fd -t f -e tex . " .. folder, {
          prompt = "Select a file: ",
          actions = {
            ["default"] = function(selected_file)
              -- 打开选中的文件
              vim.cmd("edit " .. selected_file[1])
            end,
          },
        })
      end,
    },
  })
end

function M.add_section()
  local current_file = vim.fn.expand("%:p")
  local root = vim.fn.expand(M.note_root_path)

  -- 检查当前文件是否在 note_root_path 下
  if not vim.startswith(current_file, root) then
    print("Current buffer is not in the notes directory!")
    return
  end

  -- 获取笔记名称（note 的子文件夹名）
  local relative_path = current_file:sub(#root + 1) -- 去掉 root 部分
  local note_name = relative_path:match("([^/]+)/") -- 匹配第一层文件夹名
  if not note_name then
    vim.notify("Unable to determine the note name!", vim.log.levels.INFO)
    return
  end

  local note_path = root .. note_name .. "/"
  local master_file = note_path .. "master.tex"

  -- 确定新的 section 文件名
  local section_num = 1
  local section_file
  repeat
    section_file = note_path .. "sec_" .. section_num .. ".tex"
    section_num = section_num + 1
  until vim.fn.filereadable(section_file) == 0

  -- 创建新的 section 文件
  local file = io.open(section_file, "w")
  if file then
    file:write("% " .. note_name .. ": section " .. (section_num - 1) .. "\n")
    file:close()
    vim.notify("Section created: " .. section_file, vim.log.levels.INFO)
  else
    vim.notify("Error creating section file: " .. section_file, vim.log.levels.ERROR)
    return
  end

  -- 检查 master.tex 是否存在
  if vim.fn.filereadable(master_file) == 0 then
    vim.notify("master.tex not found in " .. note_path, vim.log.levels.ERROR)
    return
  end

  -- 在 master.tex 中添加 \input{sec_<num>.tex}
  local master_lines = {}
  for line in io.lines(master_file) do
    table.insert(master_lines, line)
  end

  -- 找到 \end{document} 的位置并插入 \input{}
  local inserted = false
  for i, line in ipairs(master_lines) do
    if line:match("\\end{document}") then
      table.insert(master_lines, i, "\\input{sec_" .. (section_num - 1) .. ".tex}")
      inserted = true
      break
    end
  end

  if not inserted then
    vim.notify("Error: \\end{document} not found in master.tex", vim.log.levels.ERROR)
    return
  end

  -- 写回 master.tex
  local master_file_handle = io.open(master_file, "w")
  if master_file_handle then
    for _, line in ipairs(master_lines) do
      master_file_handle:write(line .. "\n")
    end
    master_file_handle:close()
    vim.notify("Updated master.tex with new section: sec_" .. (section_num - 1) .. ".tex", vim.log.levels.INFO)
  end

  vim.cmd("edit " .. section_file)
end

return M
