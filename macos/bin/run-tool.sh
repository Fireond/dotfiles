#!/bin/bash
source "$HOME/.dotfiles/macos/lib/env.sh"
"$@"
result=$?
if [[ $result != 0 && $result != 130 ]]; then
  printf '\n工具退出，状态 %s。按回车关闭。\n' "$result"
  read -r _
fi
exit "$result"
