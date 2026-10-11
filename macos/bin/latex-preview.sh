#!/bin/bash
set -u
source "$HOME/.dotfiles/macos/lib/env.sh"
dir=${1:?scratch directory required}
if ! pdftoppm -v >"$dir/preview.log" 2>&1; then
  cat "$dir/preview.log" >&2
  printf 'PDF 渲染器不可用；修复 Poppler 后重新打开草稿。\n' >&2
  exit 1
fi
last=''
printf '保存 main.tex 后自动预览。VimTeX 持续编译；可用 VimtexView 在 Skim 查看。\n'
while :; do
  if [[ -s "$dir/main.pdf" ]]; then
    stamp=$(/usr/bin/stat -f '%m:%z' "$dir/main.pdf")
    dims="$(tput cols 2>/dev/null):$(tput lines 2>/dev/null)"
    if [[ "$stamp:$dims" != "$last" ]]; then
      if pdftoppm -singlefile -f 1 -scale-to 1800 -png "$dir/main.pdf" "$dir/preview" >"$dir/preview.log" 2>&1; then
        printf '\033[2J\033[H'
        kitty +kitten icat --clear --stdin=no --transfer-mode=memory "$dir/preview.png"
        last="$stamp:$dims"
      else
        printf '本次预览失败，等待 PDF 更新；详情：%s/preview.log\n' "$dir" >&2
        last="$stamp:$dims"
      fi
    fi
  fi
  sleep 0.5
done
