#!/bin/bash

# 使用 fzf 内置的文件搜索功能，限制文件扩展名为 pdf
pdf=$(fzf --prompt="Select a PDF file: " --preview="bat --style=numbers --color=always --line-range=:500 {}" --preview-window=right:50%:wrap --height=40% --reverse --exact --multi --query=".pdf")

# 如果用户选择了一个文件，使用 zathura 打开
if [[ -n "$pdf" ]]; then
  zathura "$pdf" &
else
  echo "No file selected."
fi
