# Uso Básico

## Introdução

Para nossa introdução ao uso básico, instalaremos o `monolog/monolog`, uma
biblioteca de registro de log. Se você ainda não instalou o Composer, consulte o
capítulo [Introdução][intro].

> **Nota:** por uma questão de simplicidade, essa introdução assumirá que você
> executou uma instalação [local][intro-localmente] do Composer.

## `composer.json`: Configuração do Projeto

Para começar a usar o Composer em seu projeto, tudo o que você precisa é de um
arquivo `composer.json`. Esse arquivo descreve as dependências do seu projeto e
também pode conter outros metadados.

### A Chave `require`

A primeira (e muitas vezes a única) coisa especificada no `composer.json` é a
chave [`require`][schema-require]. Você está simplesmente dizendo ao Composer de
quais pacotes seu projeto depende.

```json
{
    "require": {
        "monolog/monolog": "1.0.*"
    }
}
```

Como você pode ver, [`require`][schema-require] recebe um objeto que mapeia
**nomes de pacotes** (por exemplo, `monolog/monolog`) para
**restrições de versão** (por exemplo, `1.0.*`).

O Composer usa essas informações para procurar o conjunto correto de arquivos
nos "repositórios" de pacotes que você registra usando a chave
[`repositories`][schema-repositories] ou no Packagist, o repositório de
pacotes padrão. No exemplo acima, como nenhum outro repositório foi registrado
no arquivo `composer.json`, supõe-se que o pacote `monolog/monolog` esteja
registrado no Packagist. (Veja mais sobre o Packagist [abaixo][packagist] ou
leia mais sobre repositórios [aqui][repositories]).

### Nomes de Pacotes

O nome do pacote consiste em um nome de fornecedor e o nome do projeto.
Geralmente, eles serão idênticos - o nome do fornecedor existe apenas para
prevenir conflitos de nomes. Por exemplo, isso permite que duas pessoas
diferentes criem uma biblioteca chamada `json`. Uma pode ser chamada
`igorw/json` enquanto a outra pode ser `seldaek/json`.

Leia mais sobre a publicação e a nomeação de pacotes [aqui][libraries]. (Note
que você também pode especificar "pacotes de plataforma" como dependências,
permitindo que você exija determinadas versões do software do servidor. Consulte
os [pacotes de plataforma][platform-packages] abaixo.)

### Restrições de Versão de Pacote

Em nosso exemplo, estamos solicitando o pacote Monolog com a restrição de versão
[`1.0.*`][semver-monolog]. Isso significa qualquer versão no branch de
desenvolvimento `1.0` ou qualquer versão maior ou igual a 1.0 e menor que
1.1 (`>=1.0 <1.1`).

Leia o [artigo sobre versões][article-versions] para obter informações mais
detalhadas sobre versões, como as versões se relacionam entre si e sobre as
restrições de versão.

> **Como o Composer baixa os arquivos corretos?** Quando você especifica uma
> dependência no `composer.json`, o Composer primeiro pega o nome do pacote
> solicitado e o procura em qualquer repositório registrado usando a chave
> [`repositories`][schema-repositories]. Se você não registrou nenhum
> repositório extra ou se ele não encontra um pacote com esse nome nos
> repositórios que você especificou, ele volta ao Packagist (mais [abaixo][packagist]).
>
> Quando o Composer encontra o pacote certo, no Packagist ou em um repositório
> que você especificou, ele usa os recursos de versão do VCS do pacote (ou seja,
> branches e tags) para tentar encontrar a melhor correspondência para a
> restrição de versão que você especificou. Leia sobre versões e resolução de
> pacotes no [artigo sobre versões][article-versions].

> **Nota:** Se você está tentando requisitar um pacote mas o Composer gera um
> erro referente à estabilidade do pacote, a versão que você especificou pode
> não atender aos seus requisitos mínimos de estabilidade padrão. Por padrão,
> apenas versões estáveis são levadas em consideração ao procurar versões de
> pacotes válidas no seu VCS.
>
> Você pode se deparar com isso se estiver tentando requisitar as versões dev,
> alpha, beta ou RC de um pacote. Leia mais sobre flags de estabilidade e a
> chave `minimum-stability` na [página do esquema][schema].

## Instalando Dependências

Para instalar as dependências definidas para o seu projeto, execute o comando
[`install`][cli-install].

```sh
php composer.phar install
```

Quando você executa esse comando, uma destas duas coisas pode acontecer:

### Instalando sem o `composer.lock`

