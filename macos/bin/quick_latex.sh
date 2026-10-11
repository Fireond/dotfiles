#!/bin/bash
set -euo pipefail
source "$HOME/.dotfiles/macos/lib/env.sh"
for tool in latexmk pdflatex pdftoppm nvim kitty; do command -v "$tool" >/dev/null || { echo "缺少依赖: $tool" >&2;exit 1; };done
scratch=$(mktemp -d "${TMPDIR:-/tmp}/niri-mac-latex.XXXXXX")
export NIRI_MAC_LATEX_DIR="$scratch"
cat >"$scratch/main.tex" <<'EOF'
\documentclass{article}
\usepackage[paperwidth=20cm,paperheight=5cm,margin=0cm]{geometry}
\usepackage{amsmath,amssymb,mathtools}
\usepackage{tikz-cd}
\pagestyle{empty}
\begin{document}



\null
\end{document}
EOF
# A pre-existing single-instance kitty server does not inherit this process's
# exported variables. Store concrete, shell-quoted arguments in the session.
python3 - "$scratch" "$NIRI_MAC_ROOT" <<'PY'
import pathlib,shlex,sys
scratch,root=map(pathlib.Path,sys.argv[1:])
commands=[['launch','--title','latex-edit','/bin/bash',str(root/'bin/auto_padding_nvim.sh'),str(scratch/'main.tex'),'-c','call cursor(8,999)','-c','startinsert!','-c','silent! VimtexCompile'],
          ['launch','--location=hsplit','--bias=50','--title','latex-preview','/bin/bash',str(root/'bin/latex-preview.sh'),str(scratch)]]
(scratch/'session.kitty').write_text('layout splits\ncd '+shlex.quote(str(scratch))+'\n'+'\n'.join(shlex.join(c) for c in commands)+'\n')
PY
# Keep the scratch source until macOS cleans TMPDIR, so an accidental close
# does not destroy an unfinished formula. Text copying stays explicit in Vim.
exec kitty -1 --instance-group niri-mac --wait-for-single-instance-window-close --title 'niri-mac:LaTeX' --session "$scratch/session.kitty" -o window_padding_width=0
