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
  string aceita pela chave [repositories][schema-repos].

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
  também a opção de configuração [`platform`][conf-platform].

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
php composer.phar update "nome-vendor/*"
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
  também a opção de configuração [`platform`][conf-platform].
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
  também a opção de configuração [`platform`][conf-platform].
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
  também a opção de configuração [`platform`][conf-platform].
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
que o diretório global dos [binários dos vendors][art-binaries] esteja em sua
variável de ambiente `PATH`, você pode obter sua localização com o seguinte
comando:

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

Veja o capítulo [Configuração][conf] para conhecer as opções de configuração
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
php composer.phar config repositories.foo '{"type": "vcs", "url": "http://svn.exemplo.org.br/meu-projeto/", "trunk-path": "master"}'
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
  [repositories][schema-repos].
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
  também a opção de configuração [`platform`][conf-platform].

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

Para executar [scripts][art-scripts] manualmente, você pode usar esse comando,
passando o nome do script e, opcionalmente, quaisquer argumentos necessários.

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

Esse comando é usado para gerar um arquivo compactado zip/tar para um
determinado pacote em uma determinada versão. Também pode ser usado para
arquivar seu projeto inteiro sem os arquivos excluídos/ignorados.

```sh
php composer.phar archive vendor/pacote 2.0.21 --format=zip
```

### Opções {: #opcoes-archive }

* **--format (-f):** Formato do arquivo compactado resultante: `tar` ou `zip`
  (padrão: `tar`).
* **--dir:** Salva o arquivo compactado neste diretório (padrão: `.`).
* **--file:** Salva o arquivo compactado com o nome de arquivo especificado.

## help

Para obter mais informações sobre um determinado comando, você pode usar `help`.

```sh
php composer.phar help install
```

## Preenchimento Automático na Linha de Comando

O preenchimento automático na linha de comando pode ser habilitado seguindo as
instruções [nesta página][console-autocomplete].

## Variáveis de Ambiente

Você pode definir algumas variáveis de ambiente que substituem determinadas
configurações. Sempre que possível, é recomendável especificar essas
configurações na seção `config` do `composer.json`. Vale ressaltar que as
variáveis de ambiente sempre terão precedência sobre os valores especificados no
`composer.json`.

### COMPOSER

Ao definir a variável de ambiente `COMPOSER`, é possível definir o nome do
arquivo `composer.json` como algum outro.

Por exemplo:

```sh
COMPOSER=outro-composer.json php composer.phar install
```

O arquivo lock gerado usará o mesmo nome: `outro-composer.lock` nesse exemplo.

### COMPOSER_ALLOW_SUPERUSER {: #composer-allow-superuser }

Se definida como `1`, esta variável de ambiente desabilita o aviso sobre a
execução de comandos como root/superusuário. Ela também desabilita a limpeza
automática de sessões sudo; portanto, você realmente deve defini-la apenas se
usar o Composer como superusuário o tempo todo, como em containers do Docker.

### COMPOSER_AUTH {: #composer-auth }

A variável `COMPOSER_AUTH` permite configurar a autenticação como uma variável
de ambiente. O conteúdo da variável deve ser um objeto JSON contendo objetos
`http-basic`, `github-oauth`, `bitbucket-oauth`, ..., conforme necessário e
seguindo as [especificações da configuração][conf-gitlab].

### COMPOSER_BIN_DIR {: #composer-bin-dir }

Ao definir esta opção, você pode alterar o diretório `bin` ([Binários dos
Vendors][art-binaries]) para algo diferente de `vendor/bin`.

### COMPOSER_CACHE_DIR {: #composer-cache-dir }

A variável `COMPOSER_CACHE_DIR` permite alterar o diretório de cache do
Composer, que também é configurável através da opção [`cache-dir`][conf-cache].

Por padrão, ela aponta para `$COMPOSER_HOME/cache` no \*nix e macOS e
`C:\Users\<user>\AppData\Local\Composer` (ou `%LOCALAPPDATA%\Composer`) no
Windows.

### COMPOSER_CAFILE {: #composer-cafile }

Ao definir esta variável de ambiente, é possível definir um caminho para um
arquivo de pacote de certificado que será usado durante a verificação por par
SSL/TLS.

### COMPOSER_DISCARD_CHANGES {: #composer-discard-changes }

Esta variável controla a opção de configuração [`discard-changes`]
[conf-discard].

### COMPOSER_HOME {: #composer-home }

A variável `COMPOSER_HOME` permite alterar o diretório inicial do Composer. Este
é um diretório oculto global (por usuário na máquina) compartilhado entre todos
os projetos.

Por padrão, ela aponta para `C:\Users\<usuario>\AppData\Roaming\Composer` no
Windows e `/Users/<usuario>/.composer` no macOS. Em sistemas \*nix que seguem as
[Especificações de Diretório Base do XDG][art-basedir], ela aponta para
`$XDG_CONFIG_HOME/composer`. Em outros sistemas \*nix, ela aponta para
`/home/<usuario>/.composer`.

#### COMPOSER_HOME/config.json {: #composer-home-config-json }

Você pode colocar um arquivo `config.json` no local para o qual `COMPOSER_HOME`
aponta. O Composer combinará esta configuração com o `composer.json` do seu
projeto quando você executar os comandos `install` e `update`.

