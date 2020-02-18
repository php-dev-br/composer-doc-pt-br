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

### Opções {: #opcoes-init }

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

### Opções {: #opcoes-install }

* **--prefer-source:** Existem duas maneiras de baixar um pacote: `source` e
  `dist`. Para versões estáveis, o Composer usará `dist` por padrão. `source` é
  um repositório de controle de versão. Se `--prefer-source` estiver habilitado,
  o Composer instalará a partir de `source`, se possível. Isso é útil se você
  deseja corrigir um bug em um projeto e obter um clone git local da dependência
  diretamente.
* **--prefer-dist:** O oposto de `--prefer-source`, o Composer instalará a
  partir de `dist`, se possível. Isso pode acelerar substancialmente as
  instalações em servidores de compilação e outros casos de uso em que você
  normalmente não executa atualizações dos vendors. Também é uma maneira de
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
  em produção, mas pode demorar um pouco para ser executado, portanto, no
  momento não é feito por padrão.
* **--classmap-authoritative (-a):** Faz o autoload apenas das classes do mapa
  de classes. Implicitamente habilita `--optimize-autoloader`.
* **--apcu-autoloader:** Usa a APCu para armazenar em cache as classes
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
php composer.phar update vendor/pacote vendor/pacote2
```

Você também pode usar curingas para atualizar vários pacotes de uma vez:

```sh
php composer.phar update "vendor/*"
```

### Opções {: #opcoes-update }

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
  em produção, mas pode demorar um pouco para ser executado, portanto, no
  momento não é feito por padrão.
* **--classmap-authoritative (-a):** Faz o autoload apenas das classes do mapa
  de classes. Implicitamente habilita `--optimize-autoloader`.
* **--apcu-autoloader:** Usa a APCu para armazenar em cache as classes
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
php composer.phar require vendor/pacote:2.* vendor/pacote2:dev-master
```

Se você não especificar um pacote, o Composer solicitará que você procure um
pacote e, caso haja resultados, que forneça uma lista de correspondências a
serem requeridas.

### Opções {: #opcoes-require }

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
  em produção, mas pode demorar um pouco para ser executado, portanto, no
  momento não é feito por padrão.
* **--classmap-authoritative (-a):** Faz o autoload apenas das classes do mapa
  de classes. Implicitamente habilita `--optimize-autoloader`.
* **--apcu-autoloader:** Usa a APCu para armazenar em cache as classes
  encontradas/não encontradas.

## remove

O comando `remove` remove pacotes do arquivo `composer.json` presente no
diretório atual.

```sh
php composer.phar remove vendor/pacote vendor/pacote2
```

Após remover os requisitos, os requisitos modificados serão desinstalados.

### Opções {: #opcoes-remove }

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
  em produção, mas pode demorar um pouco para ser executado, portanto, no
  momento não é feito por padrão.
* **--classmap-authoritative (-a):** Faz o autoload apenas das classes do mapa
  de classes. Implicitamente habilita `--optimize-autoloader`.
* **--apcu-autoloader:** Usa a APCu para armazenar em cache as classes
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
que o diretório global dos [binários dos vendors][article-vendor-binaries] esteja
em sua variável de ambiente `PATH`, você pode obter sua localização com o
seguinte comando:

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

### Opções {: #opcoes-search }

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

### Opções {: #opcoes-show }

* **--all :** Lista todos os pacotes disponíveis em todos os repositórios.
* **--installed (-i):** Lista os pacotes que estão instalados (isso está
  habilitado por padrão e a opção está obsoleta).
* **--platform (-p):** Lista apenas pacotes de plataforma (PHP e extensões).
* **--available (-a):** Lista apenas os pacotes disponíveis.
* **--self (-s):** Lista as informações do pacote raiz.
* **--name-only (-N):** Lista apenas os nomes dos pacotes.
* **--path (-P):** Lista os caminhos dos pacotes.
* **--tree (-t):** Lista as dependências como uma árvore. Se você passar um nome
  de pacote, isso exibirá a árvore de dependências para esse pacote.
* **--latest (-l):** Lista todos os pacotes instalados, incluindo a versão mais
  recente.
