# O Esquema do composer.json

Este capítulo explicará todos os campos disponíveis no `composer.json`.

## Esquema JSON

Temos um [esquema JSON][json-schema] que documenta o formato e também pode ser
usado para validar seu `composer.json`. De fato, ele é usado pelo comando
`validate`. Você pode encontrá-lo no [site do Composer][schema-page].

## Pacote Raiz

O pacote raiz é o pacote definido pelo `composer.json` na raiz do seu projeto. É
o `composer.json` principal que define os requisitos do seu projeto.

Certos campos se aplicam apenas no contexto do pacote raiz. Um exemplo disto é o
campo `config`. Somente o pacote raiz pode definir a configuração. O campo
`config` das dependências é ignorado. Isto faz do campo `config` um campo
`root-only`.

> **Nota:** Um pacote pode ser o pacote raiz ou não, dependendo do contexto. Por
> exemplo, se seu projeto depende da biblioteca `monolog`, seu projeto é o
> pacote raiz. No entanto, se você clonar o `monolog` no GitHub para corrigir um
> erro, então o `monolog` é o pacote raiz.

## Propriedades

### name

O nome do pacote. Consiste no nome do vendor e no nome do projeto, separados por
`/`. Exemplos:

* monolog/monolog
* igorw/event-source

O nome pode conter qualquer caractere, incluindo espaços em branco, e não
diferencia maiúsculas de minúsculas (`foo/bar` e `Foo/Bar` são considerados o
mesmo pacote). Para simplificar sua instalação, é recomendável definir um nome
curto e em minúsculas que não inclua caracteres não alfanuméricos ou espaços em
branco.

Obrigatório para pacotes publicados (bibliotecas).

### description

Uma breve descrição do pacote. Normalmente, tem apenas uma linha de comprimento.

Obrigatório para pacotes publicados (bibliotecas).

### version

A versão do pacote. Na maioria dos casos, não é necessária e deve ser omitida
(veja abaixo).

Ela deve seguir o formato `X.Y.Z` ou `vX.Y.Z` com um sufixo opcional `-dev`,
`-patch` (`-p`), `-alpha` (`-a`), `-beta` (`-b`) ou `-RC`. Os sufixos patch,
alpha, beta e RC podem ser seguidos por um número.

Exemplos:

- 1.0.0
- 1.0.2
- 1.1.0
- 0.2.5
- 1.0.0-dev
- 1.0.0-alpha3
- 1.0.0-beta2
- 1.0.0-RC5
- v2.0.4-p1

Opcional se o repositório do pacote puder inferir a versão de algum lugar, como
o nome da tag no repositório VCS. Neste caso, também é recomendável omiti-la.

> **Nota:** O Packagist usa repositórios VCS, portanto, a declaração acima
> também é verdadeira para o Packagist. Especificar a versão por conta própria
> provavelmente criará problemas em algum momento devido a erro humano.

### type

O tipo do pacote. O padrão é `library`.

Os tipos de pacote são usados para lógica de instalação personalizada. Se você
tiver um pacote que precise de alguma lógica especial, você pode definir um tipo
personalizado. Pode ser, por exemplo, `symfony-bundle`, `wordpress-plugin` ou
`typo3-cms-extension`. Estes tipos serão específicos para determinados projetos
e precisarão fornecer um instalador capaz de instalar pacotes deste tipo.

Pronto para uso, o Composer suporta quatro tipos:

- **library:** Este é o padrão. Ele simplesmente copiará os arquivos para
  `vendor`.
- **project:** Denota um projeto em vez de uma biblioteca. Por exemplo, shells
  de aplicações como a [Edição Padrão do Symfony][sf-standard], CMSs como o
  [instalador do SilverStripe][silverstripe-installer] ou aplicações completas
  distribuídas como pacotes. Isto pode ser usado, por exemplo, pelas IDEs para
  fornecer listagens de projetos a serem inicializados ao criar um novo
  workspace.
- **metapackage:** Um pacote vazio que contém requisitos e acionará suas
  instalações, mas não contém nenhum arquivo e não gravará nada no sistema de
  arquivos. Sendo assim, não requer uma chave `dist` ou `source` para ser
  instalável.
- **composer-plugin:** Um pacote do tipo `composer-plugin` pode fornecer um
  instalador para outros pacotes que possuem um tipo personalizado. Leia mais no
  [artigo dedicado][art-installers].

