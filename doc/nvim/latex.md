# 使用Neovim优雅地编写LaTeX

## 配置框架

配置使用[LazyVim](https://www.lazyvim.org/)作为基本框架，其使用lazy.nvim作为包管理器，是现代nvim最快最强大的包管理器。
本文主要介绍LuaSnip插件中与LaTeX编写有关的配置。

LuaSnip是基于Lua的代码片段插件，相比传统Snip插件如vsnip，LuaSnip支持多种解析方式，拥有更多拓展功能，同时也有[中文版配置教程](https://zjp-cn.github.io/neovim0.6-blogs/nvim/luasnip/doc1.html)。

### AutoSnippets

通过配置`require("luasnip").config.setup({enable_autosnippets = true})`来实现启用autosnippet，在配置Snip时添加`snippetType = "autosnippet"`即可。启用后，在输入`trig`后便可自动展开Snip，而不用使用`Tab`等触发键触发。例如可以配置输入`dd`自动展开成行间公式：
```lua
s(
  { trig = "dd", snippetType = "autosnippet" },
  fmta(
    [[
    \[
      <>
    .\]
    ]],
    {
      i(0),
    }
  ),
  { condition = tex.in_text }
),
```
其中`fmta`是实现格式化的字符串，使用`<>`来作为光标位置。`condition = tex.in_text`是Snip触发的条件，只有当光标在文本环境时才会触发，在数学环境内则不会，该部分实现需使用`treesitter`插件，其具体配置在后文介绍。

### SELECT_RAW

LuaSnip可以通过配置`require("luasnip").config.setup({store_selection_keys="your key"})`来配置`store_selection_keys`，其功能是
在Visual模式下，选中目标文本并按下`store_selection_keys`后，选中文本将存储在LuaSnip的`SELECT_RAW`中，并可以通过配置实现触发Snip后自动将选中文本填入Snip中。这在LaTeX的字体等命令中很常用，如

对应的配置：
```lua
s(
  { trig = "tbf", snippetType = "autosnippet", priority = 2000 },
  fmta("\\textbf{<>}", {
    d(1, get_visual),
  })
),
```
其中`tbf`是触发键，`<>`是填入文本的位置，`get_visual`是获取选中文本的函数，其定义为
```lua
local get_visual = function(args, parent)
  if #parent.snippet.env.SELECT_RAW > 0 then
    return sn(nil, t(parent.snippet.env.SELECT_RAW))
  else -- If SELECT_RAW is empty, return a blank insert node
    return sn(nil, i(1))
  end
end
```
`priority`设为2000是为了优先调用该Snip填入`SELECT_RAW`而不是原有的`tbf`触发的`\textbf{}`。

### ChoiceNode
LuaSnip中可以使用ChoiceNode来实现LaTeX中相同命令不同参数的选择，如希望使用`sum`展开为`\sum_{<>}^{<>}`或仅有下标`\sum_{<>}`，可使用如下配置：
```lua
s(
  { trig = "sum", snippetType = "autosnippet" },
  c(1, {
    sn(nil, { t("\\sum\\limits_{"), i(1), t("} ") }),
    sn(nil, { t("\\sum\\limits_{"), i(1), t("}^{"), i(2), t("} ") }),
  }),
  { condition = tex.in_mathzone }
),
```
其中的`c()`便是ChoiceNode，可以通过lazy.nvim配置keymap设置切换Choice的按键：
```lua
{
  "L3MON4D3/LuaSnip",
  -- other configs
  keys = {
    -- other keymaps
    {
      "<c-h>",
      "<Plug>luasnip-next-choice",
      mode = { "i", "s" },
    },
    {
      "<c-p>",
      "<Plug>luasnip-prev-choice",
      mode = { "i", "s" },
    },
  }
}
```
其效果如下：

### 结合sympy或mathematica实现公式计算

LuaSnip中的dynamic_node结合`plenary`插件可以让Snip实现运行python代码，例如使用sympy实现计算积分，
其配置如下：
```lua
s(
  { trig = "sym", wordTrig = false, snippetType = "autosnippet", priority = 2000 },
  fmta("sympy <> sympy", {
    d(1, get_visual),
  }),
  { condition = tex.in_mathzone }
),
s(
  { trig = "sympy.*sympys", regTrig = true, desc = "Sympy block evaluator", snippetType = "autosnippet" },
  d(1, function(_, parent)
    local to_eval = string.gsub(parent.trigger, "^sympy(.*)sympys", "%1")
    to_eval = string.gsub(to_eval, "^%s+(.*)%s+$", "%1")
    local Job = require("plenary.job")
    local sympy_script = string.format(
      [[
from latex2sympy2 import latex2latex
import re
origin = r'%s'
# remove white space
standard = re.sub(r"\\d", "d", origin)
latex = latex2latex(standard)
output = origin + " = " + latex
print(output)
          ]],
      to_eval
    )
    sympy_script = string.gsub(sympy_script, "^[\t%s]+", "")
    local result = ""

    Job:new({
      command = "python3",
      args = {
        "-c",
        sympy_script,
      },
      on_exit = function(j)
        result = j:result()
      end,
    }):sync()

    return sn(nil, t(result))
  end)
)
```

### 特定触发条件

配合treesitter即可实现对当前光标所在的类型进行检测，从而实现使用相同的trig在不同环境触发不同效果。

在`nvim/lua/util/latex.lua`中实现对应的辅助函数：
```lua
local M = {}

local MATH_NODES = {
  displayed_equation = true,
  inline_formula = true,
  math_environment = true,
}

local ts_utils = require("nvim-treesitter.ts_utils")

M.in_env = function(env)
  local node = ts_utils.get_node_at_cursor()
  local bufnr = vim.api.nvim_get_current_buf()
  while node do
    if node:type() == "generic_environment" then
      local begin = node:child(0)
      local name = begin:field("name")
      if name[1] and vim.treesitter.get_node_text(name[1], bufnr, nil) == "{" .. env .. "}" then
        return true
      end
    end
    node = node:parent()
  end
  return false
end

M.in_text = function()
  local node = ts_utils.get_node_at_cursor()
  while node do
    if node:type() == "text_mode" then
      return true
    elseif MATH_NODES[node:type()] then
      return false
    end
    node = node:parent()
  end
  return true
end

M.in_mathzone = function()
  return not M.in_text()
end

M.in_item = function()
  return M.in_env("itemize") or M.in_env("enumerate")
end
M.in_tikz = function()
  return M.in_env("tikzpicture")
end
M.in_quantikz = function()
  return M.in_env("quantikz")
end
```
之后再Snip配置时即可通过`local tex = require("util.latex")`来实现前文的触发条件配置，同时也可以进行更复杂的条件设置，如在枚举环境（enumerate，itemize）中，配置仅当在枚举环境且位于行首时才能触发：
```lua
s({ trig = "im", snippetType = "autosnippet" }, {
  t("\\item"),
}, { condition = tex.in_item * line_begin }),
```
其中`line_begin`是LuaSnip提供的条件：`local line_begin = require("luasnip.extras.expand_conditions").line_begin`。
