# Home Assistant Add-on Dockerfile for Blood Pressure Tracker
# Multi-stage build: Frontend → Backend → Production

ARG BUILD_FROM=ghcr.io/hassio-addons/base:18.2.1
ARG BUILD_ARCH=amd64

# ============================================
# Stage 1: Build Frontend (Vue 3 + Vite)
# ============================================
FROM node:22-alpine AS frontend-builder

WORKDIR /frontend

# Install pnpm
RUN corepack enable && corepack prepare pnpm@latest --activate

# Copy frontend package files (from parent context)
COPY frontend/package.json frontend/pnpm-lock.yaml ./

# Install dependencies
RUN pnpm install --frozen-lockfile

# Copy frontend source code (from parent context)
COPY frontend/ ./

# Set production API URL (relative path for same-origin)
ENV VITE_API_BASE_URL=/api/v1

# Build for production
RUN pnpm build

# ============================================
# Stage 2: Production with Python 3.13
# ============================================
FROM python:3.13-alpine

# Declare build args for this stage
ARG BUILD_ARCH=amd64

# Install bash first
RUN apk add --no-cache bash

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install runtime dependencies (jq for reading Home Assistant config)
RUN apk update && \
    apk add --no-cache \
    nginx \
    supervisor \
    curl \
    openssl \
    jq

# Create app directory
WORKDIR /app

# Copy backend application (from parent context)
COPY backend/ ./backend/

# Install Python dependencies
RUN pip3 install --no-cache-dir -e ./backend/ && \
    pip3 install --no-cache-dir uvicorn[standard]

# Copy built frontend from frontend-builder
COPY --from=frontend-builder /frontend/dist /usr/share/nginx/html

# Copy nginx configuration (from parent context)
COPY docker/nginx.conf /etc/nginx/nginx.conf

# Generate self-signed certificate for HTTP/2 support
RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/key.pem \
    -out /etc/nginx/ssl/cert.pem \
    -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost"

# Copy supervisor configuration (from parent context)
COPY docker/supervisord.conf /etc/supervisord.conf

# Copy run script (from homeassistant directory)
COPY homeassistant/run.sh /
RUN chmod a+x /run.sh

# Create directories for database and supervisor logs
RUN mkdir -p /data && \
    chmod 777 /data && \
    mkdir -p /var/log/supervisor && \
    chmod 777 /var/log/supervisor

# Add version label to force rebuild
LABEL version="1.0.46"

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD curl -f http://localhost/health || exit 1

# Labels for Home Assistant
LABEL \
    io.hass.name="Blood Pressure Tracker" \
    io.hass.description="Track and monitor blood pressure measurements" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version="1.0.46" \
    maintainer="Your Name <your-email@example.com>" \
    org.opencontainers.image.title="Blood Pressure Tracker" \
    org.opencontainers.image.description="Track and monitor blood pressure measurements" \
    org.opencontainers.image.vendor="Home Assistant Community Add-ons" \
    org.opencontainers.image.authors="Your Name <your-email@example.com>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://github.com/yourusername/blutdruck-app-v2" \
    org.opencontainers.image.source="https://github.com/yourusername/blutdruck-app-v2" \
    org.opencontainers.image.documentation="https://github.com/yourusername/blutdruck-app-v2/blob/main/homeassistant/DOCS.md"

# Run the add-on
CMD ["/run.sh"]
