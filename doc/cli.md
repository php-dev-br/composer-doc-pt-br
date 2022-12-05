# Interface de Linha de Comando / Comandos

Você já aprendeu como usar a interface de linha de comando para fazer algumas
coisas. Este capítulo documenta todos os comandos disponíveis.

Para obter ajuda na linha de comando, basta executar `composer` ou
`composer list` para ver a lista completa de comandos e, em seguida, `--help`
combinado com qualquer um deles para fornecer mais informações.

Como o Composer usa o [symfony/console][page-console], você pode executar os
comandos usando os nomes abreviados, se não forem ambíguos.
```sh
composer dump
```
executa `composer dump-autoload`.

## Opções Globais

As seguintes opções estão disponíveis em todos os comandos:

* **--verbose (-v):** aumenta a verbosidade das mensagens.
* **--help (-h):** exibe informações de ajuda.
* **--quiet (-q):** não gera nenhuma mensagem.
* **--no-interaction (-n):** não faz nenhuma pergunta interativa.
* **--no-plugins:** desabilita os plugins.
* **--no-cache:** desabilita o uso do diretório de cache. O mesmo que definir a
  variável de ambiente `COMPOSER_CACHE_DIR` como `/dev/null` (ou `NUL` no
  Windows).
* **--working-dir (-d):** se especificada, usa o diretório fornecido como
  diretório de trabalho.
* **--profile:** exibe informações de tempo e uso da memória.
* **--ansi:** força a saída ANSI.
* **--no-ansi:** desabilita a saída ANSI.
* **--version (-V):** exibe a versão desta aplicação.

## Códigos de Saída do Processo

* **0:** OK
* **1:** código de erro genérico/desconhecido
* **2:** código de erro de resolução de dependências

## init

No capítulo [Bibliotecas][book-libs], vimos como criar um `composer.json`
manualmente. Também existe um comando `init` disponível para isso.

Ao executar o comando, ele solicitará interativamente que você preencha os
campos, enquanto usa alguns padrões inteligentes.

```sh
php composer.phar init
```

### Opções {: #opcoes-init }

* **--name:** nome do pacote.
* **--description:** descrição do pacote.
* **--author:** nome da pessoa que criou o pacote.
* **--type:** tipo do pacote.
* **--homepage:** página do pacote.
* **--require:** pacote requerido com uma restrição de versão. Deve estar no
  formato `foo/bar:1.0.0`.
* **--require-dev:** requisitos de desenvolvimento, consulte **--require**.
* **--stability (-s):** valor para o campo `minimum-stability`.
* **--license (-l):** licença do pacote.
* **--repository:** fornece um ou mais repositórios personalizados. Eles serão
  armazenados no `composer.json` gerado e usados para o preenchimento automático
  ao solicitar a lista de requisitos. Cada repositório pode ser um URL HTTP
  apontando para um repositório do `composer` ou uma string JSON semelhante à
  string aceita pela chave [`repositories`][book-repositories].

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

* **--prefer-source:** existem duas maneiras de baixar um pacote: `source` e
  `dist`. Para versões estáveis, o Composer usará `dist` por padrão. `source` é
  um repositório de controle de versão. Se `--prefer-source` estiver habilitada,
  o Composer instalará a partir de `source`, se houver um. Isso é útil se você
  deseja corrigir uma falha num projeto e obter um clone git local da
  dependência diretamente.
* **--prefer-dist:** o oposto de `--prefer-source`, o Composer instalará a
  partir de `dist`, se possível. Isso pode acelerar substancialmente as
  instalações em servidores de compilação e outros casos de uso em que você
  normalmente não executa atualizações dos vendors. Também é uma maneira de
  contornar problemas com o git se você não tiver uma configuração adequada.
* **--dry-run:** se você deseja executar uma instalação sem realmente instalar
  um pacote, pode usar `--dry-run`. Isso simulará a instalação e mostrará o que
  aconteceria.
* **--dev:** instala os pacotes listados em `require-dev` (este é o
  comportamento padrão).
* **--no-dev:** ignora a instalação dos pacotes listados em `require-dev`. A
  geração do autoloader ignora as regras em `autoload-dev`.
* **--no-autoloader:** ignora a geração do autoloader.
* **--no-scripts:** ignora a execução dos scripts definidos no `composer.json`.
* **--no-progress:** remove a exibição de progresso que pode interferir em
  alguns terminais ou scripts que não tratam caracteres de backspace.
* **--optimize-autoloader (-o):** converte o autoloading PSR-0/4 num mapa de
  classes para obter um autoloader mais rápido. Isso é recomendado especialmente
  em produção, mas pode demorar um pouco para ser executado, portanto,
  atualmente não é feito por padrão.
* **--classmap-authoritative (-a):** faz o autoload apenas das classes do mapa
  de classes. Habilita implicitamente `--optimize-autoloader`.
* **--apcu-autoloader:** usa a APCu para armazenar em cache as classes
  encontradas/não encontradas.
* **--apcu-autoloader-prefix:** usa um prefixo personalizado para o cache do
  autoloader da APCu. Habilita implicitamente `--apcu-autoloader`.
* **--ignore-platform-reqs:** ignora todos os requisitos de plataforma (`php`,
  `hhvm`, `lib-*` e `ext-*`) e força a instalação, mesmo que a máquina local não
  atenda a eles. Veja também a opção de configuração [`platform`]
[book-platform].
* **--ignore-platform-req:** ignora um requisito de plataforma específico
  (`php`, `hhvm`, `lib-*` e `ext-*`) e força a instalação, mesmo que a máquina
  local não atenda a ele.

