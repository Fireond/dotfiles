#!/bin/bash

# 配置信息
REMOTE_USER="hanyu_yan"
REMOTE_HOST="101.6.96.188"
REMOTE_PORT="2222"
REMOTE_DIR="/home/hanyu_yan"
LOCAL_DIR="$HOME/Documents/deng_server"

is_mounted() {
  mountpoint -q "$LOCAL_DIR"
}

case "$1" in
on)
  mkdir -p "$LOCAL_DIR"
  if is_mounted; then
    echo "⚠️ 已经挂载在 $LOCAL_DIR"
  else
    echo "📡 挂载 $REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR 到 $LOCAL_DIR ..."
    sshfs -p "$REMOTE_PORT" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR" "$LOCAL_DIR"
    if [ $? -eq 0 ]; then
      echo "✅ 挂载成功！"
    else
      echo "❌ 挂载失败！"
    fi
  fi
  ;;
off)
  if is_mounted; then
    echo "🔌 卸载 $LOCAL_DIR ..."
    fusermount -u "$LOCAL_DIR" 2>/dev/null || fusermount3 -u "$LOCAL_DIR" 2>/dev/null || umount "$LOCAL_DIR"
    if [ $? -eq 0 ]; then
      echo "✅ 卸载成功！"
    else
      echo "❌ 卸载失败，可能目录正被使用"
    fi
  else
    echo "⚠️ $LOCAL_DIR 当前没有挂载"
  fi
  ;;
*)
  echo "用法: $0 {on|off}"
  ;;
esac
