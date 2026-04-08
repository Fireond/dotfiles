#!/usr/bin/env bash
set -euo pipefail

RPC_URL="http://localhost:23119/better-bibtex/json-rpc"

need() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "missing dependency: $1" >&2
    exit 1
  }
}

need curl
need jq
need fzf
need wl-copy

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

# 确认 BBT 接口可用
rpc "api.ready" '[]' >/dev/null

tmp_json="$(mktemp)"
trap 'rm -f "$tmp_json"' EXIT

# 拉出非附件、非 feeds 的条目
rpc "item.search" '[["ignore_feeds"],["itemType","isNot","attachment"]]' >"$tmp_json"

selection="$(
  jq -r '
    .result[]
    | select(.citekey != null and .citekey != "")
    | [
        .citekey,
        (.title // "[no title]"),
        (
          (
            .author // .editor // []
          )
          | map(.family // .literal // .given // "")
          | map(select(length > 0))
          | join(", ")
        ),
        (
          .issued["date-parts"][0][0]? // .year // ""
        )
      ]
    | @tsv
  ' "$tmp_json" |
    fzf --delimiter=$'\t' \
      --with-nth=2,3,4 \
      --prompt='Zotero title> ' \
      --height=80% \
      --layout=reverse \
      --border
)"

[ -n "$selection" ] || exit 0

citekey="${selection%%$'\t'*}"

printf '%s' "$citekey" | wl-copy
echo "Copied citekey: $citekey"
