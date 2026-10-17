#!/bin/bash
set -euo pipefail
source "$HOME/.dotfiles/macos/lib/env.sh"
# Image extraction is type-aware and converts PNG/TIFF/etc. through NSPasteboard.
# A text-only clipboard fails without writing an empty image.
exec hs -c 'assert(niriMac.clipboardImage())'
