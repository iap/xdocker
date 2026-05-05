#!/bin/bash
set -e

SETTINGS_DIR="$HOME/Library/Group Containers/group.com.docker"
SETTINGS_FILE="$SETTINGS_DIR/settings.json"
AUTOUPDATE="/Applications/Docker.app/Contents/Frameworks/Sparkle.framework/Versions/A/Resources/Autoupdate.app/Contents/MacOS/Autoupdate"
DOCKER_PLIST="/Applications/Docker.app/Contents/Info.plist"

echo "🛑 Stopping Docker if running..."
osascript -e 'quit app "Docker"' 2>/dev/null || true
pkill -f Docker 2>/dev/null || true
sleep 2

# 1. Disable Sparkle updater via app plist
echo "🔒 Disabling Sparkle auto-update in Docker plist..."
sudo defaults write "$DOCKER_PLIST" SUEnableAutomaticChecks -bool false
sudo defaults write "$DOCKER_PLIST" SUAutomaticallyUpdate -bool false
sudo defaults write "$DOCKER_PLIST" SUAllowsAutomaticUpdates -bool false

# 2. Replace Autoupdate binary with a no-op stub
echo "🚫 Neutering Autoupdate binary..."
sudo mv "$AUTOUPDATE" "${AUTOUPDATE}.bak" 2>/dev/null || true
echo '#!/bin/bash' | sudo tee "$AUTOUPDATE" > /dev/null
echo 'exit 0' | sudo tee -a "$AUTOUPDATE" > /dev/null
sudo chmod +x "$AUTOUPDATE"

# 3. Write settings.json and lock it (immutable)
echo "📝 Writing and locking settings.json..."
mkdir -p "$SETTINGS_DIR"
# Unlock first in case it was previously locked
chflags nouchg "$SETTINGS_FILE" 2>/dev/null || true
python3 -c "
import json, os
path = '$SETTINGS_FILE'
s = {}
if os.path.exists(path):
    with open(path) as f: s = json.load(f)
s.update({
    'autoUpdate': False,
    'autoUpdateTrack': 'disabled',
    'analyticsEnabled': False,
    'showUpdateNotification': False,
    'disableUpdate': {'engine': True, 'desktop': True}
})
with open(path, 'w') as f: json.dump(s, f, indent=2)
"
# Lock the file so Docker cannot modify it
chflags uchg "$SETTINGS_FILE"
echo "🔐 settings.json locked (immutable)"

echo ""
echo "✅ Done! Update popup should no longer appear."
echo "   - Sparkle updater disabled in app plist"
echo "   - Autoupdate binary replaced with no-op stub"
echo "   - settings.json locked as immutable"
echo ""
echo "⚠️  To undo: run restore-updates.sh"
