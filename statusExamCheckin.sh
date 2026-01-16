#!/bin/bash
# Check status of exam checkin

echo "📊 Exam Checkin Status"
echo "═══════════════════════"
echo ""

if [ -f /tmp/checkin.pid ]; then
    PID=$(cat /tmp/checkin.pid)
    if ps -p $PID > /dev/null 2>&1; then
        echo "Status: ✅ RUNNING"
        echo "PID: $PID"
        echo ""
        
        # Get process start time and elapsed time
        ps -p $PID -o etime=,lstart= | while read elapsed start; do
            echo "Started: $start"
            echo "Running for: $elapsed"
        done
        echo ""
        
        # Show last few log lines
        if [ -f /tmp/checkin.out ]; then
            echo "Recent activity (last 5 lines):"
            echo "────────────────────────────────"
            tail -5 /tmp/checkin.out
        fi
    else
        echo "Status: ❌ NOT RUNNING"
        echo "PID file exists but process is not active"
        echo "(Process may have completed its duration)"
    fi
else
    echo "Status: ❌ NOT RUNNING"
    echo "No PID file found"
fi

echo ""
echo "Commands:"
echo "  Start: ./startExamCheckin.sh"
echo "  Stop:  ./stopExamCheckin.sh"
echo "  Logs:  tail -f /tmp/checkin.out"
