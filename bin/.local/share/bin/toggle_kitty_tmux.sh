#!/bin/bash

# 获取参数
CLASS="$1"

# 检查是否已经运行
echo "$CLASS"
if [[ "$CLASS" == "musicfox" ]]; then
  PID_1=$(pgrep -f "kitty --class=musicfox -e bash -c tmux new -s musicfox -d \"musicfox\" && tmux split-window -h -p 40 -t musicfox \"cava\" && tmux attach -t musicfox")
fi
if [[ "$CLASS" == "write" ]]; then
  PID_1=$(pgrep -f "kitty --class=write -e bash -c tmux new-session -d -s write && tmux send-keys -t write.1 \"z obs\" ENTER \"v\" ENTER \"s\" && tmux attach -t write")
fi
PID_2=$(pgrep -f "kitty --class=$CLASS sh -c tmux new -As $CLASS")

if [[ -z "$PID_1" && -z "$PID_2" ]]; then
  # 进程不存在，启动
  kitty --class="$CLASS" sh -c "tmux new -As $CLASS" &
  exit 0
fi

# 获取进程所在的 workspace
WORKSPACE_ID=$(hyprctl clients | grep -B 4 "class: $CLASS" | grep "workspace" | awk '{print $2}')
# 获取当前 workspace
CURRENT_WS=$(hyprctl activeworkspace | grep "workspace" | awk '{print $3}')

if [[ "$WORKSPACE_ID" == "$CURRENT_WS" ]]; then
  # 在当前 workspace，kill 进程
  kill "$PID_2"
else
  # 不在当前 workspace，移动到该窗口所在的 workspace 并 focus
  hyprctl dispatch workspace "$WORKSPACE_ID"
  hyprctl dispatch focuswindow "class:$CLASS"
fi
