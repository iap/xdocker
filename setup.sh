#!/bin/bash
# Installs xdocker as a login agent so disable-updates runs automatically on login
set -e

INSTALL_DIR="$(cd "$(dirname "$0")" && pwd)"
PLIST_SRC="$INSTALL_DIR/com.xdocker.disable-updates.plist"
PLIST_DEST="$HOME/Library/LaunchAgents/com.xdocker.disable-updates.plist"

# Inject actual install path into plist
sed "s|INSTALL_DIR|$INSTALL_DIR|g" "$PLIST_SRC" > "$PLIST_DEST"

launchctl unload "$PLIST_DEST" 2>/dev/null || true
launchctl load "$PLIST_DEST"

echo "✅ xdocker agent installed — disable-updates.sh will run at login and every hour."
echo "   To remove: ./teardown.sh"
