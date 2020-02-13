# Interface de Linha de Comando / Comandos

Você já aprendeu como usar a interface de linha de comando para fazer algumas
coisas. Este capítulo documenta todos os comandos disponíveis.

Para obter ajuda na linha de comando, basta chamar `composer` ou `composer list`
para ver a lista completa de comandos e, em seguida, `--help` combinado com
qualquer um deles para fornecer mais informações.

Como o Composer usa o [symfony/console][symfony-console], você pode chamar os
comandos pelo nomes abreviados, se não forem ambíguos.
```sh
composer dump
```
chama `composer dump-autoload`.

## Opções Globais

As seguintes opções estão disponíveis em todos os comandos:

* **--verbose (-v):** Aumenta a verbosidade das mensagens.
* **--help (-h):** Exibe informações de ajuda.
* **--quiet (-q):** Não gera nenhuma mensagem.
* **--no-interaction (-n):** Não faz nenhuma pergunta interativa.
* **--no-plugins:** Desabilita os plugins.
* **--no-cache:** Desabilita o uso do diretório de cache. O mesmo que definir a
  variável de ambiente `COMPOSER_CACHE_DIR` como `/dev/null` (ou `NUL` no
  Windows).
* **--working-dir (-d):** Se especificado, usa o diretório fornecido como
  diretório de trabalho.
* **--profile:** Exibe informações de tempo e uso da memória.
* **--ansi:** Força a saída ANSI.
* **--no-ansi:** Desabilita a saída ANSI.
* **--version (-V):** Exibe esta versão da aplicação.

## Códigos de Saída do Processo

* **0:** OK
* **1:** Código de erro genérico/desconhecido
* **2:** Código de erro de resolução de dependências

## init

No capítulo [Bibliotecas][libraries], vimos como criar um `composer.json`
manualmente. Há também um comando `init` disponível que facilita um pouco isso.

Quando você executa o comando, ele solicita interativamente que você preencha os
campos, enquanto usa alguns padrões inteligentes.

```sh
php composer.phar init
```

### Opções

* **--name:** Nome do pacote.
* **--description:** Descrição do pacote.
* **--author:** Nome da pessoa que criou o pacote.
* **--type:** Tipo de pacote.
* **--homepage:** Página do pacote.
* **--require:** Pacote para exigir com uma restrição de versão. Deve estar no
  formato `foo/bar:1.0.0`.
* **--require-dev:** Requisitos de desenvolvimento, consulte **--require**.
* **--stability (-s):** Valor para o campo `minimum-stability`.
* **--license (-l):** Licença do pacote.
* **--repository:** Fornece um (ou mais) repositórios personalizados. Eles serão
  armazenados no `composer.json` gerado e usados para o preenchimento automático
  ao solicitar a lista de requisitos. Cada repositório pode ser uma URL HTTP
  apontando para um repositório do `composer` ou uma string JSON semelhante à
  string aceita pela chave [repositories][schema-repositories].

## install / i

O comando `install` lê o arquivo `composer.json` presente no diretório atual,
resolve as dependências e as instala em `vendor`.

```sh
php composer.phar install
```

Se houver um arquivo `composer.lock` no diretório atual, ele usará as versões
exatas desse arquivo em vez de resolvê-las. Isso garante que todas as pessoas
usando a biblioteca obtenham as mesmas versões das dependências.

Se não houver um arquivo `composer.lock`, o Composer criará um após a resolução
das dependências.

### Opções

* **--prefer-source:** Existem duas maneiras de baixar um pacote: `source` e
  `dist`. Para versões estáveis, o Composer usará `dist` por padrão. `source` é
  um repositório de controle de versão. Se `--prefer-source` estiver habilitado,
  o Composer instalará a partir de `source`, se possível. Isso é útil se você
  deseja corrigir um bug em um projeto e obter um clone git local da dependência
  diretamente.
* **--prefer-dist:** O oposto de `--prefer-source`, o Composer instalará a
  partir de `dist`, se possível. Isso pode acelerar substancialmente as
  instalações em servidores de compilação e outros casos de uso em que você
  normalmente não executa atualizações dos fornecedores. Também é uma maneira de
  contornar problemas com o git se você não tiver uma configuração adequada.
* **--dry-run:** Se você deseja passar por uma instalação sem realmente instalar
  um pacote, pode usar `--dry-run`. Isso simulará a instalação e mostrará o que
  aconteceria.
* **--dev:** Instala os pacotes listados em `require-dev` (esse é o
  comportamento padrão).
* **--no-dev:** Ignora a instalação dos pacotes listados em `require-dev`. A
  geração do autoloader ignora as regras em `autoload-dev`.
