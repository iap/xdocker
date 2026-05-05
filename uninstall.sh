#!/bin/bash
set -e

echo "🛑 Stopping Docker..."
osascript -e 'quit app "Docker"' 2>/dev/null || true
pkill -9 -f Docker 2>/dev/null || true
sleep 2

echo "🔓 Unlocking any locked files..."
chflags -R nouchg ~/Library/Group\ Containers/group.com.docker 2>/dev/null || true

echo "🗑️  Removing Docker Desktop app..."
sudo rm -rf /Applications/Docker.app

echo "🧹 Removing Docker support files..."
rm -rf ~/Library/Application\ Support/Docker\ Desktop
rm -rf ~/Library/Containers/com.docker.*
rm -rf ~/Library/Group\ Containers/group.com.docker
rm -rf ~/Library/Preferences/com.docker.*
rm -rf ~/Library/Saved\ Application\ State/com.electron.docker-frontend.savedState
rm -rf ~/Library/Logs/Docker\ Desktop
rm -rf ~/.docker

echo "🔧 Removing launch agents/daemons..."
launchctl unload ~/Library/LaunchAgents/com.docker.* 2>/dev/null || true
sudo launchctl unload /Library/LaunchDaemons/com.docker.* 2>/dev/null || true
sudo launchctl unload /Library/LaunchDaemons/homebrew.mxcl.socket_vmnet.plist 2>/dev/null || true
rm -f ~/Library/LaunchAgents/com.docker.*
sudo rm -f /Library/LaunchDaemons/com.docker.*
sudo rm -f /Library/LaunchDaemons/homebrew.mxcl.socket_vmnet.plist

echo "🔧 Removing privileged helpers..."
sudo rm -f /Library/PrivilegedHelperTools/com.docker.vmnetd
sudo rm -f /Library/PrivilegedHelperTools/com.docker.socket
sudo rm -f /var/run/docker.sock

echo "✅ Docker Desktop uninstalled successfully!"
