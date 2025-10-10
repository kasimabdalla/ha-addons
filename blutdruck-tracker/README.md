# Home Assistant Add-on: Blood Pressure Tracker

[![Release][release-shield]][release-url]
[![License][license-shield]][license-url]

Track and monitor blood pressure measurements with charts, analytics, and email notifications.

## About

This Home Assistant add-on provides a full-featured blood pressure tracking application with:

- 📊 Blood pressure measurement tracking
- 📈 Visual analytics with charts and trends
- 👤 Multi-user support with authentication
- 📧 Email notifications (verification & password reset)
- 🌍 Multi-language support (EN, DE, ES, FR)
- 📱 Responsive web interface
- 🏠 Home Assistant ingress integration

## Installation

### Method 1: Add-on Store (Recommended)

1. Navigate to **Settings** → **Add-ons** → **Add-on Store**
2. Click the **⋮** menu → **Repositories**
3. Add this repository: `https://github.com/kasimabdalla/ha-addons`
4. Find "Blood Pressure Tracker" and click **Install**
5. Configure the add-on (see Configuration below)
6. Click **Start**

### Method 2: Manual Installation (Development)

```bash
# Clone the repository
git clone https://github.com/kasimabdalla/blutdruck-app-v2
cd blutdruck-app-v2

# Add as local add-on in Home Assistant
# Settings → Add-ons → Add-on Store → ⋮ → Repositories
# Add: /path/to/blutdruck-app-v2
```

## Configuration

### Minimal Configuration

```yaml
secret_key: "your-secret-key-here"
```

Generate with: `openssl rand -hex 32`

### Full Configuration

```yaml
secret_key: "faa9f5dd112019642f87220b902a479a91e68fa8070cde0e013091209829369e"
smtp_server: "smtp.gmail.com"
smtp_port: 587
smtp_username: "your-email@gmail.com"
smtp_password: "your-app-password"
from_email: "your-email@gmail.com"
log_level: "info"
```

## Usage

### First Run

1. Start the add-on
2. Check logs for initial admin password:
   ```
   ⚠️  INITIAL ADMIN PASSWORD: xxxxx
   ```
3. Access via **Open Web UI** or sidebar panel (❤️ icon)
4. Log in with username `admin` and the generated password
5. **Change password immediately** in Settings

### Access Methods

**Ingress (Default - Recommended):**
- ✅ Embedded in Home Assistant UI
- ✅ Click "Open Web UI" or sidebar panel (❤️ icon)
- ✅ No additional configuration needed
- ✅ Works with authentication and email verification
- ✅ Automatically handles URL paths for email links

**Direct Access:**
- Available at: `http://homeassistant.local:8099`
- Useful for external access or mobile bookmarks
- Requires network access to the specified port

## Features

### Blood Pressure Tracking
- Log systolic, diastolic, and pulse measurements
- Add notes and timestamps
- View history and trends

### Analytics
- Interactive charts and graphs
- Trend analysis
- Date range filtering
- Export data (coming soon)

### User Management
- Multi-user support
- Role-based access (admin/user)
- Email verification
- Password reset via email

## Files

```
homeassistant/
├── config.yaml          # Add-on metadata and options
├── Dockerfile           # Multi-stage build
├── run.sh              # Startup script
├── DOCS.md             # User documentation
├── CHANGELOG.md        # Version history
├── README.md           # This file
└── icon.png            # Add-on icon (optional)
```

## Development

### Building Locally

**Important**: Build from project root with Dockerfile context:

```bash
# Navigate to project root
cd blutdruck-app-v2

# Build for local architecture (context = project root)
docker build -t blutdruck-tracker \
  --build-arg BUILD_FROM=ghcr.io/hassio-addons/base:18.1.4 \
  -f homeassistant/Dockerfile \
  .

docker save local/blutdruck-tracker:latest | gzip > blutdruck-app.tar.gz

# Run locally for testing
docker run --rm -it \
  -v $(pwd)/data:/data \
  -p 8099:80 \
  blutdruck-tracker
```

**Note**: The Dockerfile uses parent context paths (e.g., `COPY frontend/` instead of `COPY ../frontend/`), so it must be built from the project root.

### Multi-Architecture Build

```bash
# Build for all architectures (from project root)
cd blutdruck-app-v2

docker buildx build \
  --platform linux/amd64,linux/arm64,linux/arm/v7 \
  -t ghcr.io/kasimabdalla/blutdruck-tracker:latest \
  --push \
  -f homeassistant/Dockerfile \
  .
```

### Home Assistant Builder

When using Home Assistant's official builder, create `repository.yaml`:

```yaml
name: Blood Pressure Add-ons
url: https://github.com/kasimabdalla/blutdruck-app-v2
```

Then point HA to the repository root. The builder will automatically:
1. Find `homeassistant/config.yaml`
2. Use `homeassistant/Dockerfile`
3. Build from repository root (parent context)

## Support

- **Documentation**: [DOCS.md](DOCS.md)
- **Issues**: [GitHub Issues](https://github.com/kasimabdalla/blutdruck-app-v2/issues)
- **Forum**: [Home Assistant Community](https://community.home-assistant.io/)

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history.

## License

MIT License - See [LICENSE](../LICENSE) for details.

## Credits

- Built with [FastAPI](https://fastapi.tiangolo.com/) and [Vue 3](https://vuejs.org/)
- Home Assistant base image by [Home Assistant Community Add-ons](https://github.com/hassio-addons)

---

[release-shield]: https://img.shields.io/github/v/release/kasimabdalla/blutdruck-app-v2?style=for-the-badge
[release-url]: https://github.com/kasimabdalla/blutdruck-app-v2/releases
[license-shield]: https://img.shields.io/github/license/kasimabdalla/blutdruck-app-v2?style=for-the-badge
[license-url]: https://github.com/kasimabdalla/blutdruck-app-v2/blob/main/LICENSE
