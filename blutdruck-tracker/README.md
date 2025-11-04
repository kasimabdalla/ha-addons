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
