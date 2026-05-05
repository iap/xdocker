#!/bin/bash
set -e

DOCKER_VERSION="4.15.0"
DOCKER_DMG_URL="https://desktop.docker.com/mac/main/amd64/93002/Docker.dmg"
DMG_PATH="/tmp/Docker-${DOCKER_VERSION}.dmg"
MIN_MACOS="10.15"
EXPECTED_SHA256="bee41d646916e579b16b7fae014e2fb5e5e7b5dbaf7c1949821fd311d3ce430b"

# Check macOS version
OS_VERSION=$(sw_vers -productVersion)
if [[ "$(printf '%s\n' "$MIN_MACOS" "$OS_VERSION" | sort -V | head -n1)" != "$MIN_MACOS" ]]; then
  echo "❌ macOS $OS_VERSION is below minimum required $MIN_MACOS"
  exit 1
fi
echo "✅ macOS $OS_VERSION is compatible"

echo "📦 Downloading Docker Desktop $DOCKER_VERSION..."
curl -L "$DOCKER_DMG_URL" -o "$DMG_PATH"

echo "🔐 Verifying SHA256..."
ACTUAL_SHA256=$(shasum -a 256 "$DMG_PATH" | awk '{print $1}')
if [[ "$ACTUAL_SHA256" != "$EXPECTED_SHA256" ]]; then
  echo "❌ SHA256 mismatch! Download may be corrupted."
  rm -f "$DMG_PATH"
  exit 1
fi
echo "✅ SHA256 verified"

echo "💿 Mounting DMG..."
hdiutil attach "$DMG_PATH" -nobrowse -quiet

echo "📂 Installing Docker Desktop..."
sudo rm -rf /Applications/Docker.app
sudo cp -R /Volumes/Docker/Docker.app /Applications/Docker.app

echo "🧹 Cleaning up..."
hdiutil detach "/Volumes/Docker" -quiet
rm -f "$DMG_PATH"

echo "🔓 Removing quarantine flag and fixing permissions..."
sudo xattr -rd com.apple.quarantine /Applications/Docker.app
sudo chmod -R 755 /Applications/Docker.app
sudo chown -R root:wheel /Applications/Docker.app

echo "🔒 Disabling auto-update..."
bash "$(dirname "$0")/disable-updates.sh"

echo "✅ Docker Desktop $DOCKER_VERSION installed! Launch from /Applications/Docker.app"
