# Desenvolvimento

**_Nota: As configurações a seguir são baseadas no Linux. Ajustes podem ser
necessários para o uso do Docker Compose no ambiente Windows._**

## Requisitos

1. Instale o [Docker][docker-install] e o [Docker Compose][compose-install],
   e adicione os binários à variável de ambiente `PATH`.

2. Em seguida, você executar os scripts auxiliares no diretório `.deploy/local/bin`:

    ```
    .deploy/local
    ├── bin
    │   ├── check-env.sh
    │   ├── install-env.sh
    │   └── set-aliases.sh
    ├── services
    │   └── nginx
    ├── docker-compose.yaml
    └── .env.dist
    .env
    ```

## Variáveis de Ambiente

1. Acesse o diretório `.deploy/local`, crie um arquivo `.env` a partir de `.env.dist`
   e configure as variáveis usadas nos containers:

    | Variável                 | Descrição                                                      |
    | ------------------------ | -------------------------------------------------------------- |
    | COMPOSE_FILE             | O arquivo docker-compose.yaml do projeto.                      |
    | COMPOSE_PROJECT_DIR      | O diretório docker-compose do projeto para configuração local. |
    | COMPOSE_PROJECT_NAME     | Nome do projeto usado como prefixo ao criar os containers.     |
    | DEV_HOST_PORT_HTTP       | Porta HTTP usada na máquina host. Padrão: 80.                  |
    | DOCKER_HOST_GID          | O ID do grupo (`$GID`) do usuário na máquina host.             |
    | DOCKER_HOST_UID          | O ID do usuário (`$UID`) na máquina host.                      |
    | DOCKER_IMAGE_PYTHON      | Imagem usada pela imagem base do python.                       |
    | DOCKER_IMAGE_PYTHON_BASE | Imagem base do python.                                         |

    Para obter o `$GID` e o `$UID`, execute os seguintes comandos:

    ```
    id -u <user>
    id -g <group>
    ```

## Instalação

1. A partir do **diretório raiz do projeto**, execute os seguintes comandos para
   criar aliases para as ferramentas de desenvolvimento:

    ```
    COMPOSE_PROJECT_DIR=${PWD}/.deploy/local

    . .deploy/local/bin/install-env.sh
    ```

2. Os seguintes aliases serão criados:

    * dc
    * mkdocs

## Containers

1. Crie as imagens do Docker:

    ```
    dc build --parallel --force-rm
    ```

1. Execute os containers:

    ```
    dc up -d
    ```

    _Nota: Verifique se as portas do host configuradas para os serviços no arquivo
    `docker-compose.yaml` estão livres. A diretiva `ports` mapeia portas na
    máquina host para portas nos containers e segue o formato
    `<porta-no-host>:<porta-no-container>`.
    Mais informações na [referência do arquivo do Compose][compose-ports]._

1. Para parar os containers, execute:

    ```
    dc down
    ```

## Comandos

### MkDocs

1. Para criar um novo projeto, execute:

    ```
    mkdocs new .
    ```

1. Para criar a documentação, execute:

    ```
    mkdocs build
    ```

[compose-install]: https://docs.docker.com/compose/install/
[compose-ports]: https://docs.docker.com/compose/compose-file/#ports
[docker-install]: https://docs.docker.com/install/
