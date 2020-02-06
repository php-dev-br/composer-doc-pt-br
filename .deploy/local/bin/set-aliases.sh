#!/usr/bin/env bash

alias dc="docker-compose \
    --project-directory ${COMPOSE_PROJECT_DIR} \
    --file ${COMPOSE_FILE} \
    $@"

alias mkdocs="dc \
    exec python mkdocs $@"
