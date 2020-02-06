#!/usr/bin/env bash

# Do not exit on error
set +e
set -o pipefail

# Check requirements and install environment

if [[ -z ${COMPOSE_PROJECT_DIR} ]]; then
    echo "Variable COMPOSE_PROJECT_DIR unset."
    exit 1
fi

. "${COMPOSE_PROJECT_DIR}/bin/check-env.sh"

. "${COMPOSE_PROJECT_DIR}/bin/set-aliases.sh"
