#!/bin/bash

OPT=$1

path="$HOME/Documents/Obsidian-Vault/"
cd $path

case "$OPT" in
"commit_push")
  git add .
  git commit -m "vault backup: $(date '+%Y-%m-%d %H:%M:%S')"
  git push
  ;;
"pull")
  git pull --no-edit
  ;;
*) ;;
esac
