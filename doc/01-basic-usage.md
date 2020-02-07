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

Leia mais sobre a publicação de pacotes e a nomeação de pacotes [aqui][libraries].
(Note que você também pode especificar "pacotes de plataforma" como
dependências, permitindo que você exija determinadas versões do software do
servidor. Consulte os [pacotes de plataforma][platform-packages] abaixo.)

### Restrições de Versão de Pacote

Em nosso exemplo, estamos solicitando o pacote Monolog com a restrição de versão
[`1.0.*`][semver-monolog]. Isso significa qualquer versão na branch de
desenvolvimento `1.0`, ou qualquer versão maior ou igual a 1.0 e menor que
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

## Installing dependencies

To install the defined dependencies for your project, run the
[`install`](03-cli.md#install) command.

```sh
php composer.phar install
```

When you run this command, one of two things may happen:

### Installing without `composer.lock`

If you have never run the command before and there is also no `composer.lock` file present,
Composer simply resolves all dependencies listed in your `composer.json` file and downloads
the latest version of their files into the `vendor` directory in your project. (The `vendor`
directory is the conventional location for all third-party code in a project). In our
example from above, you would end up with the Monolog source files in
`vendor/monolog/monolog/`. If Monolog listed any dependencies, those would also be in
folders under `vendor/`.

> **Tip:** If you are using git for your project, you probably want to add
> `vendor` in your `.gitignore`. You really don't want to add all of that
> third-party code to your versioned repository.

When Composer has finished installing, it writes all of the packages and the exact versions
of them that it downloaded to the `composer.lock` file, locking the project to those specific
versions. You should commit the `composer.lock` file to your project repo so that all people
working on the project are locked to the same versions of dependencies (more below).

### Installing with `composer.lock`

This brings us to the second scenario. If there is already a `composer.lock` file as well as a
`composer.json` file when you run `composer install`, it means either you ran the
`install` command before, or someone else on the project ran the `install` command and
committed the `composer.lock` file to the project (which is good).

Either way, running `install` when a `composer.lock` file is present resolves and installs
all dependencies that you listed in `composer.json`, but Composer uses the exact versions listed
in `composer.lock` to ensure that the package versions are consistent for everyone
working on your project. As a result you will have all dependencies requested by your
`composer.json` file, but they may not all be at the very latest available versions
(some of the dependencies listed in the `composer.lock` file may have released newer versions since
the file was created). This is by design, it ensures that your project does not break because of
unexpected changes in dependencies.

### Commit your `composer.lock` file to version control

Committing this file to VC is important because it will cause anyone who sets
up the project to use the exact same
versions of the dependencies that you are using. Your CI server, production
machines, other developers in your team, everything and everyone runs on the
same dependencies, which mitigates the potential for bugs affecting only some
parts of the deployments. Even if you develop alone, in six months when
reinstalling the project you can feel confident the dependencies installed are
still working even if your dependencies released many new versions since then.
(See note below about using the `update` command.)

## Updating dependencies to their latest versions

As mentioned above, the `composer.lock` file prevents you from automatically getting
the latest versions of your dependencies. To update to the latest versions, use the
[`update`](03-cli.md#update) command. This will fetch the latest matching
versions (according to your `composer.json` file) and update the lock file
with the new versions. (This is equivalent to deleting the `composer.lock` file
and running `install` again.)

```sh
php composer.phar update
```

> **Note:** Composer will display a Warning when executing an `install` command
> if the `composer.lock` has not been updated since changes were made to the
> `composer.json` that might affect dependency resolution.

If you only want to install or update one dependency, you can whitelist them:

```sh
php composer.phar update monolog/monolog [...]
```

> **Note:** For libraries it is not necessary to commit the lock
> file, see also: [Libraries - Lock file](02-libraries.md#lock-file).

## Packagist

[Packagist](https://packagist.org/) is the main Composer repository. A Composer
repository is basically a package source: a place where you can get packages
from. Packagist aims to be the central repository that everybody uses. This
means that you can automatically `require` any package that is available there,
without further specifying where Composer should look for the package.

If you go to the [Packagist website](https://packagist.org/) (packagist.org),
you can browse and search for packages.

Any open source project using Composer is recommended to publish their packages
on Packagist. A library does not need to be on Packagist to be used by Composer,
but it enables discovery and adoption by other developers more quickly.

## Platform packages

Composer has platform packages, which are virtual packages for things that are
installed on the system but are not actually installable by Composer. This
includes PHP itself, PHP extensions and some system libraries.

* `php` represents the PHP version of the user, allowing you to apply
  constraints, e.g. `^7.1`. To require a 64bit version of php, you can
  require the `php-64bit` package.

* `hhvm` represents the version of the HHVM runtime and allows you to apply
  a constraint, e.g., `^2.3`.

* `ext-<name>` allows you to require PHP extensions (includes core
  extensions). Versioning can be quite inconsistent here, so it's often
  a good idea to set the constraint to `*`.  An example of an extension
  package name is `ext-gd`.

* `lib-<name>` allows constraints to be made on versions of libraries used by
  PHP. The following are available: `curl`, `iconv`, `icu`, `libxml`,
  `openssl`, `pcre`, `uuid`, `xsl`.

You can use [`show --platform`](03-cli.md#show) to get a list of your locally
available platform packages.

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
[`autoload`](04-schema.md#autoload) field to `composer.json`.

```json
{
    "autoload": {
        "psr-4": {"Acme\\": "src/"}
    }
}
```

Composer will register a [PSR-4](http://www.php-fig.org/psr/psr-4/) autoloader
for the `Acme` namespace.

You define a mapping from namespaces to directories. The `src` directory would
be in your project root, on the same level as `vendor` directory is. An example
filename would be `src/Foo.php` containing an `Acme\Foo` class.

After adding the [`autoload`](04-schema.md#autoload) field, you have to re-run
[`dump-autoload`](03-cli.md#dump-autoload) to re-generate the
`vendor/autoload.php` file.

Including that file will also return the autoloader instance, so you can store
the return value of the include call in a variable and add more namespaces.
This can be useful for autoloading classes in a test suite, for example.

```php
$loader = require __DIR__ . '/vendor/autoload.php';
$loader->addPsr4('Acme\\Test\\', __DIR__);
```

In addition to PSR-4 autoloading, Composer also supports PSR-0, classmap and
files autoloading. See the [`autoload`](04-schema.md#autoload) reference for
more information.

See also the docs on [optimizing the autoloader](articles/autoloader-optimization.md).

> **Note:** Composer provides its own autoloader. If you don't want to use that
> one, you can include `vendor/composer/autoload_*.php` files, which return
> associative arrays allowing you to configure your own autoloader.

[Libraries](02-libraries.md) &rarr;

[article-versions]: articles/versions.md
[intro]: 00-intro.md
[intro-localmente]: 00-intro.md#localmente
[libraries]: 02-libraries.md
[repositories]: 05-repositories.md
[platform-packages]: #platform-packages
[schema]: 04-schema.md
[schema-require]: 04-schema.md#require
[schema-repositories]: 04-schema.md#repositories
[semver-monolog]: https://semver.mwl.be/#?package=monolog%2Fmonolog&version=1.0.*
[packagist]: #packagist
