#!/bin/bash
# Install checkin as a macOS LaunchAgent

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLIST_NAME="com.vives.checkin.plist"
PLIST_SRC="$SCRIPT_DIR/$PLIST_NAME"
PLIST_DEST="$HOME/Library/LaunchAgents/$PLIST_NAME"

# Create LaunchAgents directory if it doesn't exist
mkdir -p "$HOME/Library/LaunchAgents"

# Create down directory if it doesn't exist
mkdir -p "$SCRIPT_DIR/down"

# Replace SCRIPT_PATH placeholder with actual path
sed "s|SCRIPT_PATH|$SCRIPT_DIR|g" "$PLIST_SRC" > "$PLIST_DEST"

# Load the LaunchAgent
launchctl unload "$PLIST_DEST" 2>/dev/null
launchctl load "$PLIST_DEST"

echo "LaunchAgent installed and loaded"
echo "The checkin script will run automatically"
echo ""
echo "To uninstall:"
echo "  launchctl unload $PLIST_DEST"
echo "  rm $PLIST_DEST"
echo ""
echo "To check status:"
echo "  launchctl list | grep vives"
echo ""
echo "To view logs:"
echo "  tail -f /tmp/checkin.out"
