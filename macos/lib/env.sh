# macOS-only environment. Source this from scripts, not a login shell.
export NIRI_MAC_ROOT="$HOME/.dotfiles/macos"
export PATH="$NIRI_MAC_ROOT/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/Library/TeX/texbin:/Applications/kitty.app/Contents/MacOS:$HOME/.local/share/bin:/usr/bin:/bin:/usr/sbin:/sbin${PATH:+:$PATH}"
export NIRI_MAC_VAULT="$HOME/Documents/sync-server/Obsidian-Vault"
export NIRI_MAC_TODO="$NIRI_MAC_VAULT/others/todos.md"
export NIRI_MAC_PDF_APP="Skim"
export NIRI_MAC_RPC_URL="http://127.0.0.1:23119/better-bibtex/json-rpc"
if [[ -f "$NIRI_MAC_ROOT/local.conf" ]]; then source "$NIRI_MAC_ROOT/local.conf"; fi
