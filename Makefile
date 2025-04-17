# Makefile for ODK Central installation

ODK_VERSION  ?= v2024.3.2
ENV_FILE     ?= .env.local
TRANSFER_DIR ?= /tmp/odk-transfer

.PHONY: all local dev prod stop clear

all: local # Default target is local install

local:
	@echo "Installing ODK Central locally (version: $(ODK_VERSION))..."
	@./install.sh local $(ODK_VERSION) $(ENV_FILE) $(TRANSFER_DIR)

dev:
	@echo "Installing ODK Central for development (version: $(ODK_VERSION))..."
	@./install.sh dev $(ODK_VERSION) $(ENV_FILE)

prod:
	@echo "Installing ODK Central for production (version: $(ODK_VERSION))..."
	@./install.sh prod $(ODK_VERSION) $(ENV_FILE)

stop:
	@echo "Stopping ODK Central (all environments)..."
	@if [ "$(ENV_FILE)" = ".env.local" ]; then \
        echo "Stopping and removing ODK Central (local environment)..."; \
        docker compose down --volumes --remove-orphans; \
    else \
        echo "Skipping stop command. This is only applicable for ENV_FILE=.env.local"; \
    fi

clear:
	echo "Removing installation directory: ./central"; \
	rm -rf ./central; \
