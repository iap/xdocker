#!/bin/bash
set -e

SETTINGS_DIR="$HOME/Library/Group Containers/group.com.docker"
SETTINGS_FILE="$SETTINGS_DIR/settings.json"

echo "🛑 Stopping Docker if running..."
osascript -e 'quit app "Docker"' 2>/dev/null || true
pkill -f "Docker Desktop" 2>/dev/null || true
sleep 2

# Write settings.json with all update/notification flags disabled
echo "📝 Writing settings.json..."
mkdir -p "$SETTINGS_DIR"
chflags nouchg "$SETTINGS_FILE" 2>/dev/null || true

python3 -c "
import json, os
path = '$SETTINGS_FILE'
s = {}
if os.path.exists(path):
    with open(path) as f:
        try: s = json.load(f)
        except: s = {}
s.update({
    'autoUpdate': False,
    'autoUpdateTrack': 'disabled',
    'autoDownloadUpdates': False,
    'acceptCanaryUpdates': False,
    'useNightlyBuildUpdates': False,
    'showUpdateNotification': False,
    'analyticsEnabled': False,
    'disableUpdate': True
})
with open(path, 'w') as f: json.dump(s, f, indent=2)
print('settings.json updated')
"

echo "✅ Done! Restart Docker Desktop for changes to take effect."
echo "   Note: Docker may reset some settings on startup. Re-run this script if update prompts return."
