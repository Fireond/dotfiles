#!/usr/bin/env bash

file="$(fd --type f --extension pdf . ~ | fzf)"
[ -n "$file" ] || exit 0

setsid -f zathura "$file" >/dev/null 2>&1 </dev/null