## update / u

Para obter as versões mais recentes das dependências e atualizar o arquivo
`composer.lock`, você deve usar o comando `update`. Este comando também tem o
apelido `upgrade`, já que ele faz o mesmo que `upgrade`, se você estiver
pensando no `apt-get` ou em gerenciadores de pacotes similares.

```sh
php composer.phar update
```

Isso resolverá todas as dependências do projeto e gravará as versões exatas no
`composer.lock`.

Se você deseja atualizar apenas alguns pacotes e não todos, pode listá-los da
seguinte forma:

```sh
php composer.phar update vendor/pacote vendor/pacote2
```

Você também pode usar curingas para atualizar vários pacotes de uma vez:

```sh
php composer.phar update "vendor/*"
```

Se você quiser fazer o downgrade de um pacote para uma versão específica sem
alterar o seu `composer.json`, você pode usar `--with` e fornecer uma restrição
de versão personalizada:

```sh
php composer.phar update --with vendor/pacote:2.0.1
```

A restrição personalizada deve ser um subconjunto da restrição existente que
você tem, e esse recurso está disponível apenas para as dependências do pacote
raiz.

Se você deseja atualizar apenas os pacotes para os quais fornece restrições
personalizadas usando `--with`, você pode ignorar `--with` e usar apenas as
restrições com a sintaxe de atualização parcial:

```sh
php composer.phar update vendor/pacote:2.0.1 vendor/pacote2:3.0.*
```

### Opções {: #opcoes-update }

* **--prefer-source:** instala os pacotes de `source`, quando disponíveis.
* **--prefer-dist:** instala os pacotes de `dist`, quando disponíveis.
* **--dry-run:** simula o comando sem realmente fazer nada.
* **--dev:** instala os pacotes listados em `require-dev` (este é o
  comportamento padrão).
* **--no-dev:** ignora a instalação dos pacotes listados em `require-dev`. A
  geração do autoloader ignora as regras em `autoload-dev`.
* **--no-install:** não executa a etapa de instalação após atualizar o arquivo
  `composer.lock`.
* **--lock:** atualiza apenas o hash do arquivo lock para suprimir o alerta
  sobre o arquivo lock estar desatualizado.
* **--with:** restrição de versão temporária para adicionar, por exemplo,
  `foo/bar:1.0.0` ou `foo/bar=1.0.0`.
* **--no-autoloader:** ignora a geração do autoloader.
* **--no-scripts:** ignora a execução dos scripts definidos no `composer.json`.
* **--no-progress:** remove a exibição de progresso que pode interferir em
  alguns terminais ou scripts que não tratam caracteres de backspace.
* **--with-dependencies (-w):** também atualiza as dependências dos pacotes da
  lista de argumentos, exceto aquelas que são requisitos raiz.
* **--with-all-dependencies (-W):** também atualiza as dependências dos pacotes
  da lista de argumentos, incluindo aquelas que são requisitos raiz.
* **--optimize-autoloader (-o):** converte o autoloading PSR-0/4 num mapa de
  classes para obter um autoloader mais rápido. Isso é recomendado especialmente
  em produção, mas pode demorar um pouco para ser executado, portanto,
  atualmente não é feito por padrão.
* **--classmap-authoritative (-a):** faz o autoload apenas das classes do mapa
  de classes. Habilita implicitamente `--optimize-autoloader`.
* **--apcu-autoloader:** usa a APCu para armazenar em cache as classes
  encontradas/não encontradas.
* **--apcu-autoloader-prefix:** usa um prefixo personalizado para o cache do
  autoloader da APCu. Habilita implicitamente `--apcu-autoloader`.
* **--ignore-platform-reqs:** ignora todos os requisitos de plataforma (`php`,
  `hhvm`, `lib-*` e `ext-*`) e força a instalação, mesmo que a máquina local não
  atenda a eles. Veja também a opção de configuração [`platform`]
[book-platform].
* **--ignore-platform-req:** ignora um requisito de plataforma específico
  (`php`, `hhvm`, `lib-*` e `ext-*`) e força a instalação, mesmo que a máquina
  local não atenda a ele.
* **--prefer-stable:** prefere versões estáveis das dependências.
* **--prefer-lowest:** prefere as versões mais antigas das dependências. Útil
  para testar versões mínimas de requisitos, geralmente usada com
  `--prefer-stable`.
* **--interactive:** interface interativa com preenchimento automático para
  selecionar os pacotes a serem atualizados.
* **--root-reqs:** restringe a atualização às dependências de primeiro grau.

Especificar uma das palavras `mirrors`, `lock` ou `nothing` como um argumento
tem o mesmo efeito que especificar a opção `--lock`, por exemplo,
`composer update mirrors` é o mesmo que `composer update --lock`.

## require

O comando `require` adiciona novos pacotes ao arquivo `composer.json` presente
no diretório atual. Se nenhum arquivo existir, um arquivo será criado durante a
execução do comando.

```sh
php composer.phar require
```

Após adicionar/alterar os requisitos, os requisitos modificados serão instalados
ou atualizados.

Se você não quiser escolher os requisitos interativamente, pode passá-los para
o comando:

```sh
php composer.phar require vendor/pacote:2.* vendor/pacote2:dev-master
```

Se você não especificar um pacote, o Composer solicitará que você procure um
pacote e, caso haja resultados, que forneça uma lista de correspondências a
serem requeridas.

### Opções {: #opcoes-require }

