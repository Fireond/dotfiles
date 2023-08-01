#!/bin/bash

wechat=(
	update_freq=10
	icon=$WECHAT
	icon.font="$FONT:Regular:20.0"
	icon.padding_left=10
	# background.color=$BACKGROUND_1
	# background.border_color=$BACKGROUND_2
	# background.height=30
	# background.corner_radius=9
	# background.border_width=2
	# padding_right=10
	label.padding_right=10
	script="$PLUGIN_DIR/app_status.sh"
	click_script="open -a Wechat"
)

sketchybar --add item wechat right \
	--set wechat "${wechat[@]}"