* **--no-autoloader:** Ignora a geração do autoloader.
* **--no-scripts:** Ignora a execução dos scripts definidos no `composer.json`.
* **--no-progress:** Remove a exibição de progresso que pode interferir em
  alguns terminais ou scripts que não tratam caracteres de backspace.
* **--no-suggest:** Ignora pacotes sugeridos na saída.
* **--optimize-autoloader (-o):** Converte o autoloading PSR-0/4 em um mapa de
  classes para obter um autoloader mais rápido. Isso é recomendado especialmente
  em produção, mas pode demorar um pouco para ser executado, portanto,
  atualmente não é feito por padrão.
* **--classmap-authoritative (-a):** Faz o autoload apenas das classes do mapa
  de classes. Implicitamente habilita `--optimize-autoloader`.
* **--apcu-autoloader:** Usa o APCu para armazenar em cache as classes
  encontradas/não encontradas.
* **--ignore-platform-reqs:** Ignora os requisitos `php`, `hhvm`, `lib-*` e
  `ext-*` e força a instalação, mesmo que a máquina local não os cumpra. Veja
  também a opção de configuração [`platform`][config-platform].

## update / u

Para obter as versões mais recentes das dependências e atualizar o arquivo
`composer.lock`, você deve usar o comando `update`. Esse comando também tem um
alias `upgrade`, já que ele faz o mesmo que `upgrade` faz, se você estiver
pensando no `apt-get` ou em gerenciadores de pacotes similares.

```sh
php composer.phar update
```

Isso resolverá todas as dependências do projeto e gravará as versões exatas no
`composer.lock`.

Se você deseja atualizar apenas alguns pacotes e não todos, é possível listá-los
da seguinte forma:

```sh
php composer.phar update vendor/package vendor/package2
```

Você também pode usar curingas para atualizar vários pacotes de uma vez:

```sh
php composer.phar update "vendor/*"
```

### Opções

* **--prefer-source:** Instala os pacotes de `source`, quando disponíveis.
* **--prefer-dist:** Instala os pacotes de `dist`, quando disponíveis.
* **--dry-run:** Simula o comando sem realmente fazer nada.
* **--dev:** Instala os pacotes listados em `require-dev` (esse é o
  comportamento padrão).
* **--no-dev:** Ignora a instalação dos pacotes listados em `require-dev`. A
  geração do autoloader ignora as regras em `autoload-dev`.
* **--lock:** Atualiza apenas o hash do arquivo lock para suprimir o aviso de
  que o arquivo lock está desatualizado.
* **--no-autoloader:** Ignora a geração do autoloader.
* **--no-scripts:** Ignora a execução dos scripts definidos no `composer.json`.
* **--no-progress:** Remove a exibição de progresso que pode interferir em
  alguns terminais ou scripts que não tratam caracteres de backspace.
* **--no-suggest:** Ignora pacotes sugeridos na saída.
* **--with-dependencies:** Adiciona também dependências dos pacotes da lista de
  pacotes permitidos à lista de pacotes permitidos, exceto aquelas que são
  requisitos de primeiro grau.
* **--with-all-dependencies:** Adiciona também todas as dependências dos pacotes
  da lista de pacotes permitidos à lista de pacotes permitidos, incluindo
  aquelas que são requisitos de primeiro grau.
* **--optimize-autoloader (-o):** Converte o autoloading PSR-0/4 em um mapa de
  classes para obter um autoloader mais rápido. Isso é recomendado especialmente
  em produção, mas pode demorar um pouco para ser executado, portanto,
  atualmente não é feito por padrão.
* **--classmap-authoritative (-a):** Faz o autoload apenas das classes do mapa
  de classes. Implicitamente habilita `--optimize-autoloader`.
* **--apcu-autoloader:** Usa o APCu para armazenar em cache as classes
  encontradas/não encontradas.
* **--ignore-platform-reqs:** Ignora os requisitos `php`, `hhvm`, `lib-*` e
  `ext-*` e força a instalação, mesmo que a máquina local não os cumpra. Veja
  também a opção de configuração [`platform`][config-platform].
* **--prefer-stable:** Prefere versões estáveis das dependências.
* **--prefer-lowest:** Prefere as versões mais antigas das dependências. Útil
  para testar versões mínimas de requisitos, geralmente usada com
  `--prefer-stable`.
* **--interactive:** Interface interativa com preenchimento automático para
  selecionar os pacotes a serem atualizados.
* **--root-reqs:** Restringe a atualização às dependências de primeiro grau.

## require

O comando `require` adiciona novos pacotes ao arquivo `composer.json` presente
no diretório atual. Se nenhum arquivo existir, um arquivo será criado durante a
execução do comando.