* **--dev:** adiciona pacotes a `require-dev`.
* **--dry-run:** simula o comando sem realmente fazer nada.
* **--prefer-source:** instala os pacotes de `source`, quando disponíveis.
* **--prefer-dist:** instala os pacotes de `dist`, quando disponíveis.
* **--no-progress:** remove a exibição de progresso que pode interferir em
  alguns terminais ou scripts que não tratam caracteres de backspace.
* **--no-update:** desabilita a atualização automática das dependências (implica
  `--no-install`).
* **--no-install:** não executa a etapa de instalação após atualizar o arquivo
  `composer.lock`.
* **--no-scripts:** ignora a execução dos scripts definidos no `composer.json`.
* **--update-no-dev:** executa a atualização de dependências com a opção
  `--no-dev`.
* **--update-with-dependencies (-w):** também atualiza as dependências dos novos
  pacotes requeridos, exceto aquelas que são requisitos raiz.
* **--update-with-all-dependencies (-W):** também atualiza as dependências dos
  novos pacotes requeridos, incluindo aquelas que são requisitos raiz.
* **--ignore-platform-reqs:** ignora todos os requisitos de plataforma (`php`,
  `hhvm`, `lib-*` e `ext-*`) e força a instalação, mesmo que a máquina local não
  atenda a eles. Veja também a opção de configuração [`platform`]
[book-platform].
* **--ignore-platform-req:** ignora um requisito de plataforma específico
  (`php`, `hhvm`, `lib-*` e `ext-*`) e força a instalação, mesmo que a máquina
  local não atenda a ele.
* **--prefer-stable:** prefere versões estáveis das dependências.
* **--prefer-lowest:** prefere as versões mais antigas das dependências. Útil
  para testar versões mínimas de requisitos, geralmente usada com
  `--prefer-stable`.
* **--sort-packages:** mantém os pacotes ordenados no `composer.json`.
* **--optimize-autoloader (-o):** converte o autoloading PSR-0/4 num mapa de
  classes para obter um autoloader mais rápido. Isso é recomendado especialmente
  em produção, mas pode demorar um pouco para ser executado, portanto,
  atualmente não é feito por padrão.
* **--classmap-authoritative (-a):** faz o autoload apenas das classes do mapa
  de classes. Habilita implicitamente `--optimize-autoloader`.
* **--apcu-autoloader:** usa a APCu para armazenar em cache as classes
  encontradas/não encontradas.
* **--apcu-autoloader-prefix:** usa um prefixo personalizado para o cache do
  autoloader da APCu. Habilita implicitamente `--apcu-autoloader`.

## remove

O comando `remove` remove pacotes do arquivo `composer.json` presente no
diretório atual.

```sh
php composer.phar remove vendor/pacote vendor/pacote2
```

Após remover os requisitos, os requisitos modificados serão desinstalados.

### Opções {: #opcoes-remove }

* **--dev:** remove pacotes de `require-dev`.
* **--dry-run:** simula o comando sem realmente fazer nada.
* **--no-progress:** remove a exibição de progresso que pode interferir em
  alguns terminais ou scripts que não tratam caracteres de backspace.
* **--no-update:** desabilita a atualização automática das dependências (implica
  `--no-install`).
* **--no-install:** não executa a etapa de instalação após atualizar o arquivo
  `composer.lock`.
* **--no-scripts:** ignora a execução dos scripts definidos no `composer.json`.
* **--update-no-dev:** executa a atualização de dependências com a opção
  `--no-dev`.
* **--update-with-dependencies (-w):** também atualiza as dependências dos
  pacotes removidos (descontinuada, agora é o comportamento padrão).
* **--update-with-all-dependencies (-W):** permite que todas as dependências
  herdadas sejam atualizadas, incluindo aquelas que são requisitos raiz.
* **--ignore-platform-reqs:** ignora todos os requisitos de plataforma (`php`,
  `hhvm`, `lib-*` e `ext-*`) e força a instalação, mesmo que a máquina local não
  atenda a eles. Veja também a opção de configuração [`platform`]
[book-platform].
* **--ignore-platform-req:** ignora um requisito de plataforma específico
  (`php`, `hhvm`, `lib-*` e `ext-*`) e força a instalação, mesmo que a máquina
  local não atenda a ele.
* **--optimize-autoloader (-o):** converte o autoloading PSR-0/4 num mapa de
  classes para obter um autoloader mais rápido. Isso é recomendado especialmente
  em produção, mas pode demorar um pouco para ser executado, portanto,
  atualmente não é feito por padrão.
* **--classmap-authoritative (-a):** faz o autoload apenas das classes do mapa
  de classes. Habilita implicitamente `--optimize-autoloader`.
* **--apcu-autoloader:** usa a APCu para armazenar em cache as classes
  encontradas/não encontradas.
* **--apcu-autoloader-prefix:** usa um prefixo personalizado para o cache do
  autoloader da APCu. Habilita implicitamente `--apcu-autoloader`.

## check-platform-reqs

O comando `check-platform-reqs` verifica se as suas versões do PHP e das
extensões correspondem aos requisitos de plataforma dos pacotes instalados. Isso
pode ser usado para verificar se um servidor de produção possui todas as
extensões necessárias para executar um projeto após a instalação, por exemplo.

Diferente de `update`/`install`, este comando ignorará as configurações em
`config.platform` e verificará os pacotes reais da plataforma para garantir que
você tenha as dependências de plataforma necessárias.

## global

O comando `global` permite executar outros comandos, como `install`, `remove`,
`require` ou `update`, como se você os estivesse executando a partir do
diretório [COMPOSER_HOME][book-composer-home].

