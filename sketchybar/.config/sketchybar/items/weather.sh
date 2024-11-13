#!/bin/bash

weather=(
  script="$PLUGIN_DIR/weather.sh"
  icon.font="$FONT:Regular:19.0"
  icon=
  icon.padding_right=7
  padding_right=0
  label.drawing=on
  label.padding_right=0
  update_freq=1800
)

weather_moon=(
  background.padding_right=-1
  icon.font="$FONT:Regular:19.0"
  icon.padding_left=4
  icon.padding_right=3
  label.drawing=off
)

sketchybar --add item weather.moon right \
  --set weather.moon "${weather_moon[@]}" \
  --subscribe weather.moon mouse.clicked

sketchybar --add item weather right \
  --set weather "${weather[@]}" \
  --subscribe weather system_woke