* **--outdated (-o):** Implica `--latest`, mas lista *apenas* pacotes que têm
  uma versão mais recente disponível.
* **--minor-only (-m):** Use com `--latest`. Exibe apenas pacotes que possuem
  atualizações menores compatíveis com o SemVer.
* **--direct (-D):** Restringe a lista de pacotes às dependências diretas.
* **--strict:** Retorna um código de saída diferente de zero quando há pacotes
  desatualizados.
* **--format (-f):** Permite escolher entre o formato de saída de texto (padrão)
  ou json.

## outdated

O comando `outdated` exibe uma lista de pacotes instalados que possuem
atualizações disponíveis, incluindo suas versões atuais e mais recentes. Isso é
basicamente um alias para `composer show -lo`.

O código de cores é o seguinte:

- **verde (=)**: A dependência está na versão mais recente e atualizada.
- **amarelo (~)**: A dependência possui uma nova versão disponível, que inclui
  quebra de compatibilidade com versões anteriores de acordo com o SemVer;
  portanto, atualize quando puder, mas isso pode envolver algum trabalho.
- **vermelho (!)**: A dependência possui uma nova versão que é compatível com o
  SemVer e você deve atualizá-la.

### Opções {: #opcoes-outdated }

* **--all (-a):** Exibe todos os pacotes, não apenas os desatualizados (alias
  para `composer show -l`).
* **--direct (-D):** Restringe a lista de pacotes às dependências diretas.
* **--strict:** Retorna um código de saída diferente de zero quando há pacotes
  desatualizados.
* **--minor-only (-m):** Exibe apenas pacotes que possuem atualizações menores
  compatíveis com o SemVer.
* **--format (-f):** Permite escolher entre o formato de saída de texto (padrão)
  ou json.

## browse / home

O comando `browse` (ou o alias `home`) abre a URL do repositório ou a página do
pacote no navegador.

### Opções {: #opcoes-browse }

* **--homepage (-H):** Abre a página do pacote em vez da URL do repositório.
* **--show (-s):** Apenas exibe a página ou a URL do repositório.

## suggests

Lista todos os pacotes sugeridos pelo conjunto de pacotes atualmente instalado.
Opcionalmente, você pode passar um ou mais nomes de pacotes no formato
`vendor/package` para limitar a saída apenas às sugestões feitas por esses
pacotes.

Use as flags `--by-package` ou `--by-suggestion` para agrupar a saída pelo
pacote que faz as sugestões ou pelos pacotes sugeridos, respectivamente.

Use a flag `--verbose (-v)` para exibir o pacote que faz a sugestão e o motivo
da sugestão. Isso implica `--by-package --by-suggestion`, mostrando as duas
listas.

### Opções {: #opcoes-suggests }

* **--by-package:** Agrupa a saída pelo pacote que faz a sugestão.
* **--by-suggestion:** Agrupa a saída pelo pacote sugerido.
* **--no-dev:** Exclui sugestões dos pacotes de `require-dev`.

## depends (why)

O comando `depends` informa quais outros pacotes dependem de um determinado
pacote. Assim como na instalação, os relacionamentos em `require-dev` são
considerados apenas para o pacote raiz.

```sh
php composer.phar depends doctrine/lexer
 doctrine/annotations v1.2.7 requires doctrine/lexer (1.*)
 doctrine/common      v2.6.1 requires doctrine/lexer (1.*)
```

Opcionalmente, você pode especificar uma restrição de versão após o pacote para
limitar a pesquisa.

Adicione a flag `--tree` ou `-t` para mostrar uma árvore recursiva do motivo da
dependência do pacote, por exemplo:

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

### Opções {: #opcoes-depends }

* **--recursive (-r):** Resolve recursivamente até o pacote raiz.
* **--tree (-t):** Exibe os resultados como uma árvore aninhada, implica `-r`.

## prohibits (why-not)

O comando `prohibits` informa quais pacotes estão impedindo a instalação de um
determinado pacote. Especifique uma restrição de versão para verificar se as
atualizações podem ser executadas no seu projeto e, se não, por que não. Veja o
seguinte exemplo:

