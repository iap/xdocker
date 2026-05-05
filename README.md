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
