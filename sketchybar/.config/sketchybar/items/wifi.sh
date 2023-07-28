#!/bin/bash

wifi=(
	icon=$WIFI_ON
	icon.font="$FONT:Regular:17.0"
	script="$PLUGIN_DIR/wifi.sh"
	update_freq=5
)

sketchybar --add item wifi right \
	--set wifi "${wifi[@]}"