```sh
php composer.phar prohibits symfony/symfony 3.1
 laravel/framework v5.2.16 requires symfony/var-dumper (2.8.*|3.0.*)
```

Observe que você também pode especificar os requisitos de plataforma, por
exemplo, para verificar se você pode atualizar seu servidor para o PHP 8.0:

```sh
php composer.phar prohibits php:8
 doctrine/cache        v1.6.0 requires php (~5.5|~7.0)
 doctrine/common       v2.6.1 requires php (~5.5|~7.0)
 doctrine/instantiator 1.0.5  requires php (>=5.3,<8.0-DEV)
```

Assim como `depends`, você pode solicitar uma pesquisa recursiva, que listará
todos os pacotes que dependem dos pacotes que causam o conflito.

### Opções {: #opcoes-prohibits }

* **--recursive (-r):** Resolve recursivamente até o pacote raiz.
* **--tree (-t):** Exibe os resultados como uma árvore aninhada, implica `-r`.

## validate

Você sempre deve executar o comando `validate` antes de fazer o commit do
arquivo `composer.json` e antes de criar a tag de uma versão. Ele verificará se
o `composer.json` é válido.

```sh
php composer.phar validate
```

### Opções {: #opcoes-validate }

* **--no-check-all:** Não emite um aviso se os requisitos do `composer.json`
  usarem restrições de versão não acopladas ou excessivamente rígidas.
* **--no-check-lock:** Não emite um erro se o `composer.lock` existir e não
  estiver atualizado.
* **--no-check-publish:** Não emite um erro se o `composer.json` for inadequado
  para publicação como um pacote no Packagist, mas for válido.
* **--with-dependencies:** Também valida o `composer.json` de todas as
  dependências instaladas.
* **--strict:** Retorna um código de saída diferente de zero para avisos e
  erros.

## status

Se você precisar modificar frequentemente o código de suas dependências e elas
são instaladas a partir de `source`, o comando `status` permitirá verificar se
há alterações locais em alguma delas.

```sh
php composer.phar status
```

Com a opção `--verbose`, você obtém mais informações sobre o que foi alterado:

```sh
php composer.phar status -v

You have changes in the following dependencies:
vendor/seld/jsonlint:
    M README.mdown
```

## self-update (selfupdate)

Para atualizar o próprio Composer para a versão mais recente, execute o comando
`self-update`. Ele substituirá seu `composer.phar` pela versão mais recente.

```sh
php composer.phar self-update
```

Se você deseja atualizar para uma versão específica, basta especificar:

```sh
php composer.phar self-update 1.0.0-alpha7
```

Se você instalou o Composer para todo o sistema (consulte a [instalação global]
[intro-globally]), pode ser necessário executar o comando com privilégios de
`root`.

```sh
sudo -H composer self-update
```

### Opções {: #opcoes-self-update }

* **--rollback (-r):** Reverte para a última versão que você instalou.
* **--clean-backups:** Exclui os backups antigos durante uma atualização. Isso
  torna a versão atual do Composer o único backup disponível após a atualização.
* **--no-progress:** Remove a exibição de progresso do download.
* **--update-keys:** Solicita uma atualização de chave.
* **--stable:** Força uma atualização para o canal estável.
* **--preview:** Força uma atualização para o canal preview.
* **--snapshot:** Força uma atualização para o canal snapshot.

## config

O comando `config` permite editar configurações e repositórios do Composer tanto
no arquivo local `composer.json` quanto no arquivo global `config.json`.

Além disso, permite editar a maioria das propriedades no `composer.json` local.

```sh
php composer.phar config --list
```

### Uso

`config [opcoes] [nome-configuracao] [valor-configuracao1] ... [valor-configuracaoN]`

`nome-configuracao` é um nome de opção de configuração e `valor-configuracao1`
é um valor de configuração. Para configurações que podem receber uma lista de
valores (como `github-protocols`), mais de um argumento `valor-configuracao` é
permitido.

Você também pode editar os valores das seguintes propriedades:

`description`, `homepage`, `keywords`, `license`, `minimum-stability`,
`name`, `prefer-stable`, `type` e `version`.

Veja o capítulo [Configuração][config] para conhecer as opções de configuração
válidas.

### Opções {: #opcoes-config }

