#!/bin/bash
set -e

CONFIG_FILE="$1"
THEME="${THEME:-light}"

if [[ -z "$CONFIG_FILE" || ! -f "$CONFIG_FILE" ]]; then
    echo "Usage: THEME=light|dark $0 path/to/config.yml"
    exit 1
fi

if [[ "$THEME" != "light" && "$THEME" != "dark" ]]; then
    echo "THEME must be 'light' or 'dark'"
    exit 1
fi

# Uncomment matching theme lines (preserve indent)
sed -i -E "/auto-switch-theme=$THEME/ s/^([[:space:]]*)#[[:space:]]*/\1/" "$CONFIG_FILE"

# Comment out non-matching lines with no extra space after #
sed -i -E "/auto-switch-theme=(light|dark)/ {
  /auto-switch-theme=$THEME/ ! s/^([[:space:]]*)([^#[:space:]])/\1#\2/
}" "$CONFIG_FILE"

touch "$CONFIG_FILE"
echo "Theme set to $THEME"

