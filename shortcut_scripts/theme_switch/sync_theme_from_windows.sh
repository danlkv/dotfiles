#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# --- Detect Windows theme ---
get_windows_theme() {
    local value
    value=$(powershell.exe -NoProfile -Command 'Get-ItemPropertyValue -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme' 2>/dev/null | tr -d '\r')
    if [[ "$value" == "0" ]]; then
        echo "dark"
    elif [[ "$value" == "1" ]]; then
        echo "light"
    else
        echo "unknown"
    fi
}

# --- Get Windows user home as WSL path ---
get_windows_home() {
    wslpath "$(powershell.exe -NoProfile -Command '[Environment]::GetFolderPath("UserProfile")' | tr -d '\r')"
}

# --- Toggle function ---
toggle_theme() {
    local file="$1"
    case "$file" in
        *.json|*.jsonc)
            THEME="$THEME" ${SCRIPT_DIR}/toggle_json_theme.sh "$file"
            ;;
        *.yaml|*.yml)
            THEME="$THEME" ${SCRIPT_DIR}/toggle_yaml_theme.sh "$file"
            ;;
        *)
            echo "Skipping unsupported file: $file"
            ;;
    esac
}

# --- Main ---
THEME=$(get_windows_theme)
if [[ "$THEME" == "unknown" ]]; then
    echo "Could not detect Windows theme"
    exit 1
fi

WIN_HOME=$(get_windows_home)

# --- Add your config files here ---
CONFIGS=(
  "$WIN_HOME/komorebi.bar.json"
  "$WIN_HOME/.config/tacky-borders/config.yaml"
)

# --- Process each config ---
for config in "${CONFIGS[@]}"; do
    if [[ -f "$config" ]]; then
        echo "Toggling $config to theme=$THEME"
        toggle_theme "$config"
    else
        echo "File not found: $config"
    fi
done

