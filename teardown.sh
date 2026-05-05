#!/bin/bash
# Removes the xdocker login agent
PLIST="$HOME/Library/LaunchAgents/com.xdocker.disable-updates.plist"
launchctl unload "$PLIST" 2>/dev/null || true
rm -f "$PLIST"
echo "✅ xdocker agent removed."