```sh
php composer.phar require
```

Após adicionar/alterar os requisitos, os requisitos modificados serão instalados
ou atualizados.

Se você não deseja escolher os requisitos interativamente, poderá passá-los para
o comando.

```sh
php composer.phar require vendor/package:2.* vendor/package2:dev-master
```

Se você não especificar um pacote, o Composer solicitará que você procure um
pacote e, caso haja resultados, que forneça uma lista de correspondências a
serem requeridas.

### Opções

* **--dev:** Adiciona pacotes a `require-dev`.
* **--prefer-source:** Instala os pacotes de `source`, quando disponíveis.
* **--prefer-dist:** Instala os pacotes de `dist`, quando disponíveis.
* **--no-progress:** Remove a exibição de progresso que pode interferir em
  alguns terminais ou scripts que não tratam caracteres de backspace.
* **--no-suggest:** Ignora pacotes sugeridos na saída.
* **--no-update:** Desabilita a atualização automática das dependências.
* **--no-scripts:** Ignora a execução dos scripts definidos no `composer.json`.
* **--update-no-dev:** Executa a atualização de dependências com a opção
  `--no-dev`.
* **--update-with-dependencies:** Atualiza também as dependências dos novos
  pacotes requeridos, exceto aquelas que são requisitos de primeiro grau.
* **--update-with-all-dependencies:** Atualiza também as dependências dos novos
  pacotes requeridos, incluindo aquelas que são requisitos de primeiro grau.
* **--ignore-platform-reqs:** Ignora os requisitos `php`, `hhvm`, `lib-*` e
  `ext-*` e força a instalação, mesmo que a máquina local não os cumpra. Veja
  também a opção de configuração [`platform`][config-platform].
* **--prefer-stable:** Prefere versões estáveis das dependências.
* **--prefer-lowest:** Prefere as versões mais antigas das dependências. Útil
  para testar versões mínimas de requisitos, geralmente usada com
  `--prefer-stable`.
* **--sort-packages:** Mantém os pacotes ordenados no `composer.json`.
* **--optimize-autoloader (-o):** Converte o autoloading PSR-0/4 em um mapa de
  classes para obter um autoloader mais rápido. Isso é recomendado especialmente
  em produção, mas pode demorar um pouco para ser executado, portanto,
  atualmente não é feito por padrão.
* **--classmap-authoritative (-a):** Faz o autoload apenas das classes do mapa
  de classes. Implicitamente habilita `--optimize-autoloader`.
* **--apcu-autoloader:** Usa o APCu para armazenar em cache as classes
  encontradas/não encontradas.

## remove

O comando `remove` remove pacotes do arquivo `composer.json` presente no
diretório atual.

```sh
php composer.phar remove vendor/package vendor/package2
```

Após remover os requisitos, os requisitos modificados serão desinstalados.

### Opções

* **--dev:** Remove pacotes de `require-dev`.
* **--no-progress:** Remove a exibição de progresso que pode interferir em
  alguns terminais ou scripts que não tratam caracteres de backspace.
* **--no-update:** Desabilita a atualização automática das dependências.
* **--no-scripts:** Ignora a execução dos scripts definidos no `composer.json`.
* **--update-no-dev:** Executa a atualização de dependências com a opção
  `--no-dev`.
* **--update-with-dependencies:** Atualiza também as dependências dos pacotes
  removidos.
* **--ignore-platform-reqs:** Ignora os requisitos `php`, `hhvm`, `lib-*` e
  `ext-*` e força a instalação, mesmo que a máquina local não os cumpra. Veja
  também a opção de configuração [`platform`][config-platform].
* **--optimize-autoloader (-o):** Converte o autoloading PSR-0/4 em um mapa de
  classes para obter um autoloader mais rápido. Isso é recomendado especialmente
  em produção, mas pode demorar um pouco para ser executado, portanto,
  atualmente não é feito por padrão.
* **--classmap-authoritative (-a):** Faz o autoload apenas das classes do mapa
  de classes. Implicitamente habilita `--optimize-autoloader`.
* **--apcu-autoloader:** Usa o APCu para armazenar em cache as classes
  encontradas/não encontradas.

## check-platform-reqs

O comando `check-platform-reqs` verifica se as versões do PHP e das extensões
correspondem aos requisitos de plataforma dos pacotes instalados. Isso pode ser
usado para verificar se um servidor de produção possui todas as extensões
necessárias para executar um projeto após a instalação, por exemplo.

Diferente de `update`/`install`, esse comando ignorará as configurações em
`config.platform` e verificará os pacotes reais da plataforma para garantir que
você tenha as dependências de plataforma necessárias.

## global

