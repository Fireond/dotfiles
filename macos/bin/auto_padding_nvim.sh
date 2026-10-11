#!/bin/bash
set -u
source "$HOME/.dotfiles/macos/lib/env.sh"
socket="${KITTY_LISTEN_ON:-}"
spacing() {
  [[ -n "$socket" ]] || return 0
  kitty @ --to "$socket" set-spacing --match "id:${KITTY_WINDOW_ID:-0}" "padding=$1" >/dev/null 2>&1 || true
}
spacing 0
trap 'spacing default' EXIT
/opt/homebrew/bin/nvim "$@"
