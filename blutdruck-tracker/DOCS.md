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

**Gmail Setup:**
1. Enable 2-factor authentication in your Google account
2. Generate an App Password: [Google Account → Security → App Passwords](https://myaccount.google.com/apppasswords)
3. Use the generated password in `smtp_password`

**Other Email Providers:**
- **Mailgun**: `smtp.mailgun.org:587`
- **SendGrid**: `smtp.sendgrid.net:587`
- **Outlook**: `smtp-mail.outlook.com:587`

#### Log Level

```yaml
log_level: info  # debug, info, warning, error
```

### Example Configuration

```yaml
secret_key: "faa9f5dd112019642f87220b902a479a91e68fa8070cde0e013091209829369e"
smtp_server: smtp.gmail.com
smtp_port: 587
smtp_username: myemail@gmail.com
smtp_password: abcd-efgh-ijkl-mnop
from_email: myemail@gmail.com
log_level: info
```

## First Run

### Initial Admin Account

On first start, an admin account is automatically created:
- **Username**: `admin`
- **Password**: Check the add-on logs for the generated password
- **Important**: Change this password immediately after first login!

**To find the initial password:**
1. Go to **Settings** → **Add-ons** → **Blood Pressure Tracker**
2. Click the **Log** tab
3. Look for: `⚠️ INITIAL ADMIN PASSWORD: xxxxx`

### User Registration

After logging in as admin, you can:
- Create additional users
- Manage user roles and permissions
- Configure email verification (if SMTP is configured)

## Usage

### Tracking Blood Pressure

1. Log in to the web interface
2. Navigate to **Blood Pressure** page
3. Click **Add Measurement**
4. Enter:
   - Systolic pressure (top number)
   - Diastolic pressure (bottom number)
   - Pulse (optional)
   - Notes (optional)
5. Click **Save**

### Viewing Analytics

- **Dashboard**: Overview of recent measurements
- **Blood Pressure Page**: Detailed charts and trends
- **Filters**: View data by date range, time of day, etc.

### User Profile

- Update personal information
- Configure health profile (height, weight, age)
- View measurement history
- Export data (coming soon)

## Ingress vs Direct Access

### Ingress (Recommended)

- Embedded in Home Assistant UI
- Appears in sidebar with ❤️ icon
- No additional port needed
- Uses Home Assistant's authentication

**Enable Ingress:**
- Already enabled by default
- Access via sidebar or "Open Web UI" button

### Direct Access

- Standalone web interface
- Accessible at `http://homeassistant.local:8099`
- Separate authentication
- Useful for external access or bookmarking

**Enable Direct Access:**
- Ingress and direct access work simultaneously
- Configure port mapping if needed (default: 8099)

## Data Storage

All data is stored in the add-on's persistent storage:
- **Database**: `/data/auth.db` (SQLite)
- **Backups**: Included in Home Assistant backups

**Manual Backup:**
```bash
# From Home Assistant terminal
docker exec -it $(docker ps -qf "name=blutdruck") \
  sqlite3 /data/auth.db ".backup '/data/backup.db'"
```

## Troubleshooting

### Add-on won't start

1. Check logs for errors
2. Verify `secret_key` is configured
3. Ensure port 8099 is not in use by another add-on

### Email not working

1. Verify SMTP settings are correct
2. Check firewall allows outbound port 587/465
3. For Gmail, use App Password (not account password)
4. Check logs for SMTP errors

### Cannot log in

1. Check add-on logs for initial admin password
2. Try password reset (if email is configured)
3. Restart add-on to regenerate admin account

### Database errors

1. Stop the add-on
2. Backup `/data/auth.db` if needed
3. Delete corrupted database (will lose data!)
4. Restart add-on to create fresh database

## Support

- **Issues**: [GitHub Issues](https://github.com/kasimabdalla/blutdruck-app-v2/issues)
- **Documentation**: [Full Documentation](https://github.com/kasimabdalla/blutdruck-app-v2)
- **Home Assistant Forum**: [Community Forum](https://community.home-assistant.io/)

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history.

## License

MIT License - See LICENSE file for details