O comando `global` permite executar outros comandos, como `install`, `remove`,
`require` ou `update`, como se você os estivesse executando a partir do
diretório [COMPOSER_HOME][composer-home].

Isso é apenas um auxiliar para gerenciar um projeto armazenado em um local
central que pode conter ferramentas da CLI ou plugins do Composer que você
deseja disponibilizar em qualquer lugar.

Isso pode ser usado para instalar utilitários da CLI globalmente. Aqui está um
exemplo:

```sh
php composer.phar global require friendsofphp/php-cs-fixer
```

Agora, o binário `php-cs-fixer` está disponível globalmente. Certifique-se de
que o diretório global de [binários dos fornecedores][article-vendor-binaries]
esteja em sua variável de ambiente `$PATH`, você pode obter sua localização com
o seguinte comando:

```sh
php composer.phar global config bin-dir --absolute
```

Se você desejar atualizar o binário posteriormente, pode executar uma
atualização global:

```sh
php composer.phar global update
```

## search

O comando `search` permite pesquisar nos repositórios de pacotes do projeto
atual. Geralmente será o Packagist. Você simplesmente passa os termos que deseja
pesquisar.

```sh
php composer.phar search monolog
```

Você também pode pesquisar mais de um termo passando vários argumentos.

### Opções

* **--only-name (-N):** Pesquisa apenas pelo nome.
* **--type (-t):** Pesquisa por um tipo de pacote específico.

## show

Para listar todos os pacotes disponíveis, você pode usar o comando `show`.

```sh
php composer.phar show
```

Para filtrar a lista, você pode passar uma máscara de pacote usando curingas.

```sh
php composer.phar show monolog/*

monolog/monolog 1.19.0 Sends your logs to files, sockets, inboxes, databases and various web services
```

Se você deseja ver os detalhes de um determinado pacote, pode passar o nome do
pacote.

```sh
php composer.phar show monolog/monolog

name     : monolog/monolog
versions : master-dev, 1.0.2, 1.0.1, 1.0.0, 1.0.0-RC1
type     : library
names    : monolog/monolog
source   : [git] https://github.com/Seldaek/monolog.git 3d4e60d0cbc4b888fe5ad223d77964428b1978da
dist     : [zip] https://github.com/Seldaek/monolog/zipball/3d4e60d0cbc4b888fe5ad223d77964428b1978da 3d4e60d0cbc4b888fe5ad223d77964428b1978da
license  : MIT

autoload
psr-0
Monolog : src/

requires
php >=5.3.0
```

Você pode até passar a versão do pacote, o que informará os detalhes dessa
versão específica.

```sh
php composer.phar show monolog/monolog 1.0.2
```

### Opções

* **--all :** Lista todos os pacotes disponíveis em todos os repositórios.
* **--installed (-i):** Lista os pacotes que estão instalados (isso está
  habilitado por padrão e a opção está obsoleta).
* **--platform (-p):** Lista apenas pacotes de plataforma (PHP e extensões).
* **--available (-a):** Lista apenas os pacotes disponíveis.
* **--self (-s):** Lista as informações do pacote raiz.
* **--name-only (-N):** Lista apenas os nomes dos pacotes.
* **--path (-P):** Lista os caminhos dos pacotes.
* **--tree (-t):** Lista as dependências como uma árvore. Se você passar um nome
  de pacote, isso mostrará a árvore de dependências para esse pacote.
* **--latest (-l):** Lista todos os pacotes instalados, incluindo a versão mais
  recente.
* **--outdated (-o):** Implica `--latest`, mas lista *apenas* pacotes que têm
  uma versão mais recente disponível.
* **--minor-only (-m):** Use com `--latest`. Mostra apenas pacotes que possuem
  atualizações menores compatíveis com o SemVer.
* **--direct (-D):** Restringe a lista de pacotes às suas dependências diretas.
* **--strict:** Retorna um código de saída diferente de zero quando há pacotes
  desatualizados.
* **--format (-f):** Permite escolher entre o formato de saída de texto (padrão)
  ou json.

## outdated

The `outdated` command shows a list of installed packages that have updates available,
including their current and latest versions. This is basically an alias for
`composer show -lo`.

The color coding is as such:

- **green (=)**: Dependency is in the latest version and is up to date.
- **yellow (~)**: Dependency has a new version available that includes backwards compatibility breaks according to semver, so upgrade when
  you can but it may involve work.
- **red (!)**: Dependency has a new version that is semver-compatible and you should upgrade it.

### Options

* **--all (-a):** Show all packages, not just outdated (alias for `composer show -l`).
* **--direct (-D):** Restricts the list of packages to your direct dependencies.
* **--strict:** Returns non-zero exit code if any package is outdated.
* **--minor-only (-m):** Only shows packages that have minor SemVer-compatible updates.
* **--format (-f):** Lets you pick between text (default) or json output format.

