#!/bin/bash
set -euo pipefail
source "$HOME/.dotfiles/macos/lib/env.sh"
exec "$NIRI_MAC_ROOT/bin/workflow.py" open "$@"