Este é apenas um auxiliar para gerenciar um projeto armazenado num local central
que pode conter ferramentas CLI ou plugins do Composer que você deseja ter
disponíveis em qualquer lugar.

Ele pode ser usado para instalar utilitários CLI globalmente. Aqui está um
exemplo:

```sh
php composer.phar global require friendsofphp/php-cs-fixer
```

Agora, o binário `php-cs-fixer` está disponível globalmente. Certifique-se de
que o diretório global dos [binários dos vendors][article-binaries] esteja na
sua variável de ambiente `PATH`. Você pode obter a sua localização com o
seguinte comando:

```sh
php composer.phar global config bin-dir --absolute
```

Se você desejar atualizar o binário mais tarde, pode executar uma atualização
global:

```sh
php composer.phar global update
```

## search

O comando `search` permite pesquisar nos repositórios de pacotes do projeto
atual. Geralmente, será o Packagist. Você simplesmente passa os termos que
deseja pesquisar.

```sh
php composer.phar search monolog
```

Você também pode pesquisar mais de um termo passando vários argumentos.

### Opções {: #opcoes-search }

* **--only-name (-N):** pesquisa apenas pelo nome.
* **--type (-t):** pesquisa por um tipo de pacote específico.

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

Se você quiser ver os detalhes de um determinado pacote, pode passar o nome do
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

Você pode até mesmo passar a versão do pacote, o que informará os detalhes
daquela versão específica.

```sh
php composer.phar show monolog/monolog 1.0.2
```

### Opções {: #opcoes-show }

* **--all:** lista todos os pacotes disponíveis em todos os seus repositórios.
* **--installed (-i):** lista os pacotes que estão instalados (esta opção está
  habilitada por padrão e se tornou obsoleta).
* **--locked:** lista os pacotes fixados do `composer.lock`.
* **--platform (-p):** lista apenas pacotes de plataforma (PHP e extensões).
* **--available (-a):** lista apenas os pacotes disponíveis.
* **--self (-s):** lista as informações do pacote raiz.
* **--name-only (-N):** lista apenas os nomes dos pacotes.
* **--path (-P):** lista os caminhos dos pacotes.
* **--tree (-t):** lista as dependências como uma árvore. Se você passar um nome
  de pacote, essa opção exibirá a árvore de dependências desse pacote.
* **--latest (-l):** lista todos os pacotes instalados, incluindo a sua versão
  mais recente.
* **--outdated (-o):** implica `--latest`, mas lista *apenas* os pacotes que têm
  uma versão mais recente disponível.
* **--no-dev:** filtra as dependências de desenvolvimento da lista de pacotes.
* **--minor-only (-m):** use com `--latest`. Exibe apenas os pacotes que possuem
  atualizações menores compatíveis com o SemVer.
* **--direct (-D):** restringe a lista de pacotes às suas dependências diretas.
* **--strict:** retorna um código de saída diferente de zero quando há pacotes
  desatualizados.
* **--format (-f):** permite escolher entre o formato de saída de texto (padrão)
  ou json.

## outdated

O comando `outdated` exibe uma lista de pacotes instalados que têm atualizações
disponíveis, incluindo as suas versões atuais e mais recentes. Ele é basicamente
um apelido para `composer show -lo`.

O código de cores é o seguinte:

- **verde (=)**: A dependência está na versão mais recente e atualizada.
- **amarelo (~)**: A dependência possui uma nova versão disponível, que inclui
  quebra de compatibilidade com versões anteriores de acordo com o SemVer, então
  atualize quando puder, mas isso pode envolver algum trabalho.
- **vermelho (!)**: A dependência possui uma nova versão que é compatível com o
  SemVer e você deveria atualizá-la.

### Opções {: #opcoes-outdated }

* **--all (-a):** exibe todos os pacotes, não apenas os desatualizados (apelido
  para `composer show -l`).
* **--direct (-D):** restringe a lista de pacotes às suas dependências diretas.
* **--strict:** retorna um código de saída diferente de zero quando há pacotes
  desatualizados.
* **--minor-only (-m):** exibe apenas os pacotes que possuem atualizações
  menores compatíveis com o SemVer.
* **--format (-f):** permite escolher entre o formato de saída de texto (padrão)
  ou json.
* **--no-dev:** não exibe dependências de desenvolvimento desatualizadas.
* **--locked:** exibe as atualizações dos pacotes do arquivo lock,
  independentemente do que está atualmente no diretório `vendor`.

## browse / home

O comando `browse` (ou o apelido `home`) abre o URL do repositório ou a página
do pacote no navegador.

### Opções {: #opcoes-browse }

* **--homepage (-H):** abre a página do pacote em vez do URL do repositório.
* **--show (-s):** apenas exibe a página ou o URL do repositório.

## suggests

Lista todos os pacotes sugeridos pelo conjunto de pacotes atualmente instalado.
Você pode, opcionalmente, passar um ou vários nomes de pacotes no formato
`vendor/pacote` para limitar a saída apenas às sugestões feitas por esses
pacotes.

Use as flags `--by-package` (padrão) ou `--by-suggestion` para agrupar a saída
pelo pacote que oferece as sugestões ou pelos pacotes sugeridos,
respectivamente.

Se você quiser apenas uma lista de nomes de pacotes sugeridos, use `--list`.

### Opções {: #opcoes-suggests }

* **--by-package:** agrupa a saída por pacote que oferece a sugestão (padrão).
* **--by-suggestion:** agrupa a saída por pacote sugerido.
* **--all:** exibe sugestões de todas as dependências, incluindo as transitivas
  (por padrão, apenas as sugestões das dependências diretas são exibidas).