## browse / home

The `browse` (aliased to `home`) opens a package's repository URL or homepage
in your browser.

### Options

* **--homepage (-H):** Open the homepage instead of the repository URL.
* **--show (-s):** Only show the homepage or repository URL.

## suggests

Lists all packages suggested by currently installed set of packages. You can
optionally pass one or multiple package names in the format of `vendor/package`
to limit output to suggestions made by those packages only.

Use the `--by-package` or `--by-suggestion` flags to group the output by
the package offering the suggestions or the suggested packages respectively.

Use the `--verbose (-v)` flag to display the suggesting package and the suggestion reason.
This implies `--by-package --by-suggestion`, showing both lists.

### Options

* **--by-package:** Groups output by suggesting package.
* **--by-suggestion:** Groups output by suggested package.
* **--no-dev:** Excludes suggestions from `require-dev` packages.

## depends (why)

The `depends` command tells you which other packages depend on a certain
package. As with installation `require-dev` relationships are only considered
for the root package.

```sh
php composer.phar depends doctrine/lexer
 doctrine/annotations v1.2.7 requires doctrine/lexer (1.*)
 doctrine/common      v2.6.1 requires doctrine/lexer (1.*)
```

You can optionally specify a version constraint after the package to limit the
search.

Add the `--tree` or `-t` flag to show a recursive tree of why the package is
depended upon, for example:

```sh
php composer.phar depends psr/log -t
psr/log 1.0.0 Common interface for logging libraries
|- aboutyou/app-sdk 2.6.11 (requires psr/log 1.0.*)
|  `- __root__ (requires aboutyou/app-sdk ^2.6)
|- monolog/monolog 1.17.2 (requires psr/log ~1.0)
|  `- laravel/framework v5.2.16 (requires monolog/monolog ~1.11)
|     `- __root__ (requires laravel/framework ^5.2)
`- symfony/symfony v3.0.2 (requires psr/log ~1.0)
   `- __root__ (requires symfony/symfony ^3.0)
```

### Options

* **--recursive (-r):** Recursively resolves up to the root package.
* **--tree (-t):** Prints the results as a nested tree, implies -r.

## prohibits (why-not)

The `prohibits` command tells you which packages are blocking a given package
from being installed. Specify a version constraint to verify whether upgrades
can be performed in your project, and if not why not. See the following
example:

```sh
php composer.phar prohibits symfony/symfony 3.1
 laravel/framework v5.2.16 requires symfony/var-dumper (2.8.*|3.0.*)
```

Note that you can also specify platform requirements, for example to check
whether you can upgrade your server to PHP 8.0:

```sh
php composer.phar prohibits php:8
 doctrine/cache        v1.6.0 requires php (~5.5|~7.0)
 doctrine/common       v2.6.1 requires php (~5.5|~7.0)
 doctrine/instantiator 1.0.5  requires php (>=5.3,<8.0-DEV)
```

As with `depends` you can request a recursive lookup, which will list all
packages depending on the packages that cause the conflict.

### Options

* **--recursive (-r):** Recursively resolves up to the root package.
* **--tree (-t):** Prints the results as a nested tree, implies -r.

## validate

You should always run the `validate` command before you commit your
`composer.json` file, and before you tag a release. It will check if your
`composer.json` is valid.

```sh
php composer.phar validate
```

### Options

* **--no-check-all:** Do not emit a warning if requirements in `composer.json` use unbound or overly strict version constraints.
* **--no-check-lock:** Do not emit an error if `composer.lock` exists and is not up to date.
* **--no-check-publish:** Do not emit an error if `composer.json` is unsuitable for publishing as a package on Packagist but is otherwise valid.
* **--with-dependencies:** Also validate the composer.json of all installed dependencies.
* **--strict:** Return a non-zero exit code for warnings as well as errors.

## status

If you often need to modify the code of your dependencies and they are
installed from source, the `status` command allows you to check if you have
local changes in any of them.

```sh
php composer.phar status
```

With the `--verbose` option you get some more information about what was
changed:

```sh
php composer.phar status -v

You have changes in the following dependencies:
vendor/seld/jsonlint:
    M README.mdown
