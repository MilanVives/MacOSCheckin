#!/bin/bash
# Stop the exam checkin process

if [ -f /tmp/checkin.pid ]; then
    PID=$(cat /tmp/checkin.pid)
    if ps -p $PID > /dev/null 2>&1; then
        kill $PID
        rm /tmp/checkin.pid
        echo "Exam checkin stopped (PID: $PID)"
    else
        echo "Process $PID is not running (may have finished)"
        rm /tmp/checkin.pid
    fi
else
    echo "No PID file found"
    echo "Checking for any running checkin.sh processes..."
    if pkill -f checkin.sh; then
        echo "Killed running checkin.sh processes"
    else
        echo "No checkin.sh processes found"
    fi
fi
