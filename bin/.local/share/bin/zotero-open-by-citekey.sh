#!/usr/bin/env bash
set -euo pipefail

citekey="${1:?need citekey}"

open_uri="$(
  curl --noproxy '*' -sS http://localhost:23119/better-bibtex/json-rpc \
    -H 'Content-Type: application/json' \
    -H 'Accept: application/json' \
    --data-binary "{
      \"jsonrpc\":\"2.0\",
      \"method\":\"item.attachments\",
      \"params\":[\"$citekey\",\"*\"],
      \"id\":1
    }" | jq -r '.result[0].open'
)"

niri msg action focus-workspace read

xdg-open "$open_uri" >/dev/null 2>&1 &