Use um tipo personalizado somente se precisar de lógica personalizada durante a
instalação. É recomendável omitir este campo e usar o padrão `library`.

### keywords

Uma lista de palavras-chave às quais o pacote está relacionado. Elas podem ser
usadas para pesquisa e filtragem.

Exemplos:

- logging
- events
- database
- redis
- templating

Opcional.

### homepage

Uma URL para o site do projeto.

Opcional.

### readme

A relative path to the readme document.

Opcional.

### time

Release date of the version.

Must be in `YYYY-MM-DD` or `YYYY-MM-DD HH:MM:SS` format.

Opcional.

### license

The license of the package. This can be either a string or an array of strings.

The recommended notation for the most common licenses is (alphabetical):

- Apache-2.0
- BSD-2-Clause
- BSD-3-Clause
- BSD-4-Clause
- GPL-2.0-only / GPL-2.0-or-later
- GPL-3.0-only / GPL-3.0-or-later
- LGPL-2.1-only / LGPL-2.1-or-later
- LGPL-3.0-only / LGPL-3.0-or-later
- MIT

Optional, but it is highly recommended to supply this. More identifiers are
listed at the [SPDX Open Source License Registry](https://spdx.org/licenses/).

For closed-source software, you may use `"proprietary"` as the license identifier.

An Example:

```json
{
    "license": "MIT"
}
```

For a package, when there is a choice between licenses ("disjunctive license"),
multiple can be specified as array.

An Example for disjunctive licenses:

```json
{
    "license": [
       "LGPL-2.1-only",
       "GPL-3.0-or-later"
    ]
}
```

Alternatively they can be separated with "or" and enclosed in parenthesis;

```json
{
    "license": "(LGPL-2.1-only or GPL-3.0-or-later)"
}
```

Similarly when multiple licenses need to be applied ("conjunctive license"),
they should be separated with "and" and enclosed in parenthesis.

### authors

The authors of the package. This is an array of objects.

Each author object can have following properties:

* **name:** The author's name. Usually their real name.
* **email:** The author's email address.
* **homepage:** An URL to the author's website.
* **role:** The author's role in the project (e.g. developer or translator)

An example:

```json
{
    "authors": [
        {
            "name": "Nils Adermann",
            "email": "naderman@naderman.de",
            "homepage": "http://www.naderman.de",
            "role": "Developer"
        },
        {
            "name": "Jordi Boggiano",
            "email": "j.boggiano@seld.be",
            "homepage": "https://seld.be",
            "role": "Developer"
        }
    ]
}
```

Optional, but highly recommended.

### support

Various information to get support about the project.

Support information includes the following:

* **email:** Email address for support.
* **issues:** URL to the issue tracker.
* **forum:** URL to the forum.
* **wiki:** URL to the wiki.
* **irc:** IRC channel for support, as irc://server/channel.
* **source:** URL to browse or download the sources.
* **docs:** URL to the documentation.
* **rss:** URL to the RSS feed.
* **chat:** URL to the chat channel.

An example:

```json
{
    "support": {
        "email": "support@example.org",
        "irc": "irc://irc.freenode.org/composer"
    }
}
```

Opcional.

### Package links

All of the following take an object which maps package names to
versions of the package via version constraints. Read more about
versions [here](artigos/versions.md).

Example:

```json
{
    "require": {
        "monolog/monolog": "1.0.*"
    }
}
```

All links are optional fields.

`require` and `require-dev` additionally support stability flags ([root-only](#root-package)).
These allow you to further restrict or expand the stability of a package beyond
the scope of the [minimum-stability](#minimum-stability) setting. You can apply
them to a constraint, or apply them to an empty constraint if you want to
allow unstable packages of a dependency for example.

Example:

```json
{
    "require": {
        "monolog/monolog": "1.0.*@beta",
        "acme/foo": "@dev"
    }
}
```

If one of your dependencies has a dependency on an unstable package you need to
explicitly require it as well, along with its sufficient stability flag.

Example:

Assuming `doctrine/doctrine-fixtures-bundle` requires `"doctrine/data-fixtures": "dev-master"`
then inside the root composer.json you need to add the second line below to allow dev
releases for the `doctrine/data-fixtures` package :

```json
{
    "require": {
        "doctrine/doctrine-fixtures-bundle": "dev-master",
        "doctrine/data-fixtures": "@dev"
    }
}
```

`require` and `require-dev` additionally support explicit references (i.e.
commit) for dev versions to make sure they are locked to a given state, even
when you run update. These only work if you explicitly require a dev version
and append the reference with `#<ref>`. This is also a
[root-only](#root-package) feature and will be ignored in
dependencies.

Example:

```json
{
    "require": {
        "monolog/monolog": "dev-master#2eb0c0978d290a1c45346a1955188929cb4e5db7",
        "acme/foo": "1.0.x-dev#abc123"
    }
}
```

> **Note:** This feature has severe technical limitations, as the
> composer.json metadata will still be read from the branch name you specify
> before the hash. You should therefore only use this as a temporary solution
> during development to remediate transient issues, until you can switch to
> tagged releases. The Composer team does not actively support this feature
> and will not accept bug reports related to it.

It is also possible to inline-alias a package constraint so that it matches
a constraint that it otherwise would not. For more information [see the
aliases article](artigos/aliases.md).

`require` and `require-dev` also support references to specific PHP versions
and PHP extensions your project needs to run successfully.

Example:

```json
{
    "require" : {
        "php" : "^5.5 || ^7.0",
        "ext-mbstring": "*"
    }
}
```

> **Note:** It is important to list PHP extensions your project requires.
> Not all PHP installations are created equal: some may miss extensions you
> may consider as standard (such as `ext-mysqli` which is not installed by
> default in Fedora/CentOS minimal installation systems). Failure to list
> required PHP extensions may lead to a bad user experience: Composer will
> install your package without any errors but it will then fail at run-time.
> The `composer show --platform` command lists all PHP extensions available on
> your system. You may use it to help you compile the list of extensions you
> use and require. Alternatively you may use third party tools to analyze
> your project for the list of extensions used.

#### require

Lists packages required by this package. The package will not be installed
unless those requirements can be met.

#### require-dev <span>([root-only](#root-package))</span>

Lists packages required for developing this package, or running
tests, etc. The dev requirements of the root package are installed by default.
Both `install` or `update` support the `--no-dev` option that prevents dev
dependencies from being installed.

#### conflict

Lists packages that conflict with this version of this package. They
will not be allowed to be installed together with your package.

Note that when specifying ranges like `<1.0 >=1.1` in a `conflict` link,
this will state a conflict with all versions that are less than 1.0 *and* equal
or newer than 1.1 at the same time, which is probably not what you want. You
probably want to go for `<1.0 || >=1.1` in this case.

#### replace

Lists packages that are replaced by this package. This allows you to fork a
package, publish it under a different name with its own version numbers, while
packages requiring the original package continue to work with your fork because
it replaces the original package.

This is also useful for packages that contain sub-packages, for example the main
symfony/symfony package contains all the Symfony Components which are also
available as individual packages. If you require the main package it will
automatically fulfill any requirement of one of the individual components,
since it replaces them.

Caution is advised when using replace for the sub-package purpose explained
above. You should then typically only replace using `self.version` as a version
constraint, to make sure the main package only replaces the sub-packages of
that exact version, and not any other version, which would be incorrect.

#### provide

List of other packages that are provided by this package. This is mostly
useful for common interfaces. A package could depend on some virtual
`logger` package, any library that implements this logger interface would
simply list it in `provide`.

#### suggest

Suggested packages that can enhance or work well with this package. These are
informational and are displayed after the package is installed, to give
your users a hint that they could add more packages, even though they are not
strictly required.

The format is like package links above, except that the values are free text
and not version constraints.

Example:

```json
{
    "suggest": {
        "monolog/monolog": "Allows more advanced logging of the application flow",
        "ext-xml": "Needed to support XML format in class Foo"
    }
}
```

### autoload

Autoload mapping for a PHP autoloader.

[`PSR-4`](http://www.php-fig.org/psr/psr-4/) and [`PSR-0`](http://www.php-fig.org/psr/psr-0/)
autoloading, `classmap` generation and `files` includes are supported.

PSR-4 is the recommended way since it offers greater ease of use (no need
to regenerate the autoloader when you add classes).

#### PSR-4

Under the `psr-4` key you define a mapping from namespaces to paths, relative to the
package root. When autoloading a class like `Foo\\Bar\\Baz` a namespace prefix
`Foo\\` pointing to a directory `src/` means that the autoloader will look for a
file named `src/Bar/Baz.php` and include it if present. Note that as opposed to
the older PSR-0 style, the prefix (`Foo\\`) is **not** present in the file path.

Namespace prefixes must end in `\\` to avoid conflicts between similar prefixes.
For example `Foo` would match classes in the `FooBar` namespace so the trailing
backslashes solve the problem: `Foo\\` and `FooBar\\` are distinct.

The PSR-4 references are all combined, during install/update, into a single
key => value array which may be found in the generated file
`vendor/composer/autoload_psr4.php`.

Example:

```json
{
    "autoload": {
        "psr-4": {
            "Monolog\\": "src/",
            "Vendor\\Namespace\\": ""
        }
    }
}
```

If you need to search for a same prefix in multiple directories,
you can specify them as an array as such:

```json
{
    "autoload": {
        "psr-4": { "Monolog\\": ["src/", "lib/"] }
    }
}
```

If you want to have a fallback directory where any namespace will be looked for,
you can use an empty prefix like:

```json
{
    "autoload": {
        "psr-4": { "": "src/" }
    }
}
```

#### PSR-0

Under the `psr-0` key you define a mapping from namespaces to paths, relative to the
package root. Note that this also supports the PEAR-style non-namespaced convention.

Please note namespace declarations should end in `\\` to make sure the autoloader
responds exactly. For example `Foo` would match in `FooBar` so the trailing
backslashes solve the problem: `Foo\\` and `FooBar\\` are distinct.

The PSR-0 references are all combined, during install/update, into a single key => value
array which may be found in the generated file `vendor/composer/autoload_namespaces.php`.

Example:

```json
{
    "autoload": {
        "psr-0": {
            "Monolog\\": "src/",
            "Vendor\\Namespace\\": "src/",
            "Vendor_Namespace_": "src/"
        }
    }
}
```

If you need to search for a same prefix in multiple directories,
you can specify them as an array as such:

```json
{
    "autoload": {
        "psr-0": { "Monolog\\": ["src/", "lib/"] }
    }
}
```

The PSR-0 style is not limited to namespace declarations only but may be
specified right down to the class level. This can be useful for libraries with
only one class in the global namespace. If the php source file is also located
in the root of the package, for example, it may be declared like this:

```json
{
    "autoload": {
        "psr-0": { "UniqueGlobalClass": "" }
    }
}
```

If you want to have a fallback directory where any namespace can be, you can
use an empty prefix like:

```json
{
    "autoload": {
        "psr-0": { "": "src/" }
    }
}
```

#### Classmap

The `classmap` references are all combined, during install/update, into a single
key => value array which may be found in the generated file
`vendor/composer/autoload_classmap.php`. This map is built by scanning for
classes in all `.php` and `.inc` files in the given directories/files.

You can use the classmap generation support to define autoloading for all libraries
that do not follow PSR-0/4. To configure this you specify all directories or files
to search for classes.

Example:

```json
{
    "autoload": {
        "classmap": ["src/", "lib/", "Something.php"]
    }
}
```

#### Files

If you want to require certain files explicitly on every request then you can use
the `files` autoloading mechanism. This is useful if your package includes PHP functions
that cannot be autoloaded by PHP.

Example:

```json
{
    "autoload": {
        "files": ["src/MyLibrary/functions.php"]
    }
}
```

#### Exclude files from classmaps

If you want to exclude some files or folders from the classmap you can use the `exclude-from-classmap` property.
This might be useful to exclude test classes in your live environment, for example, as those will be skipped
from the classmap even when building an optimized autoloader.

The classmap generator will ignore all files in the paths configured here. The paths are absolute from the package
root directory (i.e. composer.json location), and support `*` to match anything but a slash, and `**` to
match anything. `**` is implicitly added to the end of the paths.

Example:

```json
{
    "autoload": {
        "exclude-from-classmap": ["/Tests/", "/test/", "/tests/"]
    }
}
```

#### Optimizing the autoloader

The autoloader can have quite a substantial impact on your request time
(50-100ms per request in large frameworks using a lot of classes). See the
[article about optimizing the autoloader](artigos/autoloader-optimization.md)
for more details on how to reduce this impact.

### autoload-dev <span>([root-only](#root-package))</span>

This section allows to define autoload rules for development purposes.

Classes needed to run the test suite should not be included in the main autoload
rules to avoid polluting the autoloader in production and when other people use
your package as a dependency.

Therefore, it is a good idea to rely on a dedicated path for your unit tests
and to add it within the autoload-dev section.

Example:

```json
{
    "autoload": {
        "psr-4": { "MyLibrary\\": "src/" }
    },
    "autoload-dev": {
        "psr-4": { "MyLibrary\\Tests\\": "tests/" }
    }
}
```

### include-path

> **DEPRECATED**: This is only present to support legacy projects, and all new code
> should preferably use autoloading. As such it is a deprecated practice, but the
> feature itself will not likely disappear from Composer.

A list of paths which should get appended to PHP's `include_path`.

Example:

```json
{
    "include-path": ["lib/"]
}
```

Opcional.

### target-dir

> **DEPRECATED**: This is only present to support legacy PSR-0 style autoloading,
> and all new code should preferably use PSR-4 without target-dir and projects
> using PSR-0 with PHP namespaces are encouraged to migrate to PSR-4 instead.

Defines the installation target.

In case the package root is below the namespace declaration you cannot
autoload properly. `target-dir` solves this problem.

An example is Symfony. There are individual packages for the components. The
Yaml component is under `Symfony\Component\Yaml`. The package root is that
`Yaml` directory. To make autoloading possible, we need to make sure that it
is not installed into `vendor/symfony/yaml`, but instead into
`vendor/symfony/yaml/Symfony/Component/Yaml`, so that the autoloader can load
it from `vendor/symfony/yaml`.

To do that, `autoload` and `target-dir` are defined as follows:

```json
{
    "autoload": {
        "psr-0": { "Symfony\\Component\\Yaml\\": "" }
    },
    "target-dir": "Symfony/Component/Yaml"
}
```

Opcional.

### minimum-stability <span>([root-only](#root-package))</span>

This defines the default behavior for filtering packages by stability. This
defaults to `stable`, so if you rely on a `dev` package, you should specify
it in your file to avoid surprises.

All versions of each package are checked for stability, and those that are less
stable than the `minimum-stability` setting will be ignored when resolving
your project dependencies. (Note that you can also specify stability requirements
on a per-package basis using stability flags in the version constraints that you
specify in a `require` block (see [package links](#package-links) for more details).

Available options (in order of stability) are `dev`, `alpha`, `beta`, `RC`,
and `stable`.

### prefer-stable <span>([root-only](#root-package))</span>

When this is enabled, Composer will prefer more stable packages over unstable
ones when finding compatible stable packages is possible. If you require a
dev version or only alphas are available for a package, those will still be
selected granted that the minimum-stability allows for it.

Use `"prefer-stable": true` to enable.

### repositories <span>([root-only](#root-package))</span>

Custom package repositories to use.

By default Composer only uses the packagist repository. By specifying
repositories you can get packages from elsewhere.

Repositories are not resolved recursively. You can only add them to your main
`composer.json`. Repository declarations of dependencies' `composer.json`s are
ignored.

The following repository types are supported:

* **composer:** A Composer repository is simply a `packages.json` file served
  via the network (HTTP, FTP, SSH), that contains a list of `composer.json`
  objects with additional `dist` and/or `source` information. The `packages.json`
  file is loaded using a PHP stream. You can set extra options on that stream
  using the `options` parameter.
* **vcs:** The version control system repository can fetch packages from git,
  svn, fossil and hg repositories.
* **pear:** With this you can import any pear repository into your Composer
  project.
* **package:** If you depend on a project that does not have any support for
  composer whatsoever you can define the package inline using a `package`
  repository. You basically inline the `composer.json` object.

For more information on any of these, see [Repositories](05-repositories.md).

Example:

```json
{
    "repositories": [
        {
            "type": "composer",
            "url": "http://packages.example.com"
        },
        {
            "type": "composer",
            "url": "https://packages.example.com",
            "options": {
                "ssl": {
                    "verify_peer": "true"
                }
            }
        },
        {
            "type": "vcs",
            "url": "https://github.com/Seldaek/monolog"
        },
        {
            "type": "pear",
            "url": "https://pear2.php.net"
        },
        {
            "type": "package",
            "package": {
                "name": "smarty/smarty",
                "version": "3.1.7",
                "dist": {
                    "url": "https://www.smarty.net/files/Smarty-3.1.7.zip",
                    "type": "zip"
                },
                "source": {
                    "url": "https://smarty-php.googlecode.com/svn/",
                    "type": "svn",
                    "reference": "tags/Smarty_3_1_7/distribution/"
                }
            }
        }
    ]
}
```

> **Note:** Order is significant here. When looking for a package, Composer
will look from the first to the last repository, and pick the first match.
By default Packagist is added last which means that custom repositories can
override packages from it.

Using JSON object notation is also possible. However, JSON key/value pairs
are to be considered unordered so consistent behaviour cannot be guaranteed.

 ```json
{
    "repositories": {
         "foo": {
             "type": "composer",
             "url": "http://packages.foo.com"
         }
    }
}
 ```

### config <span>([root-only](#root-package))</span>

A set of configuration options. It is only used for projects. See
[Config](06-config.md) for a description of each individual option.

### scripts <span>([root-only](#root-package))</span>

Composer allows you to hook into various parts of the installation process
through the use of scripts.

See [Scripts](artigos/scripts.md) for events details and examples.

### extra

Arbitrary extra data for consumption by `scripts`.

This can be virtually anything. To access it from within a script event
handler, you can do:

```php
$extra = $event->getComposer()->getPackage()->getExtra();
```

Opcional.

### bin

A set of files that should be treated as binaries and symlinked into the `bin-dir`
(from config).

See [Vendor Binaries](artigos/vendor-binaries.md) for more details.

Opcional.

### archive

A set of options for creating package archives.

The following options are supported:

* **exclude:** Allows configuring a list of patterns for excluded paths. The
  pattern syntax matches .gitignore files. A leading exclamation mark (!) will
  result in any matching files to be included even if a previous pattern
  excluded them. A leading slash will only match at the beginning of the project
  relative path. An asterisk will not expand to a directory separator.

Example:

```json
{
    "archive": {
        "exclude": ["/foo/bar", "baz", "/*.test", "!/foo/bar/baz"]
    }
}
```

The example will include `/dir/foo/bar/file`, `/foo/bar/baz`, `/file.php`,
`/foo/my.test` but it will exclude `/foo/bar/any`, `/foo/baz`, and `/my.test`.

Opcional.

### abandoned

Indicates whether this package has been abandoned.

It can be boolean or a package name/URL pointing to a recommended alternative.

Examples:

Use `"abandoned": true` to indicates this package is abandoned.
Use `"abandoned": "monolog/monolog"` to indicates this package is abandoned and the
recommended alternative is  `monolog/monolog`.

Defaults to false.

Opcional.

### non-feature-branches

A list of regex patterns of branch names that are non-numeric (e.g. "latest" or something),
that will NOT be handled as feature branches. This is an array of strings.

If you have non-numeric branch names, for example like "latest", "current", "latest-stable"
or something, that do not look like a version number, then Composer handles such branches
as feature branches. This means it searches for parent branches, that look like a version
or ends at special branches (like master) and the root package version number becomes the
version of the parent branch or at least master or something.

To handle non-numeric named branches as versions instead of searching for a parent branch
with a valid version or special branch name like master, you can set patterns for branch
names, that should be handled as dev version branches.

This is really helpful when you have dependencies using "self.version", so that not dev-master,
but the same branch is installed (in the example: latest-testing).

An example:

If you have a testing branch, that is heavily maintained during a testing phase and is
deployed to your staging environment, normally `composer show -s` will give you `versions : * dev-master`.

If you configure `latest-.*` as a pattern for non-feature-branches like this:

```json
{
    "non-feature-branches": ["latest-.*"]
}
```

Then `composer show -s` will give you `versions : * dev-latest-testing`.

Opcional.

&larr; [Command-line interface](03-cli.md)  |  [Repositories](05-repositories.md) &rarr;

[art-installers]: artigos/custom-installers.md
[json-schema]: http://json-schema.org
[schema-page]: https://getcomposer.org/schema.json
[sf-standard]: https://github.com/symfony/symfony-standard
[silverstripe-installer]: https://github.com/silverstripe/silverstripe-installer
