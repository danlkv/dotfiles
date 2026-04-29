#!/bin/bash
# Detect Google Drive Windows drives via DriveFS DB and mount them
# to fixed WSL paths under /mnt/.
#
# Account -> WSL mount path mapping (stable across reboots):
declare -A ACCOUNT_MNT=(
    ["lkv97dn@gmail.com"]="/mnt/d"
    ["lkvdan@gmail.com"]="/mnt/h"
)

set -euo pipefail

DRIVEFS_DB_GLOB="/mnt/c/Users/*/AppData/Local/Google/DriveFS/root_preference_sqlite.db"
TMPDB="/tmp/gdrive_root_preference.db"

# Find the DriveFS DB
DRIVEFS_DB=$(ls $DRIVEFS_DB_GLOB 2>/dev/null | head -1)
if [[ -z "$DRIVEFS_DB" ]]; then
    echo "ERROR: Could not find Google DriveFS root_preference_sqlite.db" >&2
    exit 1
fi

# Copy DB locally (WSL can't open it directly with sqlite3)
cp "$DRIVEFS_DB" "$TMPDB"

# Get most recent entry per account.
# name: "user@gmail.com - Google Drive", last_mount_point: "G:\"
MAPPINGS=$(sqlite3 "$TMPDB" "
    SELECT name, last_mount_point
    FROM media
    WHERE name LIKE '%@% - Google Drive'
    GROUP BY name
    HAVING rowid = MAX(rowid);
")

rm -f "$TMPDB"

if [[ -z "$MAPPINGS" ]]; then
    echo "ERROR: No Google Drive accounts found in DB" >&2
    exit 1
fi

while IFS='|' read -r name mount_point; do
    # Extract account from "user@gmail.com - Google Drive"
    account=$(echo "$name" | sed 's/ - Google Drive$//')
    # Extract drive letter from "G:\" or "L:"
    letter=$(echo "$mount_point" | grep -oP '^[A-Za-z]' | tr '[:lower:]' '[:upper:]')

    mnt_path="${ACCOUNT_MNT[$account]:-}"
    if [[ -z "$mnt_path" ]]; then
        echo "WARN: Unknown account $account, skipping" >&2
        continue
    fi

    mkdir -p "$mnt_path"

    # Skip if already mounted
    if mountpoint -q "$mnt_path" 2>/dev/null; then
        echo "Already mounted: $mnt_path ($account)"
        continue
    fi

    mount -t drvfs "${letter}:" "$mnt_path" -o uid=1000,gid=1000
    echo "Mounted ${letter}: -> $mnt_path ($account)"
done <<< "$MAPPINGS"
