#!/bin/bash
# Renders the README's sponsor cards from card.html with headless Chrome:
# docs/sponsors/<sponsor>-<en|zh>-<light|dark>.png, 1800×440 with transparent
# corners. Needs `pnpm install` first, for the Geist font files.
#
#   bash docs/sponsors/render.sh voyageage
set -euo pipefail

dir="$(cd "$(dirname "$0")" && pwd)"
chrome="${CHROME:-/Applications/Google Chrome.app/Contents/MacOS/Google Chrome}"
profile="$(mktemp -d)"
trap 'rm -rf "$profile"' EXIT

for sponsor in "$@"; do
  for lang in en zh; do
    for theme in light dark; do
      out="$dir/$sponsor-$lang-$theme.png"
      "$chrome" --headless=new --disable-gpu --hide-scrollbars --no-first-run \
        --user-data-dir="$profile" --force-device-scale-factor=2 \
        --default-background-color=00000000 --window-size=900,220 \
        --virtual-time-budget=4000 --screenshot="$out" \
        "file://$dir/card.html?sponsor=$sponsor&lang=$lang&theme=$theme" >/dev/null 2>&1
      echo "$out"
    done
  done
done
