#!/bin/bash
# Run checkin.sh in the background and detach from terminal

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Change to script directory
cd "$SCRIPT_DIR" || exit 1

# Create down directory if it doesn't exist
mkdir -p ./down

# Run checkin.sh with nohup, redirect output, and disown
nohup bash "$SCRIPT_DIR/checkin.sh" > /tmp/checkin.out 2>&1 </dev/null &

# Store the PID
echo $! > /tmp/checkin.pid

# Disown the process so it continues after terminal closes
disown

echo "Checkin process started with PID $(cat /tmp/checkin.pid)"
echo "Output is being logged to /tmp/checkin.out"
echo "To check status: ps -p \$(cat /tmp/checkin.pid)"
echo "To stop: kill \$(cat /tmp/checkin.pid)"
