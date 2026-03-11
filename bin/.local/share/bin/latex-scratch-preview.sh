#!/usr/bin/env bash
set -euo pipefail

PDF="${1:?need pdf path}"
PNG_DIR="$(dirname "$PDF")/.preview"
PNG="$PNG_DIR/page1.png"

mkdir -p "$PNG_DIR"

render() {
  # 清屏，避免旧图片残留
  printf '\033c'

  if [[ ! -f "$PDF" ]]; then
    echo "Waiting for PDF: $PDF"
    return
  fi

  # 只转第一页，分辨率够看 tikzcd/公式
  pdftoppm -png -singlefile -f 1 -r 180 "$PDF" "$PNG_DIR/page1" >/dev/null 2>&1 || {
    echo "Failed to render PDF"
    return
  }

  # 在 kitty pane 中显示图片
  kitty +kitten icat --clear --transfer-mode=memory --unicode-placeholder "$PNG"
}

if command -v inotifywait >/dev/null 2>&1; then
  render
  while true; do
    inotifywait -q -e close_write,create,move "$(dirname "$PDF")" >/dev/null 2>&1 || true
    render
  done
else
  last_mtime=""
  while true; do
    if [[ -f "$PDF" ]]; then
      mtime="$(stat -c %Y "$PDF" 2>/dev/null || echo '')"
      if [[ "$mtime" != "$last_mtime" ]]; then
        last_mtime="$mtime"
        render
      fi
    else
      printf '\033c'
      echo "Waiting for PDF: $PDF"
    fi
    sleep 0.4
  done
fi
