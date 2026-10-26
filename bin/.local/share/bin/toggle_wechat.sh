#!/usr/bin/env bash
# niri: Ctrl+Alt+W hides the focused WeChat main window, or brings it here.
# Hiding uses WeChat's close-to-tray behavior; keep that option enabled.
set -euo pipefail

fail() {
  printf 'toggle_wechat: %s\n' "$1" >&2
  if command -v notify-send >/dev/null 2>&1; then
    notify-send "微信快捷键" "$1" || true
  fi
  exit 1
}

for dependency in niri jq flock gtk-launch; do
  command -v "$dependency" >/dev/null 2>&1 || fail "缺少命令：$dependency"
done

# Ignore overlapping presses, including while WeChat is starting up.
runtime_dir="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
[[ -d "$runtime_dir" && -O "$runtime_dir" ]] || fail "找不到当前用户的运行目录"
exec 9>"$runtime_dir/toggle_wechat.lock"
flock -n 9 || exit 0

# Use the stable workspace ID, not a monitor-local index. Snapshot it BEFORE
# launching WeChat, since restoring from the tray may change the focused workspace.
workspace_id="$(
  niri msg --json workspaces |
    jq -er '.[] | select(.is_focused) | .id'
)" || fail "无法读取 niri 当前工作区"

main_window() {
  # Settings, image previews and detached chats share the app-id. Only target
  # the main/login window, including its optional unread-count title suffix.
  jq -c '
    [.[]
     | select((.app_id // "") | test("^(wechat|weixin|com\\.tencent\\.(wechat|weixin))$"; "i"))
     | select((.title // "") | test("^(WeChat|Weixin|微信)([[:space:]]*[(][0-9]+[)])?$"; "i"))]
    | sort_by([.is_focused, (.focus_timestamp.secs // 0), (.focus_timestamp.nanos // 0)])
    | last // empty
  '
}

window="$(niri msg --json windows | main_window)" || fail "无法读取微信窗口"

if [[ -n "$window" ]] &&
  jq -e --argjson workspace "$workspace_id" \
    '.is_focused and .workspace_id == $workspace' <<<"$window" >/dev/null; then
  # The observed native client closes to the tray without exiting its process.
  window_id="$(jq -r '.id' <<<"$window")"
  niri msg action close-window --id "$window_id" >/dev/null || fail "无法隐藏微信窗口"
  exit 0
fi

if [[ -z "$window" ]]; then
  # Use the desktop entry, retaining the user's Wayland/input-method environment.
  # The existing instance restores its main window; otherwise WeChat starts up.
  # niri spawn supplies an activation token. Direct SNI Activate is ineffective
  # with this client's current native Wayland setup.
  niri msg action spawn -- gtk-launch wechat >/dev/null || fail "无法启动微信"
  for ((attempt = 0; attempt < 150; attempt++)); do
    window="$(niri msg --json windows | main_window)" || fail "无法读取微信窗口"
    [[ -n "$window" ]] && break
    sleep 0.1
  done
  [[ -n "$window" ]] || fail "等待微信主窗口超时，请检查微信是否已正常启动"
fi

window_id="$(jq -r '.id' <<<"$window")"
if [[ "$(jq -r '.workspace_id' <<<"$window")" != "$workspace_id" ]]; then
  # Addressing the workspace by ID also handles a window on another monitor.
  # Do not follow it to its old workspace before moving it.
  jq -cn --argjson window "$window_id" --argjson workspace "$workspace_id" '
    {Action: {MoveWindowToWorkspace: {
      window_id: $window, reference: {Id: $workspace}, focus: false
    }}}
  ' | niri msg --json raw-request >/dev/null || fail "无法将微信移动到当前工作区"
fi
niri msg action focus-window --id "$window_id" >/dev/null || fail "无法聚焦微信窗口"
