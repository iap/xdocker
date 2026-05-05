#!/bin/bash
set -e

DOCKER_VERSION="4.15.0"
DOCKER_DMG_URL="https://desktop.docker.com/mac/main/amd64/93002/Docker.dmg"
DMG_PATH="/tmp/Docker-${DOCKER_VERSION}.dmg"
MIN_MACOS="10.15"

# Check macOS version
OS_VERSION=$(sw_vers -productVersion)
if [[ "$(printf '%s\n' "$MIN_MACOS" "$OS_VERSION" | sort -V | head -n1)" != "$MIN_MACOS" ]]; then
  echo "❌ macOS $OS_VERSION is below minimum required $MIN_MACOS"
  exit 1
fi

echo "✅ macOS $OS_VERSION is compatible"
echo "📦 Downloading Docker Desktop $DOCKER_VERSION..."
curl -L "$DOCKER_DMG_URL" -o "$DMG_PATH"

echo "💿 Mounting DMG..."
hdiutil attach "$DMG_PATH" -nobrowse -quiet

echo "📂 Installing Docker Desktop..."
cp -R "/Volumes/Docker/Docker.app" /Applications/

echo "🔒 Disabling auto-update..."
SETTINGS_DIR="$HOME/Library/Group Containers/group.com.docker"
mkdir -p "$SETTINGS_DIR"
SETTINGS_FILE="$SETTINGS_DIR/settings.json"
if [[ -f "$SETTINGS_FILE" ]]; then
  # Update existing settings
  python3 -c "
import json, sys
with open('$SETTINGS_FILE') as f: s = json.load(f)
s['autoUpdate'] = False
s['analyticsEnabled'] = False
with open('$SETTINGS_FILE', 'w') as f: json.dump(s, f, indent=2)
"
else
  echo '{"autoUpdate": false, "analyticsEnabled": false}' > "$SETTINGS_FILE"
fi

echo "🧹 Cleaning up..."
hdiutil detach "/Volumes/Docker" -quiet
rm -f "$DMG_PATH"

echo "✅ Docker Desktop $DOCKER_VERSION installed successfully!"
echo "👉 Launch Docker from /Applications/Docker.app"
