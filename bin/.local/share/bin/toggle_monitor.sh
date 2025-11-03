#!/bin/bash

# 定义 monitors.conf 文件的路径
MONITOR_CONF_PATH="$HOME/.config/hypr/monitors.conf"

# 检查 monitors.conf 文件是否存在
if [ ! -f "$MONITOR_CONF_PATH" ]; then
  echo "Error: monitors.conf file not found at $MONITOR_CONF_PATH"
  exit 1
fi

# 切换显示器配置的函数
toggle_monitor() {
  # 读取文件内容到变量
  current_config=$(cat "$MONITOR_CONF_PATH")

  # 判断当前配置，并切换显示器状态
  if [[ "$current_config" == *"disable internal"* ]]; then
    # enable internal monitor
    sed -i 's/monitor = eDP-1, disable/monitor = eDP-1, 2560x1600@165, 0x0, 2/' "$MONITOR_CONF_PATH"
    sed -i 's/disable internal/enable internal/' "$MONITOR_CONF_PATH"
    # sed -i 's/monitor = HDMI-A-1, 3840x2160@60, 1600x0, 2/monitor = HDMI-A-1, disable/' "$MONITOR_CONF_PATH"
    echo "eDP-1 enabled."
  elif [[ "$current_config" == *"enable internal"* ]]; then
    # disable internal monitor
    sed -i 's/monitor = eDP-1, 2560x1600@165, 0x0, 2/monitor = eDP-1, disable/' "$MONITOR_CONF_PATH"
    sed -i 's/enable internal/disable internal/' "$MONITOR_CONF_PATH"
    echo "HDMI-A-1 enabled and eDP-1 disabled."
  else
    echo "Error: No valid monitor configurations found in $MONITOR_CONF_PATH"
    exit 1
  fi

  # 输出新的配置文件内容
  echo "Updated monitor configuration:"
  cat "$MONITOR_CONF_PATH"
}

# 调用切换显示器函数
toggle_monitor
