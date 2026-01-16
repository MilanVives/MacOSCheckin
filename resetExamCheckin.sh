#!/bin/bash
# Reset exam checkin - stops running process and clears logs

echo "🔄 Resetting Exam Checkin"
echo "═══════════════════════════"
echo ""

# Stop any running process
if [ -f /tmp/checkin.pid ]; then
    PID=$(cat /tmp/checkin.pid)
    if ps -p $PID > /dev/null 2>&1; then
        echo "Stopping running process (PID: $PID)..."
        kill $PID
        sleep 1
    fi
    rm /tmp/checkin.pid
fi

# Kill any orphaned checkin processes
if pkill -f checkin.sh 2>/dev/null; then
    echo "Killed orphaned checkin processes"
fi

# Clear logs
if [ -f /tmp/checkin.out ]; then
    echo "Clearing log file..."
    > /tmp/checkin.out
fi

if [ -f /tmp/checkin.err ]; then
    > /tmp/checkin.err
fi

echo ""
echo "✅
echo ""
echo "Ready to start a new exam session:"
echo "  ./startExamCheckin.sh"
