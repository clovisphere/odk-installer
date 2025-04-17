#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# --- Parse Arguments ---
ENVIRONMENT="$1"
ODK_VERSION="$2"
ENV_FILE="$3"
TRANSFER_DIR="$4"

echo "Installing ODK Central for environment: $ENVIRONMENT, version: $ODK_VERSION"

# --- Prerequisites Check ---
command -v docker &> /dev/null || {
    echo "Error: Docker is not installed. Install it: https://docs.docker.com/engine/install/"
    exit 1
}

command -v docker-compose &> /dev/null || {
    echo "Error: Docker Compose is not installed. Install it: https://docs.docker.com/compose/install/"
    exit 1
}

# --- Download or Update ODK Central ---
if [ ! -d "./central" ]; then
    echo "Cloning ODK Central repository (version: $ODK_VERSION)..."
    git clone --depth 1 --branch "$ODK_VERSION" https://github.com/getodk/central central
else
    echo "ODK Central directory already exists. Updating to version: $ODK_VERSION..."
    pushd central > /dev/null
    git fetch origin
    git checkout "$ODK_VERSION"
    git pull origin "$ODK_VERSION"
    popd > /dev/null
fi

# --- Environment Configuration ---
echo "Copying environment file to ./central/.env"
cp "$ENV_FILE" ./central/.env

# --- Change to central directory ---
cd central

# --- Update submodules ---
echo "Updating submodules..."
git submodule update --init --recursive

# --- Allow PostgreSQL Upgrade for Local/Dev ---
if [[ "$ENVIRONMENT" == "local" || "$ENVIRONMENT" == "dev" ]]; then
    echo "Creating ./files/allow-postgres14-upgrade to allow PostgreSQL upgrade..."
    touch ./files/allow-postgres14-upgrade
fi

# --- Create Override Compose File for Local Environment on macOS ---
if [[ "$ENVIRONMENT" == "local" && "$OSTYPE" == "darwin"* ]]; then
    # --- Ensure the Transfer Directory Exists ---
    echo "Ensuring the transfer directory exists: $TRANSFER_DIR"
    mkdir -p "$TRANSFER_DIR"

    echo "Creating docker-compose.override.yml with dynamic transfer volume (macOS only)..."

    cp docker-compose.yml docker-compose.override.yml

    echo "Updating transfer volume path to: $TRANSFER_DIR"
    sed -i '' "s|/data/transfer:/data/transfer|${TRANSFER_DIR}:/data/transfer|g" docker-compose.override.yml

    echo "Starting ODK Central with override compose file..."
    COMPOSE_BAKE=true docker compose -f docker-compose.override.yml build
    COMPOSE_BAKE=true docker compose -f docker-compose.override.yml up -d
else
    echo "Starting ODK Central with default docker-compose.yml..."
    COMPOSE_BAKE=true docker compose build
    COMPOSE_BAKE=true docker compose up -d
fi

# --- Post-Startup Info ---
echo ""
echo "✅ ODK Central ($ENVIRONMENT) started successfully!"
echo "Access it at: http://localhost (or configured domain/port)"
echo ""
echo "➡ To create a new user account, run:"
echo "docker compose exec service odk-cmd --email YOUREMAIL@ADDRESSHERE.com user-create"
echo ""
echo "➡ To promote that account to admin:"
echo "docker compose exec service odk-cmd --email YOUREMAIL@ADDRESSHERE.com user-promote"
echo ""

exit 0
