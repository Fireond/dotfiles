#!/usr/bin/env bash
set -euo pipefail

# 你可以用环境变量覆盖这些值：
#   KITTY_CLASS=latex-scratch KITTY_TITLE="LaTeX Scratch" KEEP_FILE=1 latex-scratch
CLASS="${KITTY_CLASS:-latex-scratch}"
TITLE="${KITTY_TITLE:-LaTeX Scratch}"
KEEP="${KEEP_FILE:-0}"

# 临时文件放在运行时目录更干净（Hyprland/Wayland 常有 XDG_RUNTIME_DIR）
TMPDIR="${XDG_RUNTIME_DIR:-/tmp}"
FILE="$(mktemp --tmpdir="$TMPDIR" latex-scratch-XXXXXX.tex)"

cleanup() {
  if [[ -f "$FILE" ]]; then
    if command -v wl-copy >/dev/null 2>&1; then
      wl-copy <"$FILE"
    elif command -v xclip >/dev/null 2>&1; then
      xclip -selection clipboard <"$FILE"
    elif command -v pbcopy >/dev/null 2>&1; then
      pbcopy <"$FILE"
    else
      echo "No clipboard tool found (wl-copy/xclip/pbcopy). Keeping file: $FILE" >&2
      KEEP=1
    fi

    if command -v notify-send >/dev/null 2>&1; then
      notify-send "LaTeX scratch copied" "Copied contents to clipboard."
    fi

    if [[ "$KEEP" != "1" ]]; then
      rm -f -- "$FILE"
    else
      echo "Kept file: $FILE" >&2
    fi
  fi
}
trap cleanup EXIT

# 打开 kitty，并在其中运行 nvim 编辑临时 tex 文件
# --class 方便你在 Hyprland 里写 windowrulev2
kitty --class "$CLASS" --title "$TITLE" ~/.local/share/bin/auto_padding_nvim.sh "$FILE" --cmd 'set autowriteall' --cmd 'augroup LatexScratchAutoSave | autocmd! | autocmd InsertLeave,TextChanged,TextChangedI,FocusLost,CursorHold,CursorHoldI * silent! update | autocmd VimLeavePre * silent! update | augroup END'
