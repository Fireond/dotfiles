#!/usr/bin/env bash

# Get Kitty socket
KITTY_SOCKET=$(echo $KITTY_LISTEN_ON)

# We can control the current kitty terminal using socket
# and using "kitten" : https://sw.kovidgoyal.net/kitty/remote-control/#remote-control-via-a-socket
if [ -n "$KITTY_SOCKET" ]; then
  kitten @ --to "$KITTY_SOCKET" set-spacing padding=0
fi

if [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
nvim "$@"

if [ -n "$KITTY_SOCKET" ]; then
  kitten @ --to "$KITTY_SOCKET" set-spacing padding=default
fi
