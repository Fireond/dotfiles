#!/bin/bash
set -euo pipefail
source "$HOME/.dotfiles/macos/lib/env.sh"
# macOS accepts a verified bundle ID, not a Linux app-id regex.
bundle=${1:?bundle ID required}
exec "$NIRI_MAC_ROOT/bin/omni-helper.py" focus-app "$bundle"
