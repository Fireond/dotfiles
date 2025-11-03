#!/bin/bash

# 获取参数
CLASS="$1"

# 检查是否已经运行
echo "$CLASS"
if [[ "$CLASS" == "musicfox" ]]; then
  CMD="kitty --class='musicfox' -e bash -c 'musicfox'"
  PCMD="kitty --class=musicfox -e bash -c musicfox"
fi
if [[ "$CLASS" == "write" ]]; then
  CMD="neovide --wayland_app_id=write"
  PCMD="neovide --wayland_app_id=write"
fi
if [[ "$CLASS" == "Zotero" ]]; then
  CMD="zotero"
  PCMD="zotero-bin"
fi

PID=$(pgrep -f "$PCMD")
echo "$PID"

if [[ -z "$PID" ]]; then
  # 进程不存在，启动
  echo "Don't exists"
  bash -c "$CMD"
  exit 0
fi

echo "Exists"

# 获取进程所在的 workspace
WORKSPACE_ID=$(hyprctl clients | grep -B 4 "class: $CLASS" | grep "workspace" | awk '{print $2}')
# 获取当前 workspace
CURRENT_WS=$(hyprctl activeworkspace | grep "workspace" | awk '{print $3}')

if [[ "$WORKSPACE_ID" == "$CURRENT_WS" ]]; then
  # 在当前 workspace，kill 进程
  kill "$PID"
else
  # 不在当前 workspace，移动到该窗口所在的 workspace 并 focus
  hyprctl dispatch workspace "$WORKSPACE_ID"
  hyprctl dispatch focuswindow "class:$CLASS"
fi
