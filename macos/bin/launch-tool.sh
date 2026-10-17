#!/bin/bash
set -euo pipefail
source "$HOME/.dotfiles/macos/lib/env.sh"
case "${1:-}" in
 # Tool windows use permanent titles; keep them out of the normal terminal process.
 terminal) exec kitty -1 --instance-group niri-mac-terminal --directory "$HOME" --session none ;;
 pdf) label=PDF; command=("$NIRI_MAC_ROOT/bin/search_pdf.sh") ;;
 citekey) label='Zotero Citekey'; command=("$NIRI_MAC_ROOT/bin/zotero-fzf-copy-citekey.sh") ;;
 zotero-open) label='Zotero Open'; command=("$NIRI_MAC_ROOT/bin/zotero-fzf-open.sh") ;;
 todo) [[ -f "$NIRI_MAC_TODO" ]] || { echo "TODO 路径不存在: $NIRI_MAC_TODO" >&2; exit 1; }; label=TODO; command=("$NIRI_MAC_ROOT/bin/auto_padding_nvim.sh" "$NIRI_MAC_TODO") ;;
 monitor) label=Monitor; command=(btop) ;;
 latex) exec "$NIRI_MAC_ROOT/bin/quick_latex.sh" ;;
 *) echo 'unknown tool' >&2;exit 2 ;;
esac
exec kitty -1 --instance-group niri-mac --directory "$HOME" --session none --title "niri-mac:$label" -o window_padding_width=0 "$NIRI_MAC_ROOT/bin/run-tool.sh" "${command[@]}"
