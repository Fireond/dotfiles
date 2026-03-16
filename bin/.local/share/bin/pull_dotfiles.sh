#!/usr/bin/env bash

set -euo pipefail

REPO_DIR="$HOME/.dotfiles"
CHECK_HOST="8.8.8.8"

until ping -c 1 -W 1 "$CHECK_HOST" >/dev/null 2>&1; do
  sleep 2
done

cd "$REPO_DIR"
git pull