* **--list:** exibe apenas a lista dos nomes dos pacotes sugeridos.
* **--no-dev:** exclui as sugestões dos pacotes de `require-dev`.

## fund

Descobre como ajudar a financiar a manutenção das suas dependências. Este
comando lista todos os links de financiamento das dependências instaladas.

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

* **--recursive (-r):** resolve recursivamente até o pacote raiz.
* **--tree (-t):** exibe os resultados como uma árvore aninhada, implica `-r`.

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

* **--recursive (-r):** resolve recursivamente até o pacote raiz.
* **--tree (-t):** exibe os resultados como uma árvore aninhada, implica `-r`.

## validate

Você sempre deve executar o comando `validate` antes de fazer o commit do
arquivo `composer.json`, e antes de criar a tag de uma versão. Ele verificará se
o seu `composer.json` é válido.

```sh
php composer.phar validate
```

### Opções {: #opcoes-validate }

* **--no-check-all:** não emite um alerta se os requisitos do `composer.json`
  usarem restrições de versão não associadas ou excessivamente rígidas.
* **--no-check-lock:** não emite um erro se o `composer.lock` existir e não
  estiver atualizado.
* **--no-check-publish:** não emite um erro se o `composer.json` não for
  adequado para publicação como um pacote no Packagist, mas for válido.
* **--with-dependencies:** também valida o `composer.json` de todas as
  dependências instaladas.
* **--strict:** retorna um código de saída diferente de zero para os alertas e
  erros.

## status

Se você precisar modificar frequentemente o código das suas dependências, e elas
são instaladas a partir do código-fonte, o comando `status` permitirá verificar
se há alterações locais em alguma delas.

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

## self-update (selfupdate) {: #self-update }

Para atualizar o próprio Composer para a versão mais recente, execute o comando
`self-update`. Ele substituirá o seu `composer.phar` pela versão mais recente.

```sh
php composer.phar self-update
```

Se você preferir atualizar para uma versão específica, basta especificá-la:

```sh
php composer.phar self-update 1.0.0-alpha7
```

Se você instalou o Composer para todo o sistema (consulte a [instalação global]
[book-globally]), pode ser necessário executar o comando com privilégios de
administrador.

```sh
sudo -H composer self-update
```

Se o Composer não foi instalado como um PHAR, este comando não estará
disponível. (Às vezes é o que acontece quando o Composer foi instalado por um
gerenciador de pacotes do sistema operacional.)

### Opções {: #opcoes-self-update }

* **--rollback (-r):** reverte para a última versão que você instalou.
* **--clean-backups:** exclui os backups antigos durante uma atualização. Isso
  torna a versão atual do Composer o único backup disponível após a atualização.
* **--no-progress:** não exibe o progresso do download.
* **--update-keys:** solicita uma atualização de chave.
* **--stable:** força uma atualização para o canal estável.
* **--preview:** força uma atualização para o canal preview.
* **--snapshot:** força uma atualização para o canal snapshot.
* **--1:** força uma atualização para o canal estável, mas usa apenas as versões
  1.x.
* **--2:** força uma atualização para o canal estável, mas usa apenas as versões
  2.x.
* **--set-channel-only:** apenas armazena o canal como o padrão.

## config

O comando `config` permite editar as configurações e repositórios do Composer
tanto no arquivo local `composer.json` quanto no arquivo global `config.json`.

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

Veja o capítulo [Config][book-config] para conhecer as opções de configuração válidas.

### Opções {: #opcoes-config }

* **--global (-g):** opera no arquivo de configuração global localizado em
  `$COMPOSER_HOME/config.json` por padrão. Sem esta opção, este comando afeta o
  arquivo `composer.json` local ou um arquivo especificado por `--file`.
* **--editor (-e):** abre o arquivo `composer.json` local usando um editor de
  texto conforme definido pela variável de ambiente `EDITOR`. Com a opção
  `--global`, abre o arquivo de configuração global.
* **--auth (-a):** afeta o arquivo de configuração de autenticação (usada apenas
  para `--editor`).
* **--unset:** remove o elemento de configuração nomeado por
  `nome-configuracao`.
* **--list (-l):** exibe a lista das variáveis de configuração atuais. Com a
  opção `--global`, lista apenas as configurações globais.
* **--file="..." (-f):** opera num arquivo específico em vez do `composer.json`.
  Observe que isso não pode ser usado em conjunto com a opção `--global`.
* **--absolute:** retorna caminhos absolutos em vez de caminhos relativos ao
  buscar valores de configuração `*-dir`.

### Modificando Repositórios

Além de modificar a seção `config`, o comando `config` também suporta
alterações na seção `repositories`, usando-o da seguinte maneira:

```sh
php composer.phar config repositories.foo vcs https://github.com/foo/bar
```

Se o seu repositório exigir mais opções de configuração, você poderá passar a
sua representação JSON:

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

Se você tiver um valor complexo para adicionar/modificar, poderá usar as flags
`--json` e `--merge` para editar os campos extras como JSON:

```sh
php composer.phar config --json extra.foo.bar '{"baz": true, "qux": []}'
```

## create-project

Você pode usar o Composer para criar projetos a partir de um pacote existente.
Isso é o equivalente a executar um `git clone` ou um `svn checkout` seguido por
um `composer install` dos vendors.

Existem várias aplicações para isso:

1. Você pode implantar pacotes de aplicações.
1. Você pode baixar qualquer pacote e começar a desenvolver patches, por
   exemplo.
