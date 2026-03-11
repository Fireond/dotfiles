#!/usr/bin/env bash
set -euo pipefail

CLASS="${KITTY_CLASS:-latex-scratch}"
TITLE="${KITTY_TITLE:-LaTeX Scratch}"
KEEP="${KEEP_FILE:-0}"

# 可选：你可以放一个自己的模板在这里，脚本优先复制它
# 例如 ~/.config/latex/scratch-standalone.tex
TEMPLATE="${LATEX_SCRATCH_TEMPLATE:-$HOME/.config/latex/scratch-standalone.tex}"

TMPBASE="${XDG_RUNTIME_DIR:-/tmp}"
WORKDIR="$(mktemp -d --tmpdir="$TMPBASE" latex-scratch-XXXXXX)"
FILE="$WORKDIR/main.tex"

copy_to_clipboard() {
  local f="$1"
  if command -v wl-copy >/dev/null 2>&1; then
    wl-copy <"$f"
  elif command -v xclip >/dev/null 2>&1; then
    xclip -selection clipboard <"$f"
  elif command -v pbcopy >/dev/null 2>&1; then
    pbcopy <"$f"
  else
    echo "No clipboard tool found (wl-copy/xclip/pbcopy)." >&2
    return 1
  fi
}

write_default_template() {
  cat >"$FILE" <<'EOF'
%! TEX program = pdflatex
\documentclass[tikz,border=2pt]{standalone}
\usepackage{amsmath,amssymb,mathtools}
\usepackage{tikz-cd}
\usetikzlibrary{cd}

\begin{document}



\end{document}
EOF
}

cleanup() {
  if [[ -f "$FILE" ]]; then
    copy_to_clipboard "$FILE" || KEEP=1
  fi

  if [[ "$KEEP" == "1" ]]; then
    echo "Kept scratch dir: $WORKDIR" >&2
  else
    rm -rf -- "$WORKDIR"
  fi
}
trap cleanup EXIT

if [[ -f "$TEMPLATE" ]]; then
  cp "$TEMPLATE" "$FILE"
else
  write_default_template
fi

kitty --class "$CLASS" --title "$TITLE" \
  ~/.local/share/bin/auto_padding_nvim.sh "$FILE" \
  -c 'set autowriteall' \
  -c 'set updatetime=300'
# -c 'augroup LatexScratchAuto | autocmd! | autocmd InsertLeave,TextChanged,TextChangedI,FocusLost,CursorHold,CursorHoldI *.tex silent! update | autocmd VimLeavePre * silent! update | autocmd VimLeavePre * silent! VimtexStop | autocmd User VimtexEventCompileSuccess ++once silent! VimtexView | augroup END' \
# -c 'silent! VimtexCompile'
