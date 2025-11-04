# Blood Pressure Tracker Add-on

Track and monitor your blood pressure measurements with charts, analytics, and email notifications.

![Blood Pressure Tracker](logo.png)

## About

This add-on allows you to track blood pressure readings over time with:

- **📊 Blood Pressure Tracking** - Log systolic, diastolic, and pulse measurements
- **📈 Visual Analytics** - Charts and graphs showing trends over time
- **👤 User Management** - Multi-user support with role-based access
- **📧 Email Notifications** - Account verification and password reset
- **🌍 Multi-language** - English, German, Spanish, and French
- **📱 Responsive Design** - Works on desktop, tablet, and mobile

## Installation

1. Add this repository to your Home Assistant add-on store:
   - Navigate to **Settings** → **Add-ons** → **Add-on Store** (⋮ menu)
   - Click **Repositories** and add: `https://github.com/kasimabdalla/ha-addons`

2. Find "Blood Pressure Tracker" in the add-on store

3. Click **Install**

4. Configure the add-on (see Configuration section below)

5. Click **Start**

6. Access the add-on:
   - **Ingress (recommended)**: Click "Open Web UI" or use the sidebar panel
   - **Direct access**: `http://homeassistant.local:8099`

## Configuration

### Required Configuration

```yaml
secret_key: "your-secret-key-here"
```

**Generate a secure secret key:**
```bash
openssl rand -hex 32
```

If left empty, a random key will be generated on first start (check logs).

### Optional Configuration

#### Email Settings (for verification and password reset)

```yaml
smtp_server: smtp.gmail.com
smtp_port: 587
smtp_username: your-email@gmail.com
smtp_password: your-app-specific-password
from_email: your-email@gmail.com
```


## Support

- **Issues**: [GitHub Issues](https://github.com/kasimabdalla/blutdruck-app-v2/issues)
- **Documentation**: [Full Documentation](https://github.com/kasimabdalla/blutdruck-app-v2)
- **Home Assistant Forum**: [Community Forum](https://community.home-assistant.io/)

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history.

## License

MIT License - See LICENSE file for details