Esse arquivo permite definir [repositórios][repos] e [configurações][conf] para
os seus projetos.

Caso a configuração global corresponda à configuração _local_, a configuração _local_
no `composer.json` do projeto sempre vence.

### COMPOSER_HTACCESS_PROTECT {: #composer-htaccess-protect }

O padrão é `1`. Se definida como `0`, o Composer não criará arquivos `.htaccess`
nos diretórios home, cache e data do Composer.

### COMPOSER_MEMORY_LIMIT {: #composer-memory-limit }

Se definida, o valor é usado como `memory_limit` do PHP.

### COMPOSER_MIRROR_PATH_REPOS {: #composer-mirror-path-repos }

Se definida como `1`, esta variável de ambiente altera a estratégia padrão do
repositório de caminhos para `mirror` em vez de `symlink`. Como é a estratégia
padrão definida, ela ainda pode ser substituída pelas opções do repositório.

### COMPOSER_NO_INTERACTION {: #composer-no-interaction }

Se definida como `1`, esta variável de ambiente fará o Composer se comportar
como se você passasse a flag `--no-interaction` para todos os comandos. Ela pode
ser definida em servidores de build/CI.

### COMPOSER_PROCESS_TIMEOUT {: #composer-process-timeout }

Esta variável de ambiente controla o tempo que o Composer espera por comandos
(como comandos do git) antes de finalizar a execução. O valor padrão é 300
segundos (5 minutos).

### COMPOSER_ROOT_VERSION {: #composer-root-version }

Ao definir esta variável, você pode especificar a versão do pacote raiz, se ela
não puder ser deduzida a partir das informações do VCS e não estiver presente no
`composer.json`.

### COMPOSER_VENDOR_DIR {: #composer-vendor-dir }

Ao definir esta variável, você pode fazer com que o Composer instale as
dependências em um diretório que não seja o `vendor`.

### http_proxy ou HTTP_PROXY {: #http-proxy }

Se você estiver usando o Composer por trás de um proxy HTTP, poderá usar a
variável de ambiente padrão `http_proxy` ou `HTTP_PROXY`. Basta configurá-la
como a URL do seu proxy. Muitos sistemas operacionais já definem esta variável
para você.

Usar `http_proxy` (letras minúsculas) ou mesmo definir as duas pode ser
preferível, pois algumas ferramentas como git ou curl usarão apenas a versão
`http_proxy` com letras minúsculas. Como alternativa, você também pode definir o
proxy do git usando `git config --global http.proxy <url-do-proxy>`.

Se você estiver usando o Composer em um contexto que não seja a CLI (ou seja,
integração em um CMS ou caso de uso semelhante) e precisar oferecer suporte a
proxies, forneça a variável de ambiente `CGI_HTTP_PROXY`. Consulte [httpoxy
.org][httpoxy] para mais detalhes.

### HTTP_PROXY_REQUEST_FULLURI {: #http-proxy-request-fulluri }

Se você usar um proxy, mas ele não suportar a flag `request_fulluri`, então você
deve definir esta variável como `false` ou `0` para impedir que o Composer
defina a opção `request_fulluri`.

### HTTPS_PROXY_REQUEST_FULLURI {: #https-proxy-request-fulluri }

Se você usar um proxy, mas ele não suportar a flag `request_fulluri` para
requisições HTTPS, então você deve definir esta variável como `false` ou `0`
para impedir que o Composer defina a opção `request_fulluri`.

### COMPOSER_SELF_UPDATE_TARGET {: #composer-self-update-target }

Se definida, faz com que o comando `self-update` salve o novo arquivo phar do
Composer neste caminho em vez de sobrescrever-se. Útil para atualizar o Composer
em sistemas de arquivos somente leitura.

### no_proxy ou NO_PROXY {: #no-proxy }

Se você estiver atrás de um proxy e deseja desabilitá-lo para determinados
domínios, pode usar a variável de ambiente `no_proxy` ou `NO_PROXY`.
Simplesmente defina-a como uma lista de domínios separados por vírgula para os
quais o proxy *não* deve ser usado.

A variável de ambiente aceita domínios, endereços de IP e blocos de endereços de
IP em notação CIDR. Você pode restringir o filtro a uma porta específica (por
exemplo, `:80`). Você também pode configurá-la como `*` para ignorar o proxy
para todas as requisições HTTP.

[art-scripts]: artigos/scripts.md
[art-binaries]: artigos/vendor-binaries.md
[art-basedir]: https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
[composer-home]: #composer-home
[conf]: 06-config.md
[conf-cache]:06-config.md#cache-dir
[conf-discard]: 06-config.md#discard-changes
[conf-gitlab]: 06-config.md#gitlab-oauth
[conf-platform]: 06-config.md#platform
[httpoxy]: https://httpoxy.org
[intro-globally]: introducao.md#globalmente
[libraries]: bibliotecas.md
[packagist]: https://packagist.org/
[repos]: repositorios.md
[schema-repos]: esquema.md#repositories
[symfony-console]: https://github.com/symfony/console
[console-autocomplete]: https://github.com/bamarni/symfony-console-autocomplete
