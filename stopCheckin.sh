#!/bin/bash
# Stop the checkin process

if [ -f /tmp/checkin.pid ]; then
    PID=$(cat /tmp/checkin.pid)
    if ps -p $PID > /dev/null 2>&1; then
        kill $PID
        echo "Stopped checkin process (PID: $PID)"
        rm /tmp/checkin.pid
    else
        echo "Process $PID is not running"
        rm /tmp/checkin.pid
    fi
else
    echo "No PID file found. Process may not be running."
    echo "Checking for any running checkin.sh processes..."
    pkill -f checkin.sh && echo "Killed running checkin.sh processes" || echo "No checkin.sh processes found"
fi
