#!/usr/bin/env bash
set -euo pipefail

RPC_URL="http://localhost:23119/better-bibtex/json-rpc"
OPEN_SCRIPT="${HOME}/.local/share/bin/zotero-open-by-citekey.sh"

need() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "missing dependency: $1" >&2
    exit 1
  }
}

need curl
need jq
need fzf

[ -x "$OPEN_SCRIPT" ] || {
  echo "open script not found or not executable: $OPEN_SCRIPT" >&2
  exit 1
}

rpc() {
  local method="$1"
  local params_json="$2"

  curl --noproxy '*' -sS "$RPC_URL" \
    -H 'Content-Type: application/json' \
    -H 'Accept: application/json' \
    --data-binary "$(jq -nc \
      --arg method "$method" \
      --argjson params "$params_json" \
      '{jsonrpc:"2.0", method:$method, params:$params, id:1}')"
}

rpc "api.ready" '[]' >/dev/null

tmp_json="$(mktemp)"
trap 'rm -f "$tmp_json"' EXIT

rpc "item.search" '[[["ignore_feeds"],["itemType","isNot","attachment"]]]' >"$tmp_json"

selection="$(
  jq -r '
    (.result // [])
    | .[]
    | select((.citekey // .["citation-key"] // "") != "")
    | [
        (.citekey // .["citation-key"]),
        (.title // "[no title]"),
        (
          (.author // .editor // [])
          | map(.family // .literal // .given // "")
          | map(select(length > 0))
          | join(", ")
        ),
        (.issued["date-parts"][0][0]? // "")
      ]
    | @tsv
  ' "$tmp_json" |
    fzf --delimiter=$'\t' \
      --with-nth=2,3,4 \
      --prompt='Open Zotero paper> ' \
      --height=80% \
      --layout=reverse \
      --border
)"

[ -n "$selection" ] || exit 0

citekey="${selection%%$'\t'*}"

"$OPEN_SCRIPT" "$citekey"

sleep 0.2
