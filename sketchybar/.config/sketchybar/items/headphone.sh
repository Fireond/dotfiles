#!/bin/bash

headphone=(
  script="$PLUGIN_DIR/headphone.sh"
  icon.font="$FONT:Regular:19.0"
  icon="󰋋"
  update_freq=120
)

headphone_braket=(
  background.color=$BACKGROUND_1
  background.border_color=$BACKGROUND_2
)

sketchybar --add event bluetooth_change "com.apple.bluetooth.status" \
  --add item headphone right \
  --set headphone "${headphone[@]}" \
  --subscribe headphones bluetooth_change

# sketchybar --add alias "Control Center,Sound" right

# sketchybar --add bracket headphone_braket headphone \
#   --set headphone_braket "${headphone_braket[@]}"
