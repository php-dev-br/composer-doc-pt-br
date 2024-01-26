### application ###

-include .env

all:
	@echo ${COMPOSE_PROJECT_NAME}

### docker ###

docker_image_build:
	@COMPOSE_DOCKER_CLI_BUILD=1 docker compose \
	   	--file ${COMPOSE_FILE} \
	   	--env-file ${COMPOSE_PROJECT_DIR}/../.env \
		build

docker_container_start:
	@COMPOSE_DOCKER_CLI_BUILD=1 docker compose \
	   	--file ${COMPOSE_FILE} \
	   	--env-file ${COMPOSE_PROJECT_DIR}/../.env \
		up -d

docker_container_stop:
	@docker compose \
		--file ${COMPOSE_FILE} \
		--env-file ${COMPOSE_PROJECT_DIR}/../.env \
		down

### mkdocs ###

mkdocs_build:
	@COMPOSE_DOCKER_CLI_BUILD=1 docker compose \
	   	--file ${COMPOSE_FILE} \
	   	--env-file ${COMPOSE_PROJECT_DIR}/../.env \
	   	run \
			--rm \
			mkdocs mkdocs build
