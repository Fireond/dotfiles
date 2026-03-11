#!/usr/bin/env bash
set -euo pipefail

CLASS="${KITTY_CLASS:-latex-scratch}"
TITLE="${KITTY_TITLE:-LaTeX Scratch}"

TMPBASE="${XDG_RUNTIME_DIR:-/tmp}"
WORKDIR="$(mktemp -d --tmpdir="$TMPBASE" latex-scratch-XXXXXX)"
FILE="$WORKDIR/main.tex"
PDF="$WORKDIR/main.pdf"
SESSION="$WORKDIR/session.kitty"

copy_to_clipboard() {
  local f="$1"
  if command -v wl-copy >/dev/null 2>&1; then
    wl-copy <"$f"
  elif command -v xclip >/dev/null 2>&1; then
    xclip -selection clipboard <"$f"
  elif command -v pbcopy >/dev/null 2>&1; then
    pbcopy <"$f"
  else
    return 1
  fi
}

write_template() {
  cat >"$FILE" <<'EOF'
\documentclass{article}
\usepackage[paperwidth=8cm,paperheight=8cm,margin=0cm]{geometry}
\usepackage{amsmath,amssymb,mathtools}
\usepackage{tikz-cd}
\pagestyle{empty}
\begin{document}



\end{document}
EOF
}

write_session() {
  cat >"$SESSION" <<EOF
layout splits
launch --title "latex-edit" /bin/bash -lc 'exec ~/.local/share/bin/auto_padding_nvim.sh "$FILE" \
  -c "call cursor(8, 999)" -c "startinsert!" '
launch --location=vsplit --title "latex-preview" /bin/bash -lc 'exec ~/.local/share/bin/latex-scratch-preview.sh "$PDF"'
EOF
}

cleanup() {
  if [[ -f "$FILE" ]]; then
    copy_to_clipboard "$FILE" || true
  fi

  rm -rf -- "$WORKDIR"
}
trap cleanup EXIT

write_template
write_session

kitty --class "$CLASS" --title "$TITLE" --session "$SESSION"
