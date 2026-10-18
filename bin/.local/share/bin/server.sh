#!/bin/bash

usage() {
  echo "用法: $0 {on|off} [服务器名称 ...]"
  echo "不指定服务器名称时，操作 bin.local.sh 中的全部服务器。"
}

case "${1:-}" in
  on|off) action=$1; shift ;;
  *) usage; exit 1 ;;
esac

CONFIG_FILE="$HOME/.local/share/bin/bin.local.sh"
if [[ ! -r "$CONFIG_FILE" ]]; then
  echo "❌ 无法读取配置文件: $CONFIG_FILE" >&2
  exit 1
fi

declare -a SERVERS=()
declare -A REMOTE_USERS=() REMOTE_HOSTS=() REMOTE_PORTS=() REMOTE_DIRS=() LOCAL_DIRS=()
source "$CONFIG_FILE" || exit 1

if (( ${#SERVERS[@]} == 0 )); then
  echo "❌ 请在 $CONFIG_FILE 中配置 SERVERS 和对应的挂载信息" >&2
  exit 1
fi

# 在进行挂载或卸载前检查所有配置，避免配置错误时只执行一部分操作。
declare -A known_servers=() known_dirs=()
for server in "${SERVERS[@]}"; do
  if [[ ! "$server" =~ ^[a-zA-Z0-9_-]+$ ]]; then
    echo "❌ 服务器名称只能包含字母、数字、下划线和连字符: $server" >&2
    exit 1
  fi
  if [[ -n "${known_servers[$server]:-}" ]]; then
    echo "❌ 重复的服务器名称: $server" >&2
    exit 1
  fi
  known_servers[$server]=1
  if [[ -z "${REMOTE_USERS[$server]:-}" || -z "${REMOTE_HOSTS[$server]:-}" ||
        -z "${REMOTE_DIRS[$server]:-}" || -z "${LOCAL_DIRS[$server]:-}" ]]; then
    echo "❌ $server 缺少用户、主机、远程目录或本地目录配置" >&2
    exit 1
  fi
  port=${REMOTE_PORTS[$server]:-22}
  if [[ ! "$port" =~ ^[0-9]{1,5}$ ]] || (( 10#$port < 1 || 10#$port > 65535 )); then
    echo "❌ $server 的端口无效: $port" >&2
    exit 1
  fi
  if [[ "${LOCAL_DIRS[$server]}" != /* ]]; then
    echo "❌ $server 的本地目录必须使用绝对路径" >&2
    exit 1
  fi
  local_dir=$(realpath -m -- "${LOCAL_DIRS[$server]}") || exit 1
  if [[ -n "${known_dirs[$local_dir]:-}" ]]; then
    echo "❌ $server 与 ${known_dirs[$local_dir]} 使用相同的本地目录: $local_dir" >&2
    exit 1
  fi
  known_dirs[$local_dir]=$server
done

if (( $# > 0 )); then
  selected_servers=("$@")
else
  selected_servers=("${SERVERS[@]}")
fi
for server in "${selected_servers[@]}"; do
  if [[ ! "$server" =~ ^[a-zA-Z0-9_-]+$ ]] || [[ -z "${known_servers[$server]:-}" ]]; then
    echo "❌ 未配置的服务器: $server" >&2
    exit 1
  fi
done

result=0
for server in "${selected_servers[@]}"; do
  local_dir=${LOCAL_DIRS[$server]}
  if [[ "$action" == on ]]; then
    if ! mkdir -p -- "$local_dir"; then
      echo "❌ [$server] 无法创建本地目录: $local_dir" >&2
      result=1
      continue
    fi
    if mountpoint -q -- "$local_dir"; then
      echo "⚠️ [$server] 已经挂载在 $local_dir"
      continue
    fi
    host=${REMOTE_HOSTS[$server]}
    # IPv6 地址需要方括号，以便与远程路径中的冒号区分。
    if [[ "$host" == *:* && "$host" != \[*\] ]]; then
      host="[$host]"
    fi
    remote="${REMOTE_USERS[$server]}@$host:${REMOTE_DIRS[$server]}"
    echo "📡 [$server] 挂载 $remote 到 $local_dir ..."
    if sshfs -p "${REMOTE_PORTS[$server]:-22}" "$remote" "$local_dir" \
      -o reconnect -o ServerAliveInterval=15 -o ServerAliveCountMax=3; then
      echo "✅ [$server] 挂载成功！"
    else
      echo "❌ [$server] 挂载失败！" >&2
      result=1
    fi
  else
    if ! mountpoint -q -- "$local_dir"; then
      echo "⚠️ [$server] $local_dir 当前没有挂载"
      continue
    fi
    echo "🔌 [$server] 卸载 $local_dir ..."
    if fusermount -u "$local_dir" 2>/dev/null ||
       fusermount3 -u "$local_dir" 2>/dev/null || umount "$local_dir"; then
      echo "✅ [$server] 卸载成功！"
    else
      echo "❌ [$server] 卸载失败，可能目录正被使用" >&2
      result=1
    fi
  fi
done
exit "$result"
