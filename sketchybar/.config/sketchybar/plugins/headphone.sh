#!/usr/bin/env bash

DEVICES="$(system_profiler SPBluetoothDataType -json -detailLevel basic 2>/dev/null | jq -rc '.SPBluetoothDataType[0].device_connected[] | select ( .[] | .device_minorType == "Headphones")' | jq '.[]')"
if [ "$DEVICES" = "" ]; then
  sketchybar -m --set $NAME label=""
else
  left="$(echo $DEVICES | jq -r .device_batteryLevelLeft)"
  right="$(echo $DEVICES | jq -r .device_batteryLevelRight)"
  main="$(echo $DEVICES | jq -r .device_batteryLevelMain)"
  case="$(echo $DEVICES | jq -r .device_batteryLevelCase)"

  if [[ "$main" != "null" ]]; then
    sketchybar -m --set $NAME label="$main"
  fi

  if [[ "$left" == "null" ]]; then
    left="Nf"
  fi

  if [[ "$right" == "null" ]]; then
    right='Nf'
  fi

  if [[ "$case" == "null" ]]; then
    case="Nf"
  fi

  # sketchybar -m --set $NAME label="$left $case $right"
fi
