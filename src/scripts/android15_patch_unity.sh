#!/usr/bin/env bash
set -u

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
cd "$SCRIPTPATH" || exit 1

PLUGIN_DIR="./Plugins/Android"
PAGE_SIZE=16384

if [ ! -d "$PLUGIN_DIR" ]; then
  echo "Plugin directory $PLUGIN_DIR does not exist."
  exit 1
fi

# patchelf 必須
if ! command -v patchelf >/dev/null 2>&1; then
  echo "Error: patchelf not found. Install it first."
  exit 1
fi

shopt -s nullglob

for f in "$PLUGIN_DIR"/*.so; do
  echo "=== Processing: $f ==="
  if patchelf --page-size "$PAGE_SIZE" "$f"; then
    echo "Aligned $f to ${PAGE_SIZE} bytes"
  else
    echo "patchelf failed for $f"
  fi
done

