# Exam Checkin - Quick Guide

Simple scripts to manage checkin during exams. No complicated setup needed!

## During Exam

### Start Checkin (at beginning of exam)
```bash
./startExamCheckin.sh
```
- Runs for 3 hours automatically
- Survives if you close the terminal
- Checkins happen every second

### Check Status (anytime during exam)
```bash
./statusExamCheckin.sh
```
Shows:
- If checkin is running
- How long it's been running
- Recent activity

### Stop Checkin (if exam ends early)
```bash
./stopExamCheckin.sh
```

### Reset (between exams or if something went wrong)
```bash
./resetExamCheckin.sh
```
- Stops any running processes
- Clears logs
- Ready for next exam

## Typical Exam Workflow

1. **Before exam starts:**
   ```bash
   ./resetExamCheckin.sh      # Clean slate
   ./startExamCheckin.sh      # Start monitoring
   ```

2. **During exam:**
   - Close terminal if needed - it keeps running!
   - Check status: `./statusExamCheckin.sh`

3. **After exam:**
   ```bash
   ./stopExamCheckin.sh       # Stop checkin
   ```

## Troubleshooting

**"It stopped working"**
```bash
./resetExamCheckin.sh
./startExamCheckin.sh
```

**"Is it still running?"**
```bash
./statusExamCheckin.sh
```

**"I closed the terminal, did it stop?"**
No! It keeps running. Use `./statusExamCheckin.sh` to verify.

**"I want to see what it's doing"**
```bash
tail -f /tmp/checkin.out
```

## Configuration

Edit `checkin.sh` to change:
- `duration=10800` → Duration in seconds (3 hours = 10800)
- `interval=1` → Check-in frequency in seconds
- `nic='en1'` → Network interface (en0 for WiFi, en1 for Ethernet)

## Server Management (Teacher Only)

Clear all student check-ins between exams:
```bash
./cleardb.sh
```