Se você nunca executou o comando antes e também não há nenhum `composer.lock`
presente, o Composer simplesmente resolve todas as dependências listadas no seu
arquivo `composer.json` e baixa a versão mais recente dos arquivos no diretório
`vendor` do seu projeto. (O diretório `vendor` é o local convencional para
todos os códigos de terceiros em um projeto). Em nosso exemplo acima, você
acabaria com os arquivos-fonte do Monolog em `vendor/monolog/monolog/`. Se o
Monolog listasse quaisquer dependências, elas também estariam em pastas em
`vendor/`.

> **Dica:** Se você estiver usando o git no seu projeto, provavelmente desejará
> adicionar `vendor` ao seu `.gitignore`. Você realmente não deseja adicionar
> todo esse código de terceiros ao seu repositório versionado.

Quando o Composer termina a instalação, ele grava todos os pacotes e as versões
exatas deles que foram baixadas no arquivo `composer.lock`, fixando o projeto
naquelas versões específicas. Você deve fazer o commit do arquivo
`composer.lock` no repositório do projeto, para que todas as pessoas que
trabalham no projeto usem exatamente as mesmas versões das dependências (mais
abaixo).

### Instalando com o `composer.lock`

Isso nos leva ao segundo cenário. Se já existe um arquivo `composer.lock` e um
arquivo `composer.json` quando você executa `composer install`, significa que
você executou o comando `install` antes ou outra pessoa no projeto executou o
comando `install` e fez o commit do arquivo `composer.lock` no projeto (o que é
bom).

De qualquer forma, executar `install` quando um arquivo `composer.lock` estiver
presente resolve e instala todas as dependências listadas no `composer.json`,
mas o Composer usa as versões exatas listadas no `composer.lock` para garantir
que as versões dos pacotes sejam consistentes para todas as pessoas que
trabalham no seu projeto. Como resultado você terá todas as dependências
requisitadas pelo seu arquivo `composer.json`, mas elas podem não estar nas
versões disponíveis mais recentes (algumas das dependências listadas no arquivo
`composer.lock` podem ter lançado versões mais recentes desde que o arquivo foi
criado). Isso é intencional e garante que seu projeto não quebre por causa de
mudanças inesperadas nas dependências.

### Faça o Commit do Seu Arquivo `composer.lock` para o Controle de Versão

Fazer o commit desse arquivo para o controle de versão é importante porque fará
com que qualquer pessoa que configure o projeto use exatamente as mesmas versões
das dependências que você está usando. Seu servidor de integração contínua,
máquinas de produção, outras pessoas no seu time, tudo e todas as pessoas
executam as mesmas dependências, o que reduz o potencial para erros que afetam
apenas algumas partes das implantações. Mesmo se você for a única pessoa
desenvolvendo, ao reinstalar o projeto após seis meses você poderá se sentir
confiante de que as dependências instaladas ainda estão funcionando, mesmo que
suas dependências tenham lançado muitas novas versões desde então. (Veja a nota
abaixo sobre o uso do comando `update`.)

## Atualizando as Dependências para Suas Versões mais Recentes

Como mencionado acima, o arquivo `composer.lock` impede que você obtenha
automaticamente as versões mais recentes de suas dependências. Para atualizar
para as versões mais recentes, use o comando [`update`][cli-update]. Ele buscará
as versões correspondentes mais recentes (de acordo com seu arquivo
`composer.json`) e atualizará o arquivo de bloqueio com as novas versões. (Isso é
equivalente a excluir o arquivo `composer.lock` e executar `install` novamente.)

```sh
php composer.phar update
```

> **Nota:** O Composer exibirá um aviso ao executar um comando `install` se o
> `composer.lock` não tiver sido atualizado depois que foram feitas alterações
> no `composer.json` que podem afetar a resolução de dependências.

Se você deseja instalar ou atualizar apenas uma dependência, você pode listá-la:

```sh
php composer.phar update monolog/monolog [...]
```

> **Nota:** Para bibliotecas, não é necessário fazer o commit do arquivo de
> bloqueio, consulte também: [Bibliotecas - Arquivo de Bloqueio][libraries-lock-file].

## Packagist

[Packagist][packagist-site] é o principal repositório do Composer. Um
repositório do Composer é basicamente uma fonte de pacotes: um local de onde
você pode obter pacotes. O Packagist pretende ser o repositório central que
todas as pessoas usam. Isso significa que você pode exigir automaticamente
qualquer pacote disponível lá usando `require`, sem especificar mais
detalhes sobre onde o Composer deve procurar pelo pacote.

