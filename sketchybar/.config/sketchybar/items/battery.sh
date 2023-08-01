#!/bin/bash

battery=(
	script="$PLUGIN_DIR/battery.sh"
	icon.font="$FONT:Regular:19.0"
	icon.padding_right=7
	padding_right=0
	padding_left=0
	label.drawing=on
	label.padding_right=10
	update_freq=120
)

sketchybar --add item battery right \
	--set battery "${battery[@]}" \
	--subscribe battery power_source_change system_woke
