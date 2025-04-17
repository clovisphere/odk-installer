#!/bin/bash

ENVIRONMENT="$1"
ODK_VERSION="$2"
ENV_FILE="$3"

echo "Installing ODK Central for environment: $ENVIRONMENT, version: $ODK_VERSION"

# --- Prerequisites Check ---
if ! command -v docker &> /dev/null; then
    echo "Error: Docker is not installed. Please install Docker Engine."
    echo "Follow the instructions here: https://docs.docker.com/engine/install/"
    exit 1
fi
if ! command -v docker-compose &> /dev/null; then
    echo "Error: Docker Compose is not installed. Please install Docker Compose."
    echo "Follow the instructions here: https://docs.docker.com/compose/install/"
    exit 1
fi

# --- Download/Update ODK Central ---
if [ ! -d "./central" ]; then
    echo "Cloning ODK Central repository (version: $ODK_VERSION)..."
    git clone --depth 1 --branch "$ODK_VERSION" https://github.com/getodk/central central
    if [ $? -ne 0 ]; then
        echo "Error: Failed to clone the ODK Central repository."
        exit 1
    fi
else
    echo "ODK Central repository already exists. Pulling latest changes (version: $ODK_VERSION)..."
    cd central
    git fetch origin
    git checkout "$ODK_VERSION" # Ensure we are on the correct branch
    git pull origin "$ODK_VERSION"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to pull the latest changes."
        exit 1
    fi
    cd .. # Go back to the original directory
fi

# --- Environment Configuration ---
echo "Copying environment file: $ENV_FILE to ./central/.env"
cp "$ENV_FILE" ./central/.env

# --- Change Directory ---
cd central || exit 1

# --- Update submodules ---
echo "Updating submodules..."
git submodule update --init --recursive
if [ $? -ne 0 ]; then
    echo "Error: Failed to update submodules."
    exit 1
fi

# --- Allow PostgreSQL Upgrade for Local/Dev ---
if [[ "$ENVIRONMENT" == "local" || "$ENVIRONMENT" == "dev" ]]; then
    echo "Creating ./files/allow-postgres14-upgrade to allow PostgreSQL upgrade..."
    touch ./files/allow-postgres14-upgrade
fi

# --- Start ODK Central ---
echo "Starting ODK Central using Docker Compose (environment: $ENVIRONMENT)..."
# Build and start ODK Central using Docker Compose
COMPOSE_BAKE=true docker compose build && COMPOSE_BAKE=true docker compose up -d

if [ $? -ne 0 ]; then
    echo "Error: Failed to start ODK Central. Check the Docker logs."
    echo "To view the logs: docker compose logs"
    exit 1
fi

echo ""
echo "ODK Central ($ENVIRONMENT) started successfully!"
echo "You can access ODK Central by opening your web browser and navigating to http://localhost (or configured domain/port)."
echo "To create a new account. Make sure to substitute the email address that you want to use for this account:"
echo "docker compose exec service odk-cmd --email YOUREMAIL@ADDRESSHERE.com user-create"
echo "Press Enter, and you will be asked for a password for this new account."
echo "To make the new account an admin, run:"
echo "docker compose exec service odk-cmd --email YOUREMAIL@ADDRESSHERE.com user-promote"
echo ""

exit 0
