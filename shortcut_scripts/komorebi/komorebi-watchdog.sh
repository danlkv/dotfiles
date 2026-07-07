#!/bin/bash
# Restart komorebi + whkd + bar if not running.
# Fail-safe: if tasklist.exe fails, do nothing (avoid false restarts).

TASKLIST=$(tasklist.exe 2>/dev/null) || exit 0

if ! echo "$TASKLIST" | grep -qi "komorebi.exe"; then
    # Kill stale processes before restarting
    powershell.exe -c 'Get-Process whkd -ErrorAction SilentlyContinue | Stop-Process -Force' 2>/dev/null
    powershell.exe -c 'Get-Process komorebi-bar -ErrorAction SilentlyContinue | Stop-Process -Force' 2>/dev/null
    komorebic.exe start --whkd --bar >/dev/null 2>&1
    sleep 3
    komorebic.exe monitor-work-area-offset 0 0 30 0 30 2>/dev/null
    komorebic.exe retile 2>/dev/null
else
    # Komorebi is running — save state for crash recovery (only if changed)
    STATE_FILE=/mnt/c/Users/Alhazen/AppData/Local/Temp/komorebi.state.json
    NEW_STATE=$(komorebic.exe state 2>/dev/null) && {
        if [ ! -f "$STATE_FILE" ] || [ "$(echo "$NEW_STATE" | md5sum)" != "$(md5sum < "$STATE_FILE")" ]; then
            echo "$NEW_STATE" > "$STATE_FILE"
        fi
    }
    # Ensure whkd is running
    if ! echo "$TASKLIST" | grep -qi "whkd.exe"; then
        powershell.exe -c 'Start-Process whkd -WindowStyle hidden' 2>/dev/null
    fi
fi
