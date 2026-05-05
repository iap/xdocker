#!/bin/bash
set -e

DOCKER_VERSION="4.15.0"
DOCKER_DMG_URL="https://desktop.docker.com/mac/main/amd64/93002/Docker.dmg"
DMG_PATH="/tmp/Docker-${DOCKER_VERSION}.dmg"

echo "📦 Downloading Docker Desktop $DOCKER_VERSION..."
curl -L "$DOCKER_DMG_URL" -o "$DMG_PATH"

echo "💿 Mounting DMG..."
hdiutil attach "$DMG_PATH" -nobrowse -quiet

echo "🔍 Verifying DMG signature..."
codesign --verify /Volumes/Docker/Docker.app 2>&1 || { echo "❌ DMG app signature invalid, aborting."; hdiutil detach /Volumes/Docker -quiet; exit 1; }

echo "📂 Reinstalling Docker Desktop (requires password)..."
sudo rm -rf /Applications/Docker.app
sudo cp -R /Volumes/Docker/Docker.app /Applications/Docker.app

echo "🧹 Cleaning up..."
hdiutil detach /Volumes/Docker -quiet
rm -f "$DMG_PATH"

echo "🔒 Disabling auto-update..."
bash "$(dirname "$0")/disable-updates.sh"

echo ""
echo "✅ Done! Launch Docker from /Applications/Docker.app"