1. Projetos com vários desenvolvedores podem usar esse recurso para inicializar
   a aplicação inicial para desenvolvimento.

Para criar um projeto usando o Composer, você pode usar o comando
`create-project`. Passe o nome de um pacote e o diretório no qual criará o
projeto. Você também pode fornecer uma versão como terceiro argumento, caso
contrário, a versão mais recente será usada.

Se o diretório não existir, será criado durante a instalação.

```sh
php composer.phar create-project doctrine/orm caminho 2.2.*
```

Também é possível executar o comando sem parâmetros num diretório com um arquivo
`composer.json` existente para inicializar um projeto.

Por padrão, o comando procura por pacotes no [Packagist][page-packagist].

### Opções {: #opcoes-create-project }

* **--stability (-s):** estabilidade mínima do pacote. O padrão é `stable`.
* **--prefer-source:** instala os pacotes de `source`, quando disponíveis.
* **--prefer-dist:** instala os pacotes de `dist`, quando disponíveis.
* **--repository:** fornece um repositório personalizado para pesquisar o
  pacote, que será usado no lugar do Packagist. Pode ser um URL HTTP apontando
  para um repositório do `composer`, um caminho para um arquivo `packages.json`
  local ou uma string JSON semelhante à string aceita pela chave
  [repositories][book-repositories]. Você pode usar esta opção várias vezes para
  configurar vários repositórios.
* **--add-repository:** Adiciona um repositório personalizado ao
  `composer.json`. Se um arquivo lock estiver presente, ele será excluído e uma
  atualização será executada, ao invés de uma instalação.
* **--dev:** instala os pacotes listados em `require-dev`.
* **--no-dev:** ignora a instalação dos pacotes listados em `require-dev`.
* **--no-scripts:** ignora a execução dos scripts definidos no pacote raiz.
* **--no-progress:** remove a exibição de progresso que pode interferir em
  alguns terminais ou scripts que não tratam caracteres de backspace.
* **--no-secure-http:** desabilita a opção de configuração `secure-http`
  temporariamente ao instalar o pacote raiz. Use por sua conta e risco. Usar
  essa flag é uma má ideia.
* **--keep-vcs:** ignora a exclusão dos metadados do VCS para o projeto criado.
  Isto é útil principalmente se você executar o comando em modo não interativo.
* **--remove-vcs:** força a remoção dos metadados do VCS sem pedir confirmação.
* **--no-install:** desabilita a instalação dos vendors.
* **--ignore-platform-reqs:** ignora todos os requisitos de plataforma (`php`,
  `hhvm`, `lib-*` e `ext-*`) e força a instalação, mesmo que a máquina local não
  atenda a eles. Veja também a opção de configuração [`platform`]
[book-platform].
* **--ignore-platform-req:** ignora um requisito de plataforma específico
  (`php`, `hhvm`, `lib-*` e `ext-*`) e força a instalação, mesmo que a máquina
  local não atenda a ele.
* **--ask:** Solicita o diretório de destino para o novo projeto.

## dump-autoload (dumpautoload) {: #dump-autoload }

Se você precisar atualizar o autoloader devido a novas classes num pacote de
mapa de classes, por exemplo, poderá usar `dump-autoload` para fazer isso sem
ter que passar por uma instalação ou atualização.

Além disso, ele pode fazer o dump de um autoloader otimizado que converte
pacotes PSR-0/4 em pacotes de mapa de classes por motivos de desempenho. Em
aplicações grandes com muitas classes, o autoloader pode ocupar uma porção
substancial do tempo de cada requisição. O uso de mapas de classes para tudo é
menos conveniente durante o desenvolvimento, mas, usando esta opção, você ainda
pode usar PSR-0/4 por conveniência e mapas de classes por desempenho.

### Opções {: #opcoes-dump-autoload }

* **--no-scripts:** ignora a execução dos scripts definidos no `composer.json`.
* **--optimize (-o):** converte o autoloading PSR-0/4 num mapa de classes para
  obter um autoloader mais rápido. Isso é recomendado especialmente em produção,
  mas pode demorar um pouco para ser executado, portanto, atualmente não é feito
  por padrão.
* **--classmap-authoritative (-a):** faz o autoload apenas das classes do mapa
  de classes. Implicitamente habilita `--optimize`.
* **--apcu:** usa a APCu para armazenar em cache as classes encontradas/não
  encontradas.
* **--apcu-prefix:** usa um prefixo personalizado para o cache do autoloader da
  APCu. Habilita implicitamente `--apcu`.
* **--no-dev:** desabilita as regras em `autoload-dev`.
* **--ignore-platform-reqs:** ignora todos os requisitos de plataforma (`php`,
  `hhvm`, `lib-*` e `ext-*`) e pula a [verificação de plataforma]
[book-platform-check] para eles. Veja também a opção de configuração
  [`platform`][book-platform].
* **--ignore-platform-req:** ignora um requisito de plataforma específico
  (`php`, `hhvm`, `lib-*` e `ext-*`) e pula a [verificação de plataforma]
[book-platform-check] para ele.

## clear-cache / clearcache / cc

Exclui todo o conteúdo dos diretórios de cache do Composer.

## licenses

Lista o nome, a versão e a licença de cada pacote instalado. Use `--format=json`
para obter uma saída legível para máquinas.

### Opções {: #opcoes-licenses }

* **--format:** formato da saída: `text`, `json` ou `summary` (padrão: `text`).
* **--no-dev:** remove as dependências de desenvolvimento da saída.

## run-script

### Opções {: #opcoes-run-script }

* **--timeout:** define o tempo limite do script em segundos ou 0 para
  desabilitar o tempo limite.