* **--global (-g):** Opera no arquivo de configuração global localizado em
  `$COMPOSER_HOME/config.json` por padrão. Sem essa opção, esse comando afeta o
  arquivo `composer.json` local ou um arquivo especificado por `--file`.
* **--editor (-e):** Abre o arquivo `composer.json` local usando um editor de
  texto conforme definido pela variável de ambiente `EDITOR`. Com a opção
  `--global`, abre o arquivo de configuração global.
* **--auth (-a):** Afeta o arquivo de configuração de autenticação (usada apenas
  para `--editor`).
* **--unset:** Remove o elemento de configuração nomeado por
  `nome-configuracao`.
* **--list (-l):** Exibe a lista de variáveis de configuração atuais. Com a
  opção `--global`, lista apenas as configurações globais.
* **--file="..." (-f):** Opera em um arquivo específico em vez do
  `composer.json`. Note que isso não pode ser usado em conjunto com a opção
  `--global`.
* **--absolute:** Retorna caminhos absolutos em vez de caminhos relativos ao
  buscar valores de configuração `*-dir`.

### Modificando Repositórios

Além de modificar a seção `config`, o comando `config` também suporta
alterações na seção `repositories`, usando-o da seguinte maneira:

```sh
php composer.phar config repositories.foo vcs https://github.com/foo/bar
```

Se o seu repositório exigir mais opções de configuração, você poderá passar sua
representação JSON:

```sh
php composer.phar config repositories.foo '{"type": "vcs", "url": "http://svn.example.org/meu-projeto/", "trunk-path": "master"}'
```

### Modificando Valores Extras

Além de modificar a seção `config`, o comando `config` também suporta alterações
na seção `extra`, usando-o da seguinte maneira:

```sh
php composer.phar config extra.foo.bar valor
```

Os pontos indicam aninhamento de arrays, embora seja permitida uma profundidade
máxima de 3 níveis. O comando acima definiria
`"extra": { "foo": { "bar": "valor" } }`.

## create-project

Você pode usar o Composer para criar novos projetos a partir de um pacote
existente. Isso é o equivalente a fazer um `git clone` ou um `svn checkout`
seguido por um `composer install` dos vendors.

Existem várias aplicações para isso:

1. Você pode implantar pacotes de aplicações.
1. Você pode baixar qualquer pacote e começar a desenvolver patches, por
   exemplo.
1. Projetos com vários desenvolvedores podem usar esse recurso para inicializar
   a aplicação inicial para desenvolvimento.

Para criar um novo projeto usando o Composer, você pode usar o comando
`create-project`. Passe o nome de um pacote e o diretório para criar o
projeto. Você também pode fornecer uma versão como terceiro argumento, caso
contrário, a versão mais recente será usada.

Se o diretório não existir, será criado durante a instalação.

```sh
php composer.phar create-project doctrine/orm caminho 2.2.*
```

Também é possível executar o comando sem parâmetros em um diretório com um
arquivo `composer.json` existente para inicializar um projeto.

Por padrão, o comando procura por pacotes no [Packagist][packagist].

### Opções {: #opcoes-create-project }

* **--stability (-s):** Estabilidade mínima do pacote. O padrão é `stable`.
* **--prefer-source:** Instala os pacotes de `source`, quando disponíveis.
* **--prefer-dist:** Instala os pacotes de `dist`, quando disponíveis.
* **--repository:** Fornece um repositório personalizado para pesquisar o
  pacote, que será usado no lugar do Packagist. Pode ser uma URL HTTP apontando
  para um repositório do `composer`, um caminho para um arquivo `packages.json`
  local ou uma string JSON semelhante à string aceita pela chave
  [repositories][schema-repositories].
* **--dev:** Instala os pacotes listados em `require-dev` (esse é o
  comportamento padrão).
* **--no-dev:** Ignora a instalação dos pacotes listados em `require-dev`. A
  geração do autoloader ignora as regras em `autoload-dev`.
* **--no-scripts:** Ignora a execução dos scripts definidos no pacote raiz.
* **--no-progress:** Remove a exibição de progresso que pode interferir em
  alguns terminais ou scripts que não tratam caracteres de backspace.
