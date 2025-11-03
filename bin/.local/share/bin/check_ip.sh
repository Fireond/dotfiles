#!/bin/bash

# 要保存的文件路径
IP_FILE="$HOME/Documents/sync/lab_ip.txt"

# 获取当前 IPv4 地址 (eno1 网卡)
CURRENT_IP=$(ip -4 addr show eno1 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

# 如果文件不存在，就写入
if [ ! -f "$IP_FILE" ]; then
  echo "$CURRENT_IP" >"$IP_FILE"
  exit 0
fi

# 读取旧的 IP
OLD_IP=$(cat "$IP_FILE")

# 如果不同，就更新
if [ "$CURRENT_IP" != "$OLD_IP" ]; then
  echo "IP changed: $OLD_IP -> $CURRENT_IP"
  echo "$CURRENT_IP" >"$IP_FILE"
fi
