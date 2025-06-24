#!/bin/bash

# Help message
if [[ "$1" == "-h" || "$1" == "--help" || -z "$1" ]]; then
    echo "Usage: CITY=<CityName> $0 [script_name or script_name.sh]"
    echo
    echo "Description:"
    echo "  Determines if it's currently day or night in the specified city"
    echo "  and runs the corresponding script with THEME=light or THEME=dark"
    echo
    echo "Defaults:"
    echo "  CITY=Chicago"
    exit 0
fi

# Default city if not provided
CITY="${CITY:-Chicago}"

# Strip .sh extension if present
script_name="${1%.sh}"

# Get day/night status
daynight=$(./suntimes.py "$CITY" --status)
if [[ $daynight == "day" ]]; then
    THEME=light
else
    THEME=dark
fi

# Run script with THEME in environment
set -x
THEME=$THEME ./"$script_name.sh"

