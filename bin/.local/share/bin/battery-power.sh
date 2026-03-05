#!/usr/bin/env bash

BAT="/sys/class/power_supply/macsmc-battery"

cap=$(cat $BAT/capacity)
status=$(cat $BAT/status)
power=$(cat $BAT/power_now)

# µW → W
watts=$(awk "BEGIN {printf \"%.1f\", $power/1000000}")

energy_now=$(cat $BAT/energy_now)
energy_full=$(cat $BAT/energy_full)

# 剩余时间估算
if [[ "$power" -gt 0 ]]; then
  hours=$(awk "BEGIN {print $energy_now/$power}")
  h=$(printf "%.0f" "$hours")
  m=$(printf "%.0f" "$(echo "($hours-$h)*60" | bc)")
  time="${h}h${m}m"
else
  time="--"
fi

echo "⚡ ${watts}W ${time}"
