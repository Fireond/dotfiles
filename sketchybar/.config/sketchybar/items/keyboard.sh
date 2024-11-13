#!/bin/bash

keyboard=(
  icon.font="$FONT:Regular:20.0"
  script="$PLUGIN_DIR/keyboard.sh"
)
keyboard_bracket=(
  background.color=$BACKGROUND_1
  background.border_color=$BACKGROUND_2
)

sketchybar --add item keyboard right \
  --set keyboard "${keyboard[@]}" \
  --add event keyboard_change "AppleSelectedInputSourcesChangedNotification" \
  --subscribe keyboard keyboard_change
# sketchybar --add bracket keyboard_bracket keyboard \
#   --set keyboard_bracket "${keyboard_bracket[@]}"
