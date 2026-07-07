#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
WATCHDOG_SCRIPT="$SCRIPT_DIR/komorebi-watchdog.sh"
UNIT_TEMPLATE="$SCRIPT_DIR/komorebi-watchdog.service.template"
UNIT_TARGET="$HOME/.config/systemd/user/komorebi-watchdog.service"
TIMER_TARGET="$HOME/.config/systemd/user/komorebi-watchdog.timer"

if [[ ! -f "$WATCHDOG_SCRIPT" ]]; then
    echo "komorebi-watchdog.sh not found"
    exit 1
fi

chmod +x "$WATCHDOG_SCRIPT"
mkdir -p ~/.config/systemd/user

# Remove existing units
systemctl --user disable --now komorebi-watchdog.service 2>/dev/null || true
systemctl --user disable --now komorebi-watchdog.timer 2>/dev/null || true
rm -f "$UNIT_TARGET" "$TIMER_TARGET"

# Create .service from template
sed "s|{{SCRIPT_PATH}}|$WATCHDOG_SCRIPT|g" "$UNIT_TEMPLATE" > "$UNIT_TARGET"

# Create .timer
cat > "$TIMER_TARGET" <<EOF
[Unit]
Description=Check komorebi every 30 seconds

[Timer]
OnBootSec=10s
OnUnitActiveSec=30s
AccuracySec=1s
Persistent=false

[Install]
WantedBy=timers.target
EOF

# Reload and start
systemctl --user daemon-reload
systemctl --user enable --now komorebi-watchdog.timer

echo "Installed and scheduled komorebi-watchdog via timer"
