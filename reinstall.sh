#!/bin/bash
# reinstall.sh - stops Docker and runs install.sh fresh
set -e

echo "🛑 Stopping Docker..."
pkill -9 -f Docker 2>/dev/null || true
sleep 2

bash "$(dirname "$0")/install.sh"
