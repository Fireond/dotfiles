#!/bin/bash

qq=(
  update_freq=10
  icon=$QQ
  icon.font="$FONT:Regular:20.0"
  # background.color=$BACKGROUND_1
  # background.border_color=$BACKGROUND_2
  script="$PLUGIN_DIR/app_status.sh"
  click_script="open -a qq"
)

tencent_bracket=(
  background.color=$BACKGROUND_1
  background.border_color=$BACKGROUND_2
)

sketchybar --add item qq right \
  --set qq "${qq[@]}"
# sketchybar --add bracket tencent qq wechat \
#   --set tencent "${tencent_bracket[@]}"
