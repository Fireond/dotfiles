#!/usr/bin/env bash

# 检查Waybar是否正在运行
if pgrep -x "waybar" >/dev/null; then
  # 如果正在运行则终止
  pkill -x "waybar"
  pkill -x "waybar_timer"
else
  # 检查waybar_timer是否在运行
  if ! pgrep -x "waybar_timer" >/dev/null; then
    # 启动waybar_timer服务（后台运行）
    waybar_timer serve &
  fi
  # 启动Waybar（后台运行）
  waybar &
fi
