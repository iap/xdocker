# xdocker

Docker Desktop **4.15.0** installer for compatible macOS versions.

> Newer versions of Docker Desktop dropped support for older macOS hardware. This project pins and installs the last known working version.

## Compatibility

| Docker Desktop | Docker Engine | macOS Minimum |
|---|---|---|
| 4.15.0 | 20.10.21 | 10.15 (Catalina) |

## Usage

### Install
```bash
chmod +x install.sh
./install.sh
```

### Disable Updates & Notifications (standalone)
If Docker is already installed, run this to suppress update prompts:
```bash
chmod +x disable-updates.sh
./disable-updates.sh
```
This does three things:
1. Disables Sparkle auto-update in Docker's app plist
2. Replaces the `Autoupdate` binary with a no-op stub
3. Locks `settings.json` as immutable so Docker can't re-enable updates

To undo:
```bash
chmod +x restore-updates.sh
./restore-updates.sh
```

### Uninstall
```bash
chmod +x uninstall.sh
./uninstall.sh
```

### Docker Compose
```bash
cp .env.example .env
# Edit .env as needed
docker-compose up -d
```

## Notes
- Auto-update is **disabled** on install to prevent upgrading to an incompatible version
- The installer downloads the official DMG directly from Docker's servers
