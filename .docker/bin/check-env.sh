#!/usr/bin/env bash

# Do not exit on error
set +e
set -o pipefail

# Import the environment variables from .env file.

root_dir=$(dirname $(dirname $(dirname $(readlink -f "${0}"))))

if [ -f "${root_dir}/.env" ]; then
    echo "Importing environment variables from .env file..."
    source "${root_dir}/.env"
else
    echo ".env file not found on root directory."
    echo "Errors were found. Aborting..."
    exit 1
fi

# Check environment variables

declare -a env_vars=(
    # docker
    "COMPOSE_FILE"
    "COMPOSE_PROJECT_DIR"
    "COMPOSE_PROJECT_NAME"
    "DOCKER_HOST_PORT_HTTP"
    "DOCKER_NETWORK_DEFAULT"
    "DOCKER_VOLUME_APPLICATION"

    # mkdocs
    "MKDOCS_HOST"
    "MKDOCS_PORT_HTTP"
)

env_checks=true

for i in "${env_vars[@]}"; do
    if [[ -z ${!i} ]]; then
        echo "Variable ${i} unset."
        env_checks=false
    fi
done

if [[ ${env_checks} = true ]]; then
    echo "All environment variables are set up."
    exit 0
fi