* **--no-secure-http:** Desabilita a opção de configuração `secure-http`
  temporariamente ao instalar o pacote raiz. Use por sua conta e risco. Usar
  essa flag é uma má ideia.
* **--keep-vcs:** Ignora a exclusão dos metadados do VCS para o projeto criado.
  Isso é útil principalmente se você executar o comando em modo não interativo.
* **--remove-vcs:** Força a remoção dos metadados do VCS sem pedir confirmação.
* **--no-install:** Desabilita a instalação dos vendors.
* **--ignore-platform-reqs:** Ignora os requisitos `php`, `hhvm`, `lib-*` e
  `ext-*` e força a instalação, mesmo que a máquina local não os cumpra. Veja
  também a opção de configuração [`platform`][config-platform].

## dump-autoload (dumpautoload)

Se você precisar atualizar o autoloader por causa de novas classes em um pacote
de mapa de classes, por exemplo, poderá usar `dump-autoload` para fazer isso sem
precisar passar por uma instalação ou atualização.

Além disso, ele pode fazer o dump de um autoloader otimizado que converte
pacotes PSR-0/4 em pacotes de mapa de classes por motivos de desempenho. Em
aplicações grandes com muitas classes, o autoloader pode ocupar uma porção
substancial do tempo de cada requisição. O uso de mapas de classes para tudo é
menos conveniente durante o desenvolvimento, mas, usando essa opção, você ainda
pode usar PSR-0/4 por conveniência e mapas de classes por desempenho.

### Opções {: #opcoes-dump-autoload }

* **--no-scripts:** Ignora a execução dos scripts definidos no `composer.json`.
* **--optimize (-o):** Converte o autoloading PSR-0/4 em um mapa de classes para
  obter um autoloader mais rápido. Isso é recomendado especialmente em produção,
  mas pode demorar um pouco para ser executado, portanto, no momento não é feito
  por padrão.
* **--classmap-authoritative (-a):** Faz o autoload apenas das classes do mapa
  de classes. Implicitamente habilita `--optimize`.
* **--apcu:** Usa a APCu para armazenar em cache as classes encontradas/não
  encontradas.
* **--no-dev:** Desabilita as regras em `autoload-dev`.

## clear-cache (clearcache)

Exclui todo o conteúdo dos diretórios de cache do Composer.

## licenses

Lista o nome, versão e licença de cada pacote instalado. Use `--format=json`
para obter uma saída legível para máquinas.

### Opções {: #opcoes-licenses }

* **--format:** Formato da saída: `text` ou `json` (padrão: `text`).
* **--no-dev:** Remove as dependências de desenvolvimento da saída.

## run-script

### Opções {: #opcoes-run-script }

* **--timeout:** Define o tempo limite do script em segundos ou 0 para
  desabilitar o tempo limite.
* **--dev:** Habilita o modo de desenvolvimento.
* **--no-dev:** Desabilita o modo de desenvolvimento.
* **--list (-l):** Lista os scripts definidos por quem que está desenvolvendo.

Para executar [scripts][article-scripts] manualmente, você pode usar esse
comando, passando o nome do script e, opcionalmente, quaisquer argumentos
necessários.

## exec

Executa um binário ou script de um vendor. Você pode executar qualquer comando e
isso garantirá que o diretório `bin-dir` do Composer seja adicionado à variável
`PATH` antes do comando ser executado.

### Opções {: #opcoes-exec }

* **--list (-l):** Lista os binários disponíveis no Composer.

## diagnose

Se você acha que encontrou um erro ou se algo está se comportando de maneira
estranha, convém executar o comando `diagnose` para realizar verificações
automatizadas de muitos problemas comuns.

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

### Opções {: #opcoes-archive }

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

[article-scripts]: articles/scripts.md
[article-vendor-binaries]: articles/vendor-binaries.md
[composer-home]: #composer-home
[config]: 06-config.md
[config-platform]: 06-config.md#platform
[intro-globally]: introducao.md#globalmente
[libraries]: bibliotecas.md
[packagist]: https://packagist.org/
[schema-repositories]: 04-schema.md#repositories
[symfony-console]: https://github.com/symfony/console
