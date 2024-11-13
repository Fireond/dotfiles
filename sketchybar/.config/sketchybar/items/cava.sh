#!/bin/bash

cava=(
  update_freq=0
  label.padding_left=10
  label.padding_right=10
  padding_right=10
  background.color=$BACKGROUND_1
  background.border_color=$BACKGROUND_2
  script="$PLUGIN_DIR/cava.sh"
  click_script="open -a /Applications/QQMusic.app"
)

sketchybar --add item cava right \
  --set cava "${cava[@]}"
