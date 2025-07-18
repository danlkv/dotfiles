#!/bin/bash
set -e

CONFIG_FILE="$1"
THEME="${THEME:-light}"

if [[ -z "$CONFIG_FILE" || ! -f "$CONFIG_FILE" ]]; then
    echo "Usage: THEME=light|dark $0 path/to/config.json"
    exit 1
fi

if [[ "$THEME" != "light" && "$THEME" != "dark" ]]; then
    echo "THEME must be 'light' or 'dark'"
    exit 1
fi

# Uncomment matching lines
sed -i -E "/auto-switch-theme=$THEME/ s/^([[:space:]]*)\/\/[[:space:]]*/\1/" "$CONFIG_FILE"

# Comment out all other lines with a theme tag
sed -i -E "/auto-switch-theme=(light|dark)/ {
  /auto-switch-theme=$THEME/ ! s/^([[:space:]]*)([^/[:space:]])/\1\/\/\2/
}" "$CONFIG_FILE"

echo "Theme set to $THEME in $CONFIG_FILE"

