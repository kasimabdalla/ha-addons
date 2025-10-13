#!/bin/bash
# ==============================================================================
# Home Assistant Add-on: Blood Pressure Tracker
# Starts the Blood Pressure Tracker application
# ==============================================================================

set -e

echo "Starting Blood Pressure Tracker..."

# -------------------------------------------------------------------------
# Detect environment: Home Assistant or standalone (testing)
# -------------------------------------------------------------------------
if [ -f /data/options.json ]; then
    echo "Running in Home Assistant environment"

    # Read options from Home Assistant add-on config using jq
    CONFIG_PATH="/data/options.json"

    SECRET_KEY=$(jq -r '.secret_key // empty' "$CONFIG_PATH")
    SMTP_SERVER=$(jq -r '.smtp_server // empty' "$CONFIG_PATH")
    SMTP_PORT=$(jq -r '.smtp_port // empty' "$CONFIG_PATH")
    SMTP_USERNAME=$(jq -r '.smtp_username // empty' "$CONFIG_PATH")
    SMTP_PASSWORD=$(jq -r '.smtp_password // empty' "$CONFIG_PATH")
    FROM_EMAIL=$(jq -r '.from_email // empty' "$CONFIG_PATH")
    LOG_LEVEL=$(jq -r '.log_level // "info"' "$CONFIG_PATH")

    # Validate
    if [ -z "$SECRET_KEY" ]; then
        echo "❌ ERROR: SECRET_KEY is required! Configure it in the add-on options."
        echo "Generate one with: openssl rand -hex 32"
        exit 1
    fi

    # Export env vars
    export SECRET_KEY="${SECRET_KEY}"
    export DATABASE_URL="sqlite+aiosqlite:////data/addon.db"   # absolute path!
    export ALLOWED_ORIGINS="*"
    export ENVIRONMENT="production"
    export LOG_LEVEL="${LOG_LEVEL^^}"

    # Optional SMTP config
    if [ -n "$SMTP_SERVER" ]; then
        export SMTP_SERVER="${SMTP_SERVER}"
        export SMTP_PORT="${SMTP_PORT}"
        export SMTP_USERNAME="${SMTP_USERNAME}"
        export SMTP_PASSWORD="${SMTP_PASSWORD}"
        export FROM_EMAIL="${FROM_EMAIL}"
        echo "✓ Email notifications enabled"
    fi
else
    echo "Running in standalone mode (testing)"

    # Defaults for local dev/testing
    export SECRET_KEY="${SECRET_KEY:-changeme-secret-key}"
    export DATABASE_URL="${DATABASE_URL:-sqlite+aiosqlite:////data/addon.db}"
    export ALLOWED_ORIGINS="${ALLOWED_ORIGINS:-*}"
    export ENVIRONMENT="${ENVIRONMENT:-production}"
    export LOG_LEVEL="${LOG_LEVEL:-INFO}"

    if [ "$SECRET_KEY" = "changeme-secret-key" ]; then
        echo "WARNING: Using default SECRET_KEY! Set SECRET_KEY env var for production."
    fi

    echo "Configuration loaded:"
    echo "  DATABASE_URL: $DATABASE_URL"
    echo "  ENVIRONMENT: $ENVIRONMENT"
    echo "  LOG_LEVEL: $LOG_LEVEL"
fi

# -------------------------------------------------------------------------
# Ensure /data exists and is writable
# -------------------------------------------------------------------------
mkdir -p /data
chmod 777 /data

echo "Database path: $DATABASE_URL"

# Strip prefix to find actual file path
DB_PATH=$(echo "$DATABASE_URL" | sed 's|.*:////||')
DB_PATH="/$DB_PATH"

echo "Database file should be at: $DB_PATH"
echo "Checking /data directory contents..."
ls -la /data || echo "/data missing!"

# Is /data a mount?
if mountpoint -q /data 2>/dev/null; then
    echo "✓ /data is a mount point (persistent storage)"
else
    echo "⚠ WARNING: /data is NOT a mount point!"
fi

# Permissions test
if touch /data/.test 2>/dev/null; then
    rm /data/.test
    echo "✓ /data is writable"
else
    echo "ERROR: /data not writable"
    exit 1
fi

# Existing DB?
if [ -f "$DB_PATH" ]; then
    echo "✓ Database file exists: $DB_PATH"
    ls -lh "$DB_PATH"
else
    echo "⚠ Database file does not exist yet: $DB_PATH"
fi

# Extra debug: check if DB is created elsewhere
echo "Searching for any existing addon.db in container..."
find / -name "addon.db" 2>/dev/null || echo "No addon.db found yet"

# -------------------------------------------------------------------------
# Start supervisor (manages nginx + uvicorn)
# -------------------------------------------------------------------------
echo "Starting services via supervisor..."
exec /usr/bin/supervisord -c /etc/supervisord.conf
