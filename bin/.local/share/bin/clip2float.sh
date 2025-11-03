#!/bin/bash
file=$(mktemp /tmp/shotXXXX.png)

if wl-paste --list-types | grep -q "image/png"; then
  wl-paste --type image/png >"$file"
fi

qimgv "$file" &
