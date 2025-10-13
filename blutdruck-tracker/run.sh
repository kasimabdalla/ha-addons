#!/bin/bash
# ==============================================================================
# Home Assistant Add-on: Blood Pressure Tracker
# Starts the Blood Pressure Tracker application
# ==============================================================================

set -eu  # Exit on error and on unset variable

echo "Starting Blood Pressure Tracker..."

# -------------------------------------------------------------------------
# Detect environment: Home Assistant or standalone (testing)
# -------------------------------------------------------------------------
if [ -f /data/options.json ]; then
    echo "Running in Home Assistant environment"

    CONFIG_PATH="/data/options.json"

    # Read options from JSON (read each line separately)
    {
        read -r SECRET_KEY
        read -r SMTP_SERVER
        read -r SMTP_PORT
        read -r SMTP_USERNAME
        read -r SMTP_PASSWORD
        read -r FROM_EMAIL
        read -r LOG_LEVEL
    } < <(
        jq -r '
            .secret_key,
            .smtp_server // "",
            .smtp_port // "587",
            .smtp_username // "",
            .smtp_password // "",
            .from_email // "",
            .log_level // "info"
        ' "$CONFIG_PATH"
    )

    # Validate
    if [ -z "$SECRET_KEY" ]; then
        echo "❌ ERROR: SECRET_KEY is required! Configure it in the add-on options."
        echo "Generate one with: openssl rand -hex 32"
        exit 1
    fi

    # Export env vars
    export SECRET_KEY
    export DATABASE_URL="sqlite+aiosqlite:////data/addon.db"
    export ALLOWED_ORIGINS="*"
    export ENVIRONMENT="production"
    export LOG_LEVEL="${LOG_LEVEL^^}"

    # Optional SMTP config
    if [ -n "$SMTP_SERVER" ] && [ -n "$SMTP_USERNAME" ] && [ -n "$SMTP_PASSWORD" ]; then
        export SMTP_SERVER SMTP_PORT SMTP_USERNAME SMTP_PASSWORD FROM_EMAIL
        echo "✓ Email notifications enabled (SMTP: $SMTP_SERVER:$SMTP_PORT, User: $SMTP_USERNAME)"
    else
        echo "⚠ Email notifications disabled (SMTP not fully configured)"
        if [ -n "$SMTP_SERVER" ]; then
            echo "  SMTP_SERVER: configured"
        fi
        if [ -n "$SMTP_USERNAME" ]; then
            echo "  SMTP_USERNAME: configured"
        fi
        if [ -n "$SMTP_PASSWORD" ]; then
            echo "  SMTP_PASSWORD: configured"
        fi
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
chmod 775 /data  # More secure than 777; adjust as needed

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
# Start supervisor (manages nginx + uvicorn)
# -------------------------------------------------------------------------
echo "Starting services via supervisor..."
exec /usr/bin/supervisord -c /etc/supervisord.conf
