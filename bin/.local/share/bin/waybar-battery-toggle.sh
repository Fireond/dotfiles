#!/usr/bin/env bash

state_file=/tmp/waybar_battery_mode

if [[ -f $state_file ]]; then
  rm $state_file
else
  touch $state_file
fi

pkill -SIGRTMIN+8 waybar
