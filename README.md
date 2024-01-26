# Composer Documentation - Brazilian Portuguese

## Status

|              [2.6][branch_2_6]              |              [2.2][branch_2_2]              |              [1.10][branch_1_10]              |
|:-------------------------------------------:|:-------------------------------------------:|:---------------------------------------------:|
| [![Build Status][build_img_2_6]][build_2_6] | [![Build Status][build_img_2_2]][build_2_2] | [![Build Status][build_img_1_10]][build_1_10] |

## Setup

### Docker

1. Install [Docker][docker-install] and [Docker Compose][compose-install], and
   add the binaries to the `PATH` environment variable.

#### Docker Environment Variables

1. Create an `.env` file from `.env.dist` in the project root (or update the
   existing one) and set up the required environment variables:

   | Variable                  | Description                                       | Default                        |
   |---------------------------|---------------------------------------------------|--------------------------------|
   | COMPOSE_FILE              | The Docker Compose YAML file(s).                  |                                |
   | COMPOSE_PROJECT_DIR       | The Docker Compose directory for local config.    |                                |
   | COMPOSE_PROJECT_NAME      | The Docker Compose project name.                  | composer-doc-pt-br             |
   | DOCKER_HOST_PORT_HTTP     | HTTP port on the host machine.                    | 80                             |
   | DOCKER_NETWORK_DEFAULT    | Default external network shared between projects. | composer-doc-pt-br             |
   | DOCKER_VOLUME_APPLICATION | Application volume name.                          | composer-doc-pt-br-application |
   | MKDOCS_HOST               | MkDocs service alias.                             | localhost                      |
   | MKDOCS_PORT_HTTP          | MkDocs HTTP port.                                 | 8000                           |

#### Containers

1. Build the docker images:

   ```shell
   make docker_image_build
   ```

2. Run the containers:

   ```shell
   make docker_container_start
   ```

   > Make sure the host ports set up to the services on the
   > `docker-compose.yaml` file are free. The `ports` directive maps ports on
   > the host machine to the ports on the containers and follows the format
   > `<host-port>:<container-port>`. More info on the
   > [Compose file reference][compose-ports].

3. To stop the containers, run:

   ```shell
   make docker_container_stop
   ```

## Commands

### Composer

1. To build the documentation, execute:

    ```shell
    make mkdocs_build
    ```

## Contributing

* [Instructions][doc-contrib]

[branch_1_10]: https://github.com/php-dev-br/composer-doc-pt-br/tree/1.10

[build_1_10]: https://github.com/php-dev-br/composer-doc-pt-br/actions

[build_img_1_10]: https://github.com/php-dev-br/composer-doc-pt-br/actions/workflows/build.yaml/badge.svg?branch=1.10

[branch_2_2]: https://github.com/php-dev-br/composer-doc-pt-br/tree/2.2

[build_2_2]: https://github.com/php-dev-br/composer-doc-pt-br/actions

[build_img_2_2]: https://github.com/php-dev-br/composer-doc-pt-br/actions/workflows/build.yaml/badge.svg?branch=2.2

[branch_2_6]: https://github.com/php-dev-br/composer-doc-pt-br/tree/2.6

[build_2_6]: https://github.com/php-dev-br/composer-doc-pt-br/actions

[build_img_2_6]: https://github.com/php-dev-br/composer-doc-pt-br/actions/workflows/build.yaml/badge.svg?branch=2.6

[compose-install]: https://docs.docker.com/compose/install/

[compose-ports]: https://docs.docker.com/compose/compose-file/#ports

[docker-install]: https://docs.docker.com/install/

[doc-contrib]: CONTRIBUTING.md
