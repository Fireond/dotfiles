#!/bin/bash

source "$CONFIG_DIR/icons.sh"
# LAYOUT="$(defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources | grep "KeyboardLayout Name" | cut -c 33- | rev | cut -c 2- | rev)"
LAYOUT="$(defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources | grep "InputSourceKind" | sed "1d" | cut -c 28- | rev | cut -c 3- | rev)"

# specify short layouts individually.
case "$LAYOUT" in
"Input Mode") SHORT_LAYOUT="中" ;;
"Keyboard Layout") SHORT_LAYOUT=$ABC ;;
*) SHORT_LAYOUT="한" ;;
esac

sketchybar --set keyboard icon="$SHORT_LAYOUT"
