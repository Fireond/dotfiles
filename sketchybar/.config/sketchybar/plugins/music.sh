#!/bin/bash

if sketchybar --query default_menu_items | grep "$NAME" >>/dev/null; then
	sketchybar --set "$NAME" alias.scale=1 label="" label.padding_right=0
else
	sketchybar --set "$NAME" alias.scale=0 label="NetEaseMusic" label.padding_right=16
fi