* **--dev:** habilita o modo de desenvolvimento.
* **--no-dev:** desabilita o modo de desenvolvimento.
* **--list (-l):** lista os scripts definidos pelo usuário.

Para executar [scripts][article-scripts] manualmente, você pode usar este
comando, passando o nome do script e, opcionalmente, quaisquer argumentos
necessários.

## exec

Executa um binário ou script de um vendor. Você pode executar qualquer comando e
`exec` garantirá que o diretório `bin-dir` do Composer seja adicionado à
variável `PATH` antes da execução do comando.

### Opções {: #opcoes-exec }

* **--list (-l):** lista os binários disponíveis no Composer.

## diagnose

Se você achar que encontrou um erro, ou se algo está se comportando de forma
estranha, convém executar o comando `diagnose` para realizar verificações
automatizadas de muitos problemas comuns.

```sh
php composer.phar diagnose
```

## archive

Este comando é usado para gerar um arquivo compactado `zip`/`tar` para um
determinado pacote numa determinada versão. Também pode ser usado para arquivar
o seu projeto inteiro sem os arquivos excluídos/ignorados.

```sh
php composer.phar archive vendor/pacote 2.0.21 --format=zip
```

### Opções {: #opcoes-archive }

* **--format (-f):** formato do arquivo compactado resultante: `tar` ou `zip`
  (padrão: `tar`).
* **--dir:** salva o arquivo compactado neste diretório (padrão: `.`).
* **--file:** salva o arquivo compactado com o nome especificado.

## help

Para obter mais informações sobre um determinado comando, você pode usar `help`.

```sh
php composer.phar help install
```

## Preenchimento Automático na Linha de Comando

O preenchimento automático na linha de comando pode ser habilitado seguindo as
instruções [nesta página][page-autocomplete].

## Variáveis de Ambiente

Você pode definir algumas variáveis de ambiente que substituem determinadas
configurações. Sempre que possível, é recomendável especificar essas
configurações na seção `config` do `composer.json`. É importante ressaltar que
as variáveis de ambiente sempre terão precedência sobre os valores especificados
no `composer.json`.

### COMPOSER

Ao definir a variável de ambiente `COMPOSER`, é possível definir o nome do
arquivo `composer.json` como algum outro.

Por exemplo:

```sh
COMPOSER=outro-composer.json php composer.phar install
```

O arquivo lock gerado usará o mesmo nome: `outro-composer.lock` neste exemplo.

### COMPOSER_ALLOW_SUPERUSER {: #composer-allow-superuser }

Se definida como `1`, esta variável de ambiente desabilita o alerta sobre a
execução de comandos como root/superusuário. Ela também desabilita a limpeza
automática de sessões sudo; portanto, você realmente deve defini-la apenas se
usar o Composer como superusuário o tempo todo, como em containers do Docker.

### COMPOSER_ALLOW_XDEBUG {: #composer-allow-xdebug }

Se definida como `1`, esta variável de ambiente permite executar o Composer
quando a extensão Xdebug estiver habilitada, sem reiniciar o PHP sem a extensão.

### COMPOSER_AUTH {: #composer-auth }

A variável `COMPOSER_AUTH` permite configurar a autenticação como uma variável
de ambiente. O conteúdo da variável deve ser um objeto JSON contendo objetos
`http-basic`, `github-oauth`, `bitbucket-oauth`, ..., conforme necessário e
seguindo as [especificações da configuração][book-gitlab].

### COMPOSER_BIN_DIR {: #composer-bin-dir }

Ao definir esta opção, você pode alterar o diretório `bin` ([Binários dos
Vendors][article-binaries]) para algo diferente de `vendor/bin`.

### COMPOSER_CACHE_DIR {: #composer-cache-dir }

A variável `COMPOSER_CACHE_DIR` permite alterar o diretório de cache do
Composer, que também é configurável através da opção [`cache-dir`][book-cache].

Por padrão, ela aponta para `$COMPOSER_HOME/cache` no \*nix e macOS, e
`C:\Users\<user>\AppData\Local\Composer` (ou `%LOCALAPPDATA%\Composer`) no
Windows.

### COMPOSER_CAFILE {: #composer-cafile }

Ao definir esta variável de ambiente, é possível definir um caminho para um
arquivo de pacote de certificados que será usado durante a verificação por par
SSL/TLS.

### COMPOSER_DEBUG_EVENTS {: #composer-debug-events }

Se definida como `1`, exibe informações sobre os eventos que estão sendo
disparados, o que pode ser útil para os autores de plugin identificarem o que
está disparando e quando exatamente.

### COMPOSER_DISABLE_NETWORK {: #composer-disable-network }

Se definida como `1`, desabilita o acesso à rede (melhor esforço). Esta variável
pode ser usada para depurar ou executar o Composer num avião ou nave espacial
com conectividade ruim.

Se definida como `prime`, os repositórios VCS do GitHub irão preparar o cache
para que ele possa ser usado totalmente offline com `1`.

### COMPOSER_DISABLE_XDEBUG_WARN {: #composer-disable-xdebug-warn }

Se definida como `1`, esta variável suprime o alerta de quando o Composer está
sendo executado com a extensão Xdebug habilitada.

### COMPOSER_DISCARD_CHANGES {: #composer-discard-changes }

Esta variável controla a opção de configuração [`discard-changes`]
[book-discard-changes].

### COMPOSER_HOME {: #composer-home }

A variável `COMPOSER_HOME` permite alterar o diretório inicial do Composer. Este
é um diretório global oculto (por usuário na máquina) compartilhado entre todos
os projetos.

