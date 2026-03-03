local M = {}

M.config = {
  assets_dir = "assets",
  default_title_prefix = "tikzcd",
  tex_engine = "pdflatex",
  extra_preamble = "",
}

local function notify(msg, level)
  vim.notify(msg, level or vim.log.levels.INFO, { title = "tikzcd-svg" })
end

local function trim(s)
  return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function strip_display_math_wrappers(s)
  local t = trim(s)

  if t:match("^%$%$") and t:match("%$%$$") then
    t = t:gsub("^%$%$%s*", "")
    t = t:gsub("%s*%$%$$", "")
  elseif t:match("^\\%[") and t:match("\\%]$") then
    t = t:gsub("^\\%[%s*", "")
    t = t:gsub("%s*\\%]$", "")
  end

  return trim(t)
end

local function slugify(s)
  s = s:lower()
  s = s:gsub("[^%w%s%-_]", "")
  s = s:gsub("%s+", "-")
  s = s:gsub("%-+", "-")
  s = s:gsub("^%-+", ""):gsub("%-+$", "")

  if s == "" then
    s = M.config.default_title_prefix .. "-" .. os.date("%Y%m%d-%H%M%S")
  end
  return s
end

local function unique_filename(dir, stem, ext)
  local name = stem .. ext
  local path = dir .. "/" .. name
  local i = 2

  while vim.fn.filereadable(path) == 1 do
    name = string.format("%s-%d%s", stem, i, ext)
    path = dir .. "/" .. name
    i = i + 1
  end

  return name, path
end

local function escape_md_alt(s)
  return s:gsub("%[", "\\["):gsub("%]", "\\]")
end

local function run(cmd, cwd)
  local ok, proc = pcall(vim.system, cmd, {
    cwd = cwd,
    text = true,
  })
  if not ok then
    return nil, proc
  end

  local res = proc:wait()
  if res.code ~= 0 then
    local msg = (res.stderr and res.stderr ~= "" and res.stderr)
      or (res.stdout and res.stdout ~= "" and res.stdout)
      or ("command failed: " .. table.concat(cmd, " "))
    return nil, msg
  end

  return res, nil
end

local function get_visual_region(bufnr)
  local start_mark = vim.api.nvim_buf_get_mark(bufnr, "<")
  local end_mark = vim.api.nvim_buf_get_mark(bufnr, ">")

  if start_mark[1] == 0 or end_mark[1] == 0 then
    return nil, "没有找到可视选区"
  end

  local srow, scol = start_mark[1] - 1, start_mark[2]
  local erow, ecol_incl = end_mark[1] - 1, end_mark[2]

  -- 规范化顺序（兼容反向选择）
  if srow > erow or (srow == erow and scol > ecol_incl) then
    srow, erow = erow, srow
    scol, ecol_incl = ecol_incl, scol
  end

  local ecol
  if ecol_incl == vim.v.maxcol then
    local last_line = vim.api.nvim_buf_get_lines(bufnr, erow, erow + 1, false)[1] or ""
    ecol = #last_line
  else
    ecol = ecol_incl + 1
  end

  local lines = vim.api.nvim_buf_get_text(bufnr, srow, scol, erow, ecol, {})

  return {
    srow = srow,
    scol = scol,
    erow = erow,
    ecol = ecol,
    lines = lines,
  }, nil
end

function M.convert_visual()
  local bufnr = 0
  local bufname = vim.api.nvim_buf_get_name(bufnr)

  if bufname == "" then
    notify("请先保存当前 Markdown 文件，再生成相对路径 ./assets", vim.log.levels.ERROR)
    return
  end

  if vim.fn.executable(M.config.tex_engine) ~= 1 then
    notify("找不到 " .. M.config.tex_engine, vim.log.levels.ERROR)
    return
  end

  if vim.fn.executable("dvisvgm") ~= 1 then
    notify("找不到 dvisvgm", vim.log.levels.ERROR)
    return
  end

  local region, err = get_visual_region(bufnr)
  if not region then
    notify(err, vim.log.levels.ERROR)
    return
  end

  local raw = table.concat(region.lines, "\n")
  local tikz = strip_display_math_wrappers(raw)

  if not tikz:match("\\begin%s*{tikzcd}") then
    notify("选中的内容里没有检测到 \\begin{tikzcd} ... \\end{tikzcd}", vim.log.levels.ERROR)
    return
  end

  local default_title = M.config.default_title_prefix .. "-" .. os.date("%Y%m%d-%H%M%S")
  local title = vim.fn.input("Image title: ", default_title)
  if title == nil or title == "" then
    title = default_title
  end

  local stem = slugify(title)

  local file_dir = vim.fn.fnamemodify(bufname, ":p:h")
  local assets_dir = file_dir .. "/" .. M.config.assets_dir
  vim.fn.mkdir(assets_dir, "p")

  local filename, target_svg = unique_filename(assets_dir, stem, ".svg")
  local rel_svg = "./" .. M.config.assets_dir .. "/" .. filename

  local tmpdir = vim.fn.tempname()
  vim.fn.mkdir(tmpdir, "p")

  local texfile = tmpdir .. "/diagram.tex"
  local pdffile = tmpdir .. "/diagram.pdf"

  local tex_source = table.concat({
    "\\documentclass[tikz,border=2pt]{standalone}",
    "\\usepackage{tikz-cd}",
    "\\usepackage{amsmath,amssymb}",
    M.config.extra_preamble,
    "\\begin{document}",
    tikz,
    "\\end{document}",
    "",
  }, "\n")

  vim.fn.writefile(vim.split(tex_source, "\n", { plain = true }), texfile)

  local ok1, err1 = run({
    M.config.tex_engine,
    "-interaction=nonstopmode",
    "-halt-on-error",
    "diagram.tex",
  }, tmpdir)

  if not ok1 then
    vim.fn.delete(tmpdir, "rf")
    notify("LaTeX 编译失败：\n" .. err1, vim.log.levels.ERROR)
    return
  end

  local ok2, err2 = run({
    "dvisvgm",
    "--pdf",
    "--output=" .. rel_svg,
    pdffile,
  }, file_dir)

  vim.fn.delete(tmpdir, "rf")

  if not ok2 then
    notify("SVG 转换失败：\n" .. err2, vim.log.levels.ERROR)
    return
  end

  local indent = ""
  if region.scol == 0 then
    local first_line = region.lines[1] or ""
    indent = first_line:match("^%s*") or ""
  end

  local markdown = indent .. "![" .. escape_md_alt(title) .. "](" .. rel_svg .. ")"

  -- vim.api.nvim_buf_set_text(bufnr, region.srow, region.scol, region.erow, region.ecol, { markdown })
  vim.api.nvim_buf_set_lines(bufnr, region.erow + 1, region.erow + 1, false, { "", markdown })

  notify("已生成 " .. rel_svg)
end

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})

  vim.api.nvim_create_user_command("TikzcdToSvg", function()
    require("tikzcd_svg").convert_visual()
  end, {
    desc = "Convert selected tikzcd to local SVG and replace with Markdown image",
    range = true,
  })

  vim.keymap.set("x", "<leader>tg", [[:<C-u>TikzcdToSvg<CR>]], {
    silent = true,
    desc = "tikzcd -> svg",
  })
end

return M
