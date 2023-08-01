#!/bin/sh

# brew install cava
# brew install --cask background-music

PLUGIN_DIR="$HOME/.config/sketchybar/plugins"

while true; do
	cava -p $PLUGIN_DIR/cava.conf | sed -u 's/ //g; s/0/▁/g; s/1/▂/g; s/2/▃/g; s/3/▄/g; s/4/▅/g; s/5/▆/g; s/6/▇/g; s/7/█/g; s/8/█/g' | while read line; do
		sketchybar --set $NAME label=$line
	done

	sleep 5
done
