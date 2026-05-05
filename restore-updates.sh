#!/bin/bash
# Unlocks settings.json so Docker can modify it again
SETTINGS_FILE="$HOME/Library/Group Containers/group.com.docker/settings.json"
chflags nouchg "$SETTINGS_FILE" 2>/dev/null && echo "✅ settings.json unlocked" || echo "Already unlocked"
