#!/usr/bin/env bash
set -euo pipefail

WAYBAR_BIN="${WAYBAR_BIN:-waybar}"
TIMER_BIN="${TIMER_BIN:-waybar_timer}"

CFG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/waybar"

# stop if already running
if pgrep -x waybar >/dev/null; then
  pkill -x waybar
  pkill -x waybar_timer 2>/dev/null || true
  exit 0
fi

# detect compositor
compositor=""
if [[ -n "${NIRI_SOCKET:-}" ]] || pgrep -x niri >/dev/null; then
  compositor="niri"
elif [[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]] || pgrep -x Hyprland >/dev/null; then
  compositor="hypr"
else
  echo "Could not detect niri or Hyprland" >&2
  exit 1
fi

# start timer if needed
if ! pgrep -x waybar_timer >/dev/null; then
  "$TIMER_BIN" serve &
fi

case "$compositor" in
niri)
  exec waybar -c "$CFG_DIR/config-niri.jsonc"
  ;;
hypr)
  exec waybar -c "$CFG_DIR/config.jsonc"
  ;;
esac