Se você for ao [site do Packagist][packagist-site] (packagist.org), você pode
navegar e procurar por pacotes.

É recomendado que qualquer projeto de código aberto usando o Composer publique
seus pacotes no Packagist. Uma biblioteca não precisa estar no Packagist para
ser usada pelo Composer, mas isso permite a descoberta e adoção por outras
pessoas desenvolvedoras mais rapidamente.

## Pacotes de Plataforma

O Composer possui pacotes de plataforma, que são pacotes virtuais para itens
instalados no sistema, mas que não são realmente instaláveis pelo Composer. Isso
inclui o próprio PHP, extensões PHP e algumas bibliotecas do sistema.

* `php` representa a versão do PHP do usuário, permitindo aplicar restrições,
  por exemplo, `^7.1`. Para exigir uma versão do PHP de 64 bits, você pode
  exigir o pacote `php-64bit`.

* `hhvm` representa a versão do runtime do HHVM e permite aplicar uma restrição,
  por exemplo, `^2.3`.

* `ext-<nome>` permite exigir extensões PHP (incluindo extensões nativas). O
  versionamento pode ser bastante inconsistente aqui, portanto é uma boa idéia
  definir a restrição como `*`. Um exemplo de um nome de pacote de extensão é
  `ext-gd`.

* `lib-<nome>` permite que restrições sejam feitas nas versões das bibliotecas
  usadas pelo PHP. As seguintes estão disponíveis: `curl`, `iconv`, `icu`,
  `libxml`, `openssl`, `pcre`, `uuid`, `xsl`.

Você pode usar [`show --platform`][cli-show] para obter uma lista dos seus
pacotes de plataforma disponíveis localmente.

## Autoloading

For libraries that specify autoload information, Composer generates a
`vendor/autoload.php` file. You can simply include this file and start
using the classes that those libraries provide without any extra work:

```php
require __DIR__ . '/vendor/autoload.php';

$log = new Monolog\Logger('name');
$log->pushHandler(new Monolog\Handler\StreamHandler('app.log', Monolog\Logger::WARNING));
$log->addWarning('Foo');
```

You can even add your own code to the autoloader by adding an
[`autoload`][schema-autoload] field to `composer.json`.

```json
{
    "autoload": {
        "psr-4": {"Acme\\": "src/"}
    }
}
```

Composer will register a [PSR-4][php-fig-psr4] autoloader
for the `Acme` namespace.

You define a mapping from namespaces to directories. The `src` directory would
be in your project root, on the same level as `vendor` directory is. An example
filename would be `src/Foo.php` containing an `Acme\Foo` class.

After adding the [`autoload`][schema-autoload] field, you have to re-run
[`dump-autoload`][cli-dump-autoload] to re-generate the
`vendor/autoload.php` file.

Including that file will also return the autoloader instance, so you can store
the return value of the include call in a variable and add more namespaces.
This can be useful for autoloading classes in a test suite, for example.

```php
$loader = require __DIR__ . '/vendor/autoload.php';
$loader->addPsr4('Acme\\Test\\', __DIR__);
```

In addition to PSR-4 autoloading, Composer also supports PSR-0, classmap and
files autoloading. See the [`autoload`][schema-autoload] reference for
more information.

See also the docs on [optimizing the autoloader][articles-autoloader].

> **Note:** Composer provides its own autoloader. If you don't want to use that
> one, you can include `vendor/composer/autoload_*.php` files, which return
> associative arrays allowing you to configure your own autoloader.

[Libraries][libraries] &rarr;

[articles-autoloader]: articles/autoloader-optimization.md
[article-versions]: articles/versions.md
[cli-dump-autoload]: 03-cli.md#dump-autoload
[cli-install]: 03-cli.md#install
[cli-show]: 03-cli.md#show
[cli-update]: 03-cli.md#update
[intro]: 00-intro.md
[intro-localmente]: 00-intro.md#localmente
[libraries]: 02-libraries.md
[libraries-lock-file]: 02-libraries.md#lock-file
[repositories]: 05-repositories.md
[php-fig-psr4]: http://www.php-fig.org/psr/psr-4/
[platform-packages]: #platform-packages
[schema]: 04-schema.md
[schema-autoload]: 04-schema.md#autoload
[schema-require]: 04-schema.md#require
[schema-repositories]: 04-schema.md#repositories
[semver-monolog]: https://semver.mwl.be/#?package=monolog%2Fmonolog&version=1.0.*
[packagist]: #packagist
[packagist-site]: https://packagist.org/
