#!/usr/bin/env bash

set -euo pipefail

if (($# < 2)); then
  echo "用法: $0 <app-id-regex> <command> [args...]" >&2
  exit 2
fi

app_id_regex="$1"
shift

if ! command -v jq >/dev/null 2>&1; then
  notify-send "focus-or-launch" "缺少 jq，请执行：sudo pacman -S jq"
  exit 1
fi

# 查找符合 app_id 的第一个窗口。
window_id="$(
  niri msg --json windows |
    jq -r --arg regex "$app_id_regex" '
            [
                .[]
                | select(
                    (.app_id // "")
                    | test($regex; "i")
                )
            ][0].id // empty
        '
)"

if [[ -n "$window_id" ]]; then
  # 目标窗口存在：切换到它所在的工作区/显示器并聚焦。
  exec niri msg action focus-window --id "$window_id"
fi

# 目标窗口不存在：启动应用。
if ! command -v "$1" >/dev/null 2>&1 && [[ "$1" != */* ]]; then
  notify-send "focus-or-launch" "启动命令不存在：$1"
  exit 127
fi

setsid -f "$@" >/dev/null 2>&1
