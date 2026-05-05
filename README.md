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
chmod +x install.sh setup.sh
./install.sh   # download, install, disable updates
./setup.sh     # register login agent (keeps updates disabled permanently)
```

### Reinstall (repair broken install)
```bash
chmod +x reinstall.sh
./reinstall.sh
```

### Disable Updates & Notifications (standalone)
If Docker is already installed:
```bash
chmod +x disable-updates.sh setup.sh
./disable-updates.sh   # apply settings now
./setup.sh             # keep them applied on every login
```

To remove the login agent:
```bash
./teardown.sh
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

## Simplification Roadmap

Once confirmed stable (no update popups after several restarts), the project can be simplified:

| What to remove | Why |
|---|---|
| `setup.sh` / `teardown.sh` / `com.xdocker.disable-updates.plist` | If `disable-updates.sh` settings stick across restarts, the hourly launchd agent is unnecessary |
| `disable-updates.sh` call in `install.sh` | If Docker 4.15.0 respects `settings.json` from first launch, no need to pre-write it |
| `reinstall.sh` | Redundant once install is proven stable — just a wrapper around `install.sh` |
| `restore-updates.sh` | Already a no-op, can be deleted |

**Recommendation:** Run Docker normally for a few days. If no update popup appears after reboot, remove the launchd agent with `./teardown.sh` and simplify to just `install.sh` + `uninstall.sh`.
