#!/bin/bash
# Renders a sponsor's README plate from plate.html with headless Chrome:
# docs/sponsors/<sponsor>-plate.png, 1200×400, from logos/<sponsor>.png.
#
#   bash docs/sponsors/render.sh voyageage
set -euo pipefail

dir="$(cd "$(dirname "$0")" && pwd)"
chrome="${CHROME:-/Applications/Google Chrome.app/Contents/MacOS/Google Chrome}"
profile="$(mktemp -d)"
trap 'rm -rf "$profile"' EXIT

for sponsor in "$@"; do
  out="$dir/$sponsor-plate.png"
  "$chrome" --headless=new --disable-gpu --hide-scrollbars --no-first-run \
    --user-data-dir="$profile" --force-device-scale-factor=2 \
    --default-background-color=00000000 --window-size=600,200 \
    --virtual-time-budget=3000 --screenshot="$out" \
    "file://$dir/plate.html?logo=logos/$sponsor.png" >/dev/null 2>&1
  echo "$out"
done
