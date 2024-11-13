#!/bin/bash

music=(
  script="$PLUGIN_DIR/music.sh"
  click_script="open -a /Applications/NetEaseMusic.app"
)

sketchybar --add alias 'QQ音乐' right
sketchybar --set 'QQ音乐' alias.color=$WHITE