Use `composer config --global home` para ver a localização do diretório home.

Por padrão, ela aponta para `C:\Users\<usuario>\AppData\Roaming\Composer` no
Windows, e `/Users/<usuario>/.composer` no macOS. Em sistemas \*nix que seguem
as [Especificações de Diretório Base do XDG][page-basedir], ela aponta para
`$XDG_CONFIG_HOME/composer`. Em outros sistemas \*nix, ela aponta para
`/home/<usuario>/.composer`.

#### COMPOSER_HOME/config.json {: #composer-home-config-json }

Você pode colocar um arquivo `config.json` no diretório para o qual
`COMPOSER_HOME` aponta. O Composer combinará esta configuração com o
`composer.json` do seu projeto quando você executar os comandos `install` e
`update`.

Este arquivo permite definir [repositórios][book-repos] e [configurações]
[book-config] para os seus projetos.

Caso a configuração global corresponda à configuração _local_, a configuração
_local_ no `composer.json` do projeto sempre vence.

### COMPOSER_HTACCESS_PROTECT {: #composer-htaccess-protect }

O padrão é `1`. Se definida como `0`, o Composer não criará arquivos `.htaccess`
nos diretórios home, cache e data do Composer.

### COMPOSER_MAX_PARALLEL_HTTP {: #composer-max-parallel-http }

Defina como um inteiro para configurar quantos arquivos podem ser baixados em
paralelo. O padrão é 12 e deve estar entre 1 e 50. Se o seu proxy tiver
problemas com concorrência, talvez você queira diminuir este valor. Aumentá-lo
geralmente não resulta em ganhos de desempenho.

### COMPOSER_MEMORY_LIMIT {: #composer-memory-limit }

Se definida, o valor é usado como `memory_limit` do PHP.

### COMPOSER_MIRROR_PATH_REPOS {: #composer-mirror-path-repos }

Se definida como `1`, esta variável de ambiente altera a estratégia padrão do
repositório de caminhos para `mirror`, em vez de `symlink`. Por ser a estratégia
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

### COMPOSER_SELF_UPDATE_TARGET {: #composer-self-update-target }

Se definida, faz com que o comando `self-update` salve o novo arquivo PHAR do
Composer neste caminho em vez de sobrescrever-se. Útil para atualizar o Composer
em sistemas de arquivos somente leitura.

### COMPOSER_VENDOR_DIR {: #composer-vendor-dir }

Ao definir esta variável, você pode fazer o Composer instalar as dependências
num diretório diferente de `vendor`.

### http_proxy ou HTTP_PROXY {: #http-proxy }

Se você estiver usando o Composer por trás de um proxy HTTP, poderá usar a
variável de ambiente padrão `http_proxy` ou `HTTP_PROXY`. Basta configurá-la
como o URL do seu proxy. Muitos sistemas operacionais já definem esta variável
para você.

Usar `http_proxy` (em minúsculas) ou mesmo definir as duas pode ser preferível,
pois algumas ferramentas como git ou curl usarão apenas a versão `http_proxy`
em minúsculas. Como alternativa, você também pode definir o proxy do git usando
`git config --global http.proxy <url-do-proxy>`.

Se você estiver usando o Composer num contexto que não seja a CLI (ou seja,
integração em um CMS ou algum caso de uso semelhante) e precisar oferecer
suporte a proxies, forneça a variável de ambiente `CGI_HTTP_PROXY`. Consulte
[httpoxy.org][page-httpoxy] para mais detalhes.

### HTTP_PROXY_REQUEST_FULLURI {: #http-proxy-request-fulluri }

Se você usa um proxy, mas ele não suporta a flag `request_fulluri`, então você
deve definir esta variável de ambiente como `false` ou `0` para evitar que o
Composer defina a opção `request_fulluri`.

### HTTPS_PROXY_REQUEST_FULLURI {: #https-proxy-request-fulluri }

Se você usa um proxy, mas ele não suporta a flag `request_fulluri` para
requisições HTTPS, então você deve definir esta variável de ambiente como
`false` ou `0` para evitar que o Composer defina a opção `request_fulluri`.

### no_proxy ou NO_PROXY {: #no-proxy }

Se você estiver atrás de um proxy e deseja desabilitá-lo para determinados
domínios, pode usar a variável de ambiente `no_proxy` ou `NO_PROXY`. Defina-a
como uma lista de domínios separados por vírgula para os quais o proxy **não**
deve ser usado.

A variável de ambiente aceita domínios, endereços de IP e blocos de endereços de
IP na notação CIDR. Você pode restringir o filtro a uma porta específica (por
exemplo, `:80`). Você também pode configurá-la como `*` para ignorar o proxy
para todas as requisições HTTP.

[article-binaries]: artigos/vendor-binaries.md
[article-scripts]: artigos/scripts.md
[book-cache]: config.md#cache-dir
[book-composer-home]: #composer-home
[book-config]: config.md
[book-discard-changes]: config.md#discard-changes
[book-gitlab]: config.md#gitlab-oauth
[book-globally]: introducao.md#globalmente
[book-libs]: bibliotecas.md
[book-platform]: config.md#platform
[book-platform-check]: runtime.md#platform-check
[book-repos]: repositorios.md
[book-repositories]: esquema.md#repositories
[page-autocomplete]: https://github.com/bamarni/symfony-console-autocomplete
[page-basedir]: https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
[page-console]: https://github.com/symfony/console
[page-httpoxy]: https://httpoxy.org
[page-packagist]: https://packagist.org/
