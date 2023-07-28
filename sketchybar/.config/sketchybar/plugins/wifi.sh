#!/bin/sh

source "$CONFIG_DIR/icons.sh"
source "$CONFIG_DIR/colors.sh"

SPEED=$(ifstat -i en0 1 1 | awk 'NR==3 {print $1}')

if ( ($(echo "$SPEED > 1024*1024" | bc -l))); then
	SPEED=$(echo "scale=0; $SPEED / (1024*1024)" | bc)
	UNIT="GB/s"
elif ( ($(echo "$SPEED > 1024" | bc -l))); then
	SPEED=$(echo "scale=0; $SPEED / 1024" | bc)
	UNIT="MB/s"
else
	SPEED=$(echo $SPEED | awk '{printf "%d", $1}')
	UNIT="KB/s"
fi

COLOR=$WHITE
if networksetup -getairportpower en0 | grep " On" >>/dev/null; then
	ICON=$WIFI_ON
else
	ICON=$WIFI_OFF
	COLOR=$RED
fi

sketchybar --set $NAME icon=$ICON icon.color=$COLOR label="${SPEED} ${UNIT}"
