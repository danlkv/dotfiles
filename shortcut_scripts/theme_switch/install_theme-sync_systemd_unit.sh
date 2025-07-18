#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SYNC_SCRIPT="$SCRIPT_DIR/sync_theme_from_windows.sh"
UNIT_TEMPLATE="$SCRIPT_DIR/theme-sync.service.template"
UNIT_TARGET="$HOME/.config/systemd/user/theme-sync.service"
TIMER_TARGET="$HOME/.config/systemd/user/theme-sync.timer"

# Ensure script exists
if [[ ! -f "$SYNC_SCRIPT" ]]; then
    echo "❌ sync_theme_from_windows.sh not found"
    exit 1
fi

mkdir -p ~/.config/systemd/user

# Remove existing units
systemctl --user disable --now theme-sync.service 2>/dev/null || true
systemctl --user disable --now theme-sync.timer 2>/dev/null || true
rm -f "$UNIT_TARGET" "$TIMER_TARGET"

# Create new .service from template
sed "s|{{SCRIPT_PATH}}|$SYNC_SCRIPT|g" "$UNIT_TEMPLATE" > "$UNIT_TARGET"

# Create .timer
cat > "$TIMER_TARGET" <<EOF
[Unit]
Description=Theme sync every 30 seconds

[Timer]
OnBootSec=5s
OnUnitActiveSec=30s
AccuracySec=1s
Persistent=false

[Install]
WantedBy=timers.target
EOF

# Reload and start
systemctl --user daemon-reload
systemctl --user enable --now theme-sync.timer

echo "✅ Installed and scheduled theme-sync.service via timer"

