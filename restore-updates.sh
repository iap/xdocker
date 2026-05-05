#!/bin/bash
# Restores Docker updater to original state (undo disable-updates.sh)

SETTINGS_FILE="$HOME/Library/Group Containers/group.com.docker/settings.json"
AUTOUPDATE="/Applications/Docker.app/Contents/Frameworks/Sparkle.framework/Versions/A/Resources/Autoupdate.app/Contents/MacOS/Autoupdate"

echo "♻️  Restoring Docker update settings..."

# Restore Autoupdate binary
if [[ -f "${AUTOUPDATE}.bak" ]]; then
  sudo mv "${AUTOUPDATE}.bak" "$AUTOUPDATE"
  echo "✅ Autoupdate binary restored"
fi

# Unlock settings.json
chflags nouchg "$SETTINGS_FILE" 2>/dev/null && echo "✅ settings.json unlocked"

echo "✅ Restore complete. Restart Docker Desktop."