```

## self-update (selfupdate)

To update Composer itself to the latest version, run the `self-update`
command. It will replace your `composer.phar` with the latest version.

```sh
php composer.phar self-update
```

If you would like to instead update to a specific release simply specify it:

```sh
php composer.phar self-update 1.0.0-alpha7
```

If you have installed Composer for your entire system (see [global installation](00-intro.md#globally)),
you may have to run the command with `root` privileges

```sh
sudo -H composer self-update
```

### Options

* **--rollback (-r):** Rollback to the last version you had installed.
* **--clean-backups:** Delete old backups during an update. This makes the
  current version of Composer the only backup available after the update.
* **--no-progress:** Do not output download progress.
* **--update-keys:** Prompt user for a key update.
* **--stable:** Force an update to the stable channel.
* **--preview:** Force an update to the preview channel.
* **--snapshot:** Force an update to the snapshot channel.

## config

The `config` command allows you to edit composer config settings and repositories
in either the local `composer.json` file or the global `config.json` file.

Additionally it lets you edit most properties in the local `composer.json`.

```sh
php composer.phar config --list
```

### Usage

`config [options] [setting-key] [setting-value1] ... [setting-valueN]`

`setting-key` is a configuration option name and `setting-value1` is a
configuration value.  For settings that can take an array of values (like
`github-protocols`), more than one setting-value arguments are allowed.

You can also edit the values of the following properties:

`description`, `homepage`, `keywords`, `license`, `minimum-stability`,
`name`, `prefer-stable`, `type` and `version`.

See the [Config](06-config.md) chapter for valid configuration options.

### Options

* **--global (-g):** Operate on the global config file located at
  `$COMPOSER_HOME/config.json` by default.  Without this option, this command
  affects the local composer.json file or a file specified by `--file`.
* **--editor (-e):** Open the local composer.json file using in a text editor as
  defined by the `EDITOR` env variable.  With the `--global` option, this opens
  the global config file.
* **--auth (-a):** Affect auth config file (only used for --editor).
* **--unset:** Remove the configuration element named by `setting-key`.
* **--list (-l):** Show the list of current config variables.  With the `--global`
  option this lists the global configuration only.
* **--file="..." (-f):** Operate on a specific file instead of composer.json. Note
  that this cannot be used in conjunction with the `--global` option.
* **--absolute:** Returns absolute paths when fetching *-dir config values
  instead of relative.

### Modifying Repositories

In addition to modifying the config section, the `config` command also supports making
changes to the repositories section by using it the following way:

```sh
php composer.phar config repositories.foo vcs https://github.com/foo/bar
```

If your repository requires more configuration options, you can instead pass its JSON representation :

```sh
php composer.phar config repositories.foo '{"type": "vcs", "url": "http://svn.example.org/my-project/", "trunk-path": "master"}'
```

### Modifying Extra Values

In addition to modifying the config section, the `config` command also supports making
changes to the extra section by using it the following way:

```sh
php composer.phar config extra.foo.bar value
```

The dots indicate array nesting, a max depth of 3 levels is allowed though. The above
would set `"extra": { "foo": { "bar": "value" } }`.

## create-project

You can use Composer to create new projects from an existing package. This is
the equivalent of doing a git clone/svn checkout followed by a `composer install`
of the vendors.

There are several applications for this:

1. You can deploy application packages.
2. You can check out any package and start developing on patches for example.
3. Projects with multiple developers can use this feature to bootstrap the
   initial application for development.

To create a new project using Composer you can use the `create-project` command.
Pass it a package name, and the directory to create the project in. You can also
provide a version as third argument, otherwise the latest version is used.

If the directory does not currently exist, it will be created during installation.

```sh
php composer.phar create-project doctrine/orm path 2.2.*
```

It is also possible to run the command without params in a directory with an
existing `composer.json` file to bootstrap a project.

By default the command checks for the packages on packagist.org.

### Options

* **--stability (-s):** Minimum stability of package. Defaults to `stable`.
* **--prefer-source:** Instala os pacotes de `source`, quando disponíveis.
* **--prefer-dist:** Instala os pacotes de `dist`, quando disponíveis.
* **--repository:** Provide a custom repository to search for the package,
  which will be used instead of packagist. Can be either an HTTP URL pointing
  to a `composer` repository, a path to a local `packages.json` file, or a
  JSON string which similar to what the [repositories](04-schema.md#repositories)
  key accepts.
* **--dev:** Instala os pacotes listados em `require-dev` (esse é o
  comportamento padrão).
* **--no-dev:** Ignora a instalação dos pacotes listados em `require-dev`. A
  geração do autoloader ignora as regras em `autoload-dev`.
* **--no-scripts:** Ignora a execução dos scripts definidos no pacote raiz.
* **--no-progress:** Remove a exibição de progresso que pode interferir em
  alguns terminais ou scripts que não tratam caracteres de backspace.
* **--no-secure-http:** Disable the secure-http config option temporarily while
  installing the root package. Use at your own risk. Using this flag is a bad
  idea.
* **--keep-vcs:** Skip the deletion of the VCS metadata for the created
  project. This is mostly useful if you run the command in non-interactive
  mode.
* **--remove-vcs:** Force-remove the VCS metadata without prompting.
* **--no-install:** Disables installation of the vendors.
* **--ignore-platform-reqs:** Ignora os requisitos `php`, `hhvm`, `lib-*` e
  `ext-*` e força a instalação, mesmo que a máquina local não os cumpra. Veja
  também a opção de configuração [`platform`][config-platform].

## dump-autoload (dumpautoload)

If you need to update the autoloader because of new classes in a classmap
package for example, you can use `dump-autoload` to do that without having to
go through an install or update.

Additionally, it can dump an optimized autoloader that converts PSR-0/4 packages
into classmap ones for performance reasons. In large applications with many
classes, the autoloader can take up a substantial portion of every request's
time. Using classmaps for everything is less convenient in development, but
using this option you can still use PSR-0/4 for convenience and classmaps for
performance.

### Options
* **--no-scripts:** Ignora a execução dos scripts definidos no `composer.json`.
* **--optimize (-o):** Converte o autoloading PSR-0/4 em mapa de
  classes para obter um autoloader mais rápido. Isso é recomendado especialmente
  em produção, mas pode demorar um pouco para ser executado, portanto,
  atualmente não é feito por padrão.
* **--classmap-authoritative (-a):** Faz o autoload apenas das classes do mapa
  de classes. Implicitamente habilita `--optimize`.
* **--apcu:** Usa APCu para armazenar em cache as classes
  encontradas/não encontradas.
* **--no-dev:** Disables autoload-dev rules.

## clear-cache (clearcache)

Deletes all content from Composer's cache directories.

## licenses

Lists the name, version and license of every package installed. Use
`--format=json` to get machine readable output.

### Options

* **--format:** Format of the output: text or json (default: "text")
* **--no-dev:** Remove dev dependencies from the output

## run-script

### Options

* **--timeout:** Set the script timeout in seconds, or 0 for no timeout.
* **--dev:** Sets the dev mode.
* **--no-dev:** Disable dev mode.
* **--list (-l):** List user defined scripts.

To run [scripts](articles/scripts.md) manually you can use this command,
give it the script name and optionally any required arguments.

## exec

Executes a vendored binary/script. You can execute any command and this will
ensure that the Composer bin-dir is pushed on your PATH before the command
runs.

### Options

* **--list (-l):** List the available composer binaries.

## diagnose

If you think you found a bug, or something is behaving strangely, you might
want to run the `diagnose` command to perform automated checks for many common
problems.

```sh
php composer.phar diagnose
```

## archive

This command is used to generate a zip/tar archive for a given package in a
given version. It can also be used to archive your entire project without
excluded/ignored files.

```sh
php composer.phar archive vendor/package 2.0.21 --format=zip
```

### Options

* **--format (-f):** Format of the resulting archive: tar or zip (default:
  "tar")
* **--dir:** Write the archive to this directory (default: ".")
* **--file:** Write the archive with the given file name.

## help

To get more information about a certain command, you can use `help`.

```sh
php composer.phar help install
```

## Command-line completion

Command-line completion can be enabled by following instructions
[on this page](https://github.com/bamarni/symfony-console-autocomplete).

## Environment variables

You can set a number of environment variables that override certain settings.
Whenever possible it is recommended to specify these settings in the `config`
section of `composer.json` instead. It is worth noting that the env vars will
always take precedence over the values specified in `composer.json`.

### COMPOSER

By setting the `COMPOSER` env variable it is possible to set the filename of
`composer.json` to something else.

For example:

```sh
COMPOSER=composer-other.json php composer.phar install
```

The generated lock file will use the same name: `composer-other.lock` in this example.

### COMPOSER_ALLOW_SUPERUSER

If set to 1, this env disables the warning about running commands as root/super user.
It also disables automatic clearing of sudo sessions, so you should really only set this
if you use Composer as super user at all times like in docker containers.

### COMPOSER_AUTH

The `COMPOSER_AUTH` var allows you to set up authentication as an environment variable.
The contents of the variable should be a JSON formatted object containing http-basic,
github-oauth, bitbucket-oauth, ... objects as needed, and following the
[spec from the config](06-config.md#gitlab-oauth).

### COMPOSER_BIN_DIR

By setting this option you can change the `bin` ([Vendor Binaries][article-vendor-binaries])
directory to something other than `vendor/bin`.

### COMPOSER_CACHE_DIR

The `COMPOSER_CACHE_DIR` var allows you to change the Composer cache directory,
which is also configurable via the [`cache-dir`](06-config.md#cache-dir) option.

By default it points to `$COMPOSER_HOME/cache` on \*nix and macOS, and
`C:\Users\<user>\AppData\Local\Composer` (or `%LOCALAPPDATA%/Composer`) on Windows.

### COMPOSER_CAFILE

By setting this environmental value, you can set a path to a certificate bundle
file to be used during SSL/TLS peer verification.

### COMPOSER_DISCARD_CHANGES

This env var controls the [`discard-changes`](06-config.md#discard-changes) config option.

### COMPOSER_HOME

The `COMPOSER_HOME` var allows you to change the Composer home directory. This
is a hidden, global (per-user on the machine) directory that is shared between
all projects.

By default it points to `C:\Users\<user>\AppData\Roaming\Composer` on Windows
and `/Users/<user>/.composer` on macOS. On \*nix systems that follow the [XDG Base
Directory Specifications](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html),
it points to `$XDG_CONFIG_HOME/composer`. On other \*nix systems, it points to
`/home/<user>/.composer`.

#### COMPOSER_HOME/config.json

You may put a `config.json` file into the location which `COMPOSER_HOME` points
to. Composer will merge this configuration with your project's `composer.json`
when you run the `install` and `update` commands.

This file allows you to set [repositories](05-repositories.md) and
[configuration](06-config.md) for the user's projects.

In case global configuration matches _local_ configuration, the _local_
configuration in the project's `composer.json` always wins.

### COMPOSER_HTACCESS_PROTECT

Defaults to `1`. If set to `0`, Composer will not create `.htaccess` files in the
composer home, cache, and data directories.

### COMPOSER_MEMORY_LIMIT

If set, the value is used as php's memory_limit.

### COMPOSER_MIRROR_PATH_REPOS

If set to 1, this env changes the default path repository strategy to `mirror` instead
of `symlink`. As it is the default strategy being set it can still be overwritten by
repository options.

### COMPOSER_NO_INTERACTION

If set to 1, this env var will make Composer behave as if you passed the
`--no-interaction` flag to every command. This can be set on build boxes/CI.

### COMPOSER_PROCESS_TIMEOUT

This env var controls the time Composer waits for commands (such as git
commands) to finish executing. The default value is 300 seconds (5 minutes).

### COMPOSER_ROOT_VERSION

By setting this var you can specify the version of the root package, if it can
not be guessed from VCS info and is not present in `composer.json`.

### COMPOSER_VENDOR_DIR

By setting this var you can make Composer install the dependencies into a
directory other than `vendor`.

### http_proxy or HTTP_PROXY

If you are using Composer from behind an HTTP proxy, you can use the standard
`http_proxy` or `HTTP_PROXY` env vars. Simply set it to the URL of your proxy.
Many operating systems already set this variable for you.

Using `http_proxy` (lowercased) or even defining both might be preferable since
some tools like git or curl will only use the lower-cased `http_proxy` version.
Alternatively you can also define the git proxy using
`git config --global http.proxy <proxy url>`.

If you are using Composer in a non-CLI context (i.e. integration into a CMS or
similar use case), and need to support proxies, please provide the `CGI_HTTP_PROXY`
environment variable instead. See [httpoxy.org](https://httpoxy.org/) for further
details.

### HTTP_PROXY_REQUEST_FULLURI

If you use a proxy but it does not support the request_fulluri flag, then you
should set this env var to `false` or `0` to prevent Composer from setting the
request_fulluri option.

### HTTPS_PROXY_REQUEST_FULLURI

If you use a proxy but it does not support the request_fulluri flag for HTTPS
requests, then you should set this env var to `false` or `0` to prevent Composer
from setting the request_fulluri option.

### COMPOSER_SELF_UPDATE_TARGET

If set, makes the self-update command write the new Composer phar file into that path instead of overwriting itself. Useful for updating Composer on read-only filesystem.

### no_proxy or NO_PROXY

If you are behind a proxy and would like to disable it for certain domains, you
can use the `no_proxy` or `NO_PROXY` env var. Simply set it to a comma separated list of
domains the proxy should *not* be used for.

The env var accepts domains, IP addresses, and IP address blocks in CIDR
notation. You can restrict the filter to a particular port (e.g. `:80`). You
can also set it to `*` to ignore the proxy for all HTTP requests.

&larr; [Libraries](02-libraries.md)  |  [Schema](04-schema.md) &rarr;

[article-vendor-binaries]: articles/vendor-binaries.md
[composer-home]: #composer_home
[config-platform]: 06-config.md#platform
[libraries]: bibliotecas.md
[schema-repositories]: 04-schema.md#repositories
[symfony-console]: https://github.com/symfony/console
