# Exam Checkin - Quick Guide

Simple scripts to manage checkin during exams. No complicated setup needed!

## During Exam

### Start Checkin (at beginning of exam)
```bash
./startExamCheckin.sh
```
- Runs for **4 hours** automatically
- Automatically detects WiFi or Ethernet connection
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

## Network Detection

The script automatically detects which network interface is active:
- **en0** - Usually WiFi
- **en1** - Usually Ethernet or Thunderbolt
- **en2/en3** - Additional adapters

The script checks all interfaces and uses the first one with an active IP address.

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

**"Wrong network interface being used"**
The script auto-detects, but if needed you can edit `checkin.sh` line 36 to force a specific interface.

## Configuration

Edit `checkin.sh` to change:
- `duration=14400` → Duration in seconds (4 hours = 14400)
- `interval=1` → Check-in frequency in seconds
- Network detection is automatic (checks en0, en1, en2, en3)

## Server Management (Teacher Only)

Clear all student check-ins between exams:
```bash
./cleardb.sh
```

## Dashboard

Access the live monitoring dashboard at: **https://checkin.vives.live/**

### Dashboard Features:
- **Real-time tiles** for each Mac (green = live, gray = offline)
- **Auto-refresh** every 5 seconds
- **Machine info**: hostname, IP, connection count
- **Live indicator**: Pulsing green border when network detected
- **Manual refresh** button available

### Clearing Data Between Exams:
For security, database clearing is only available via command line:

```bash
# On the server (oracle4):
cd ~/MacOSCheckin
./cleardb.sh
```

Or remotely:
```bash
curl -X POST \
  -H "x-cleanup-key: your-very-long-secret-key-here" \
  https://checkin.vives.live/api/v1/maintenance/d41d8cd98f00b204e9800998ecf8427e/cleanup
```
