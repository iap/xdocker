#!/bin/bash
set -e

SETTINGS_DIR="$HOME/Library/Group Containers/group.com.docker"
SETTINGS_FILE="$SETTINGS_DIR/settings.json"

echo "🔒 Disabling Docker auto-update and update notifications..."

mkdir -p "$SETTINGS_DIR"

if [[ -f "$SETTINGS_FILE" ]]; then
  python3 -c "
import json
with open('$SETTINGS_FILE') as f: s = json.load(f)
s['autoUpdate'] = False
s['autoUpdateTrack'] = 'disabled'
s['analyticsEnabled'] = False
s['showUpdateNotification'] = False
s['disableUpdate'] = {'engine': True, 'desktop': True}
with open('$SETTINGS_FILE', 'w') as f: json.dump(s, f, indent=2)
"
else
  python3 -c "
import json
s = {
  'autoUpdate': False,
  'autoUpdateTrack': 'disabled',
  'analyticsEnabled': False,
  'showUpdateNotification': False,
  'disableUpdate': {'engine': True, 'desktop': True}
}
import os; os.makedirs('$SETTINGS_DIR', exist_ok=True)
with open('$SETTINGS_FILE', 'w') as f: json.dump(s, f, indent=2)
"
fi

# Also block Docker update check via hosts (belt-and-suspenders)
HOSTS_ENTRY="127.0.0.1 desktop.docker.com"
if ! grep -qF "$HOSTS_ENTRY" /etc/hosts; then
  echo "$HOSTS_ENTRY" | sudo tee -a /etc/hosts > /dev/null
  echo "🚫 Blocked desktop.docker.com update endpoint in /etc/hosts"
fi

echo "✅ Auto-update and notifications disabled!"
echo "⚠️  Restart Docker Desktop for changes to take effect."
