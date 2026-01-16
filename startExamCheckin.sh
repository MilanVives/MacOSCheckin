#!/bin/bash
# Start checkin for exam - runs for configured duration (default 4 hours)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR" || exit 1

# Create down directory if it doesn't exist
mkdir -p ./down

# Check if already running
if [ -f /tmp/checkin.pid ] && ps -p $(cat /tmp/checkin.pid) > /dev/null 2>&1; then
    echo "Checkin is already running (PID: $(cat /tmp/checkin.pid))"
    echo "Use ./stopExamCheckin.sh to stop it first"
    exit 1
fi

# Run checkin.sh with nohup, redirect output to show network interface detection
nohup bash "$SCRIPT_DIR/checkin.sh" > /tmp/checkin.out 2>&1 </dev/null &

# Store the PID
echo $! > /tmp/checkin.pid

# Disown to detach from terminal
disown

# Wait a moment for network detection to complete
sleep 1

echo ""
echo "Process ID: $(cat /tmp/checkin.pid)"
echo "Duration: 4 hours"
echo "Server: https://checkin.vives.live"

# Show detected network interface from log
if [ -f /tmp/checkin.out ]; then
    detected_nic=$(grep "Using network interface" /tmp/checkin.out | tail -1)
    if [ ! -z "$detected_nic" ]; then
        echo "$detected_nic"
    fi
fi

echo ""
echo "Commands:"
echo "  Status:  ./statusExamCheckin.sh"
echo "  Stop:    ./stopExamCheckin.sh"
echo "  Logs:    tail -f /tmp/checkin.out"
