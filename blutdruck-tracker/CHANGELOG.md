# Changelog - Home Assistant Add-on

All notable changes to the Blood Pressure Tracker Home Assistant add-on will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.31] - 2025-10-10

### Fixed
- 🐛 Fixed Home Assistant configuration reading using jq instead of bashio
- 🔧 Simplified add-on integration by reading /data/options.json directly
- 📝 Database now correctly uses addon.db in HA environment
- 🔨 Removed unnecessary bashio dependency

### Changed
- ⚡ Switched from bashio to direct JSON parsing with jq (more reliable)
- 📋 Improved configuration validation and error messages

## [1.0.30] - 2025-10-10

### Changed
- 🔧 Renamed database file from `auth.db` to `addon.db` for clarity
- 📦 Excluded development `.env` files from Docker image
- 🧹 Cleaned up unnecessary build artifacts

### Fixed
- 🐛 Removed unused `app.db` file from Docker image
- 🔒 Prevented development environment variables from being copied into production image

## [1.0.29] - 2025-10-10

### Added
- ✨ **Full Home Assistant Ingress Support**
  - Automatic ingress path detection
  - Seamless sidebar integration
  - No port configuration required
  - Works with all ingress URL patterns

- 🔗 **Smart Email URL Generation**
  - Email verification links use correct ingress URLs
  - Password reset links work within ingress
  - Request-based URL detection

- 📱 **Multi-Access Support**
  - Ingress (embedded in HA UI)
  - Direct port access (8099)
  - Standalone Docker deployment

### Changed
- ⚡ Simplified build process (no runtime patching)
- 🎯 Embedded ingress detection in index.html
- 🧹 Removed verbose debug logging
- 📦 Streamlined Docker image

### Fixed
- 🐛 404 errors when accessing via ingress
- 🔧 Email verification links in ingress mode
- 🚦 Rate limiting issues with ingress proxy
- 🎨 Asset loading in ingress paths

### Removed
- 🗑️ Runtime patch script (no longer needed)
- 🗑️ Unnecessary debug logs
- 🗑️ Temporary diagnostic code

## [1.0.0] - 2025-10-09

### Added
- 🎉 Initial release
- 📊 Blood pressure tracking
- 📈 Analytics and charts
- 👤 User authentication (JWT)
- 📧 Email verification
- 🔐 Password reset
- 🌍 Multi-language support (EN, DE, ES, FR)
- 🌓 Dark mode
- 📱 Responsive design
- 🐳 Docker deployment

---

[1.0.29]: https://github.com/yourusername/blutdruck-app-v2/releases/tag/v1.0.29
[1.0.0]: https://github.com/yourusername/blutdruck-app-v2/releases/tag/v1.0.0
