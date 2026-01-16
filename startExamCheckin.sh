#!/bin/bash
# Start checkin for exam - runs for configured duration (default 3 hours)

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

# Run checkin.sh with nohup
nohup bash "$SCRIPT_DIR/checkin.sh" > /tmp/checkin.out 2>&1 </dev/null &

# Store the PID
echo $! > /tmp/checkin.pid

# Disown to detach from terminal
disown

echo "✅
echo ""
echo "Process ID: $(cat /tmp/checkin.pid)"
echo "Duration: 3 hours (configured in checkin.sh)"
echo "Server: https://checkin.vives.live"
echo ""
echo "Commands:"
echo "  Status:  ./statusExamCheckin.sh"
echo "  Stop:    ./stopExamCheckin.sh"
echo "  Logs:    tail -f /tmp/checkin.out"
