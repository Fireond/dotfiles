#!/bin/bash

cava=(
	update_freq=0
	icon.padding_left=0
	icon.padding_right=0
	label.padding_left=16
	label.padding_right=16
	background.color=$BACKGROUND_1
	background.border_color=$BACKGROUND_2
	script="$PLUGIN_DIR/cava.sh"
	click_script="open -a /Applications/NetEaseMusic.app"
)

sketchybar --add item cava right \
	--set cava "${cava[@]}"
