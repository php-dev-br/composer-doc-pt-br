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

Um array de palavras-chave às quais o pacote está relacionado. Elas podem ser
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

Um caminho relativo para o documento `README`.

Opcional.

### time

Data de lançamento da versão.

Deve estar no formato `YYYY-MM-DD` ou `YYYY-MM-DD HH:MM:SS`.

Opcional.

### license

A licença do pacote. Pode ser uma string ou um array de strings.

A notação recomendada para as licenças mais comuns é (em ordem alfabética):

- Apache-2.0
- BSD-2-Clause
- BSD-3-Clause
- BSD-4-Clause
- GPL-2.0-only / GPL-2.0-or-later
- GPL-3.0-only / GPL-3.0-or-later
- LGPL-2.1-only / LGPL-2.1-or-later
- LGPL-3.0-only / LGPL-3.0-or-later
- MIT

Opcional, mas é altamente recomendável fornecê-la. Mais identificadores estão
listados no [Registro de Licenças de Código Aberto SPDX][licenses].

Para software de código fechado, você pode usar `proprietary` como identificador
da licença.

Um exemplo:

```json
{
    "license": "MIT"
}
```

Para um pacote, quando há uma escolha entre as licenças ("licenças
disjuntivas"), várias podem ser especificadas como array.

Um exemplo usando licenças disjuntivas:

```json
{
    "license": [
       "LGPL-2.1-only",
       "GPL-3.0-or-later"
    ]
}
```

Alternativamente, elas podem ser separadas por `or` e colocadas entre
parênteses;

```json
{
    "license": "(LGPL-2.1-only or GPL-3.0-or-later)"
}
```

Da mesma forma, quando várias licenças precisam ser aplicadas ("licenças
conjuntivas"), elas devem ser separadas por `and` e colocadas entre parênteses;

### authors

As pessoas que criaram o pacote, listadas em um array de objetos.

Cada objeto de pessoa pode ter as seguintes propriedades:

* **name:** O nome da pessoa. Geralmente o nome verdadeiro.
* **email:** O endereço de e-mail da pessoa.
* **homepage:** Uma URL para o site da pessoa.
* **role:** A função da pessoa no projeto (por exemplo, desenvolvedora ou
  tradutora).

Um exemplo:

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

Opcional, mas altamente recomendada.

### support

Várias informações para obter suporte para o projeto.

As informações de suporte incluem as seguintes:

* **email:** Endereço de e-mail para suporte.
* **issues:** URL do sistema para acompanhamento de issues.
* **forum:** URL do fórum.
* **wiki:** URL da wiki.
* **irc:** canal IRC para suporte, como `irc://servidor/canal`.
* **source:** URL para pesquisar ou baixar o código-fonte.
* **docs:** URL da documentação.
* **rss:** URL para o feed RSS.
* **chat:** URL para o canal de chat.

Um exemplo:

```json
{
    "support": {
        "email": "support@example.org",
        "irc": "irc://irc.freenode.org/composer"
    }
}
```

Opcional.

### Links de Pacotes

Todos os itens a seguir recebem um objeto que mapeia nomes de pacotes para
versões do pacote através de restrições de versão. Leia mais sobre versões
[aqui][art-versions].

Exemplo:

```json
{
    "require": {
        "monolog/monolog": "1.0.*"
    }
}
```

Todos os links são campos opcionais.

`require` e `require-dev` também oferecem suporte a flags de estabilidade
([root-only][root-package]). Elas permitem restringir ou expandir ainda mais a
estabilidade de um pacote além do escopo da configuração [minimum-stability]
[min-stability]. Você pode aplicá-las a uma restrição ou aplicá-las a uma
restrição vazia, se desejar permitir pacotes instáveis de uma dependência, por
exemplo.

Exemplo:

```json
{
    "require": {
        "monolog/monolog": "1.0.*@beta",
        "acme/foo": "@dev"
    }
}
```

Se uma de suas dependências depender de um pacote instável, você também
precisará requisitá-lo explicitamente, juntamente com a flag de estabilidade
necessária.

Exemplo:

Assumindo que `doctrine/doctrine-fixtures-bundle` requer
`"doctrine/data-fixtures": "dev-master"`, então dentro do `composer.json`raiz,
você precisará adicionar a segunda linha abaixo para permitir versões de
desenvolvimento do pacote `doctrine/data-fixtures`:

```json
{
    "require": {
        "doctrine/doctrine-fixtures-bundle": "dev-master",
        "doctrine/data-fixtures": "@dev"
    }
}
```

Além disso, `require` e `require-dev` suportam referências explícitas (ou seja,
commits) para versões de desenvolvimento para garantir que elas estejam travadas
em um determinado estado, mesmo quando você executa a atualização. Elas
funcionam apenas se você requisitar explicitamente uma versão de desenvolvimento
e adicionar a referência com `#<ref>`. Este também é um recurso [root-only]
[root-package] e será ignorado nas dependências.

Exemplo:

```json
{
    "require": {
        "monolog/monolog": "dev-master#2eb0c0978d290a1c45346a1955188929cb4e5db7",
        "acme/foo": "1.0.x-dev#abc123"
    }
}
```

> **Nota:** Esse recurso tem graves limitações técnicas, pois os metadados do
> `composer.json` ainda serão lidos a partir do nome do branch que você
> especificar antes do hash. Portanto, você deve usar isso apenas como uma
> solução temporária durante o desenvolvimento para corrigir problemas
> transitórios, até poder alternar para versões de tag. O time do Composer não
> suporta ativamente esse recurso e não aceita relatórios de erros relacionados
> a ele.

Também é possível criar um alias em linha de uma restrição de pacote, para que
ela corresponda a uma restrição que de outra forma não corresponderia. Para
obter mais informações, [consulte o artigo sobre aliases][art-aliases].

`require` e `require-dev` também suportam referências a versões específicas do
PHP e de extensões PHP que seu projeto precisa para executar com sucesso.

Exemplo:

```json
{
    "require" : {
        "php" : "^5.5 || ^7.0",
        "ext-mbstring": "*"
    }
}
```

> **Nota:** É importante listar as extensões PHP que seu projeto requer. Nem
> todas as instalações PHP são criadas da mesma forma: algumas podem não possuir
> extensões que você pode considerar como padrão (como `ext-mysqli`, que não é
> instalada por padrão nas instalações mínimas dos sistemas Fedora/CentOS).
> Não listar as extensões PHP necessárias pode levar a uma experiência ruim do
> usuário: o Composer instalará seu pacote sem erros, mas ele falhará em tempo
> de execução. O comando `composer show --platform` lista todas as extensões PHP
> disponíveis no seu sistema. Você pode usá-lo para te ajudar a compilar a lista
> de extensões que você usa e precisa. Como alternativa, você pode usar
> ferramentas de terceiros para analisar seu projeto para obter a lista de
> extensões usadas.

#### require

Lista os pacotes exigidos por este pacote. O pacote não será instalado, a menos
que estes requisitos possam ser atendidos.

#### require-dev <span>([root-only](#pacote-raiz))</span> {: #require-dev }

Lista os pacotes necessários para desenvolver este pacote, executar testes, etc.
Os requisitos de desenvolvimento do pacote raiz são instalados por padrão. Tanto
`install` quanto `update` suportam a opção `--no-dev`, que impede a instalação
das dependências de desenvolvimento.

#### conflict

Lista os pacotes que entram em conflito com esta versão deste pacote. Eles não
poderão ser instalados junto com o seu pacote.

Observe que, ao especificar intervalos como `<1.0 >=1.1` em um link de
`conflict`, isso indicará um conflito com todas as versões inferiores a 1.0 *e*
iguais ou mais recentes que 1.1 ao mesmo tempo, o que provavelmente não é o que
você deseja. Você provavelmente quer escolher `<1.0 || >=1.1`, neste caso.

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

Exemplo:

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

Exemplo:

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

Exemplo:

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

Exemplo:

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

Exemplo:

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

Exemplo:

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

### autoload-dev <span>([root-only](#pacote-raiz))</span>

This section allows to define autoload rules for development purposes.

Classes needed to run the test suite should not be included in the main autoload
rules to avoid polluting the autoloader in production and when other people use
your package as a dependency.

Therefore, it is a good idea to rely on a dedicated path for your unit tests
and to add it within the autoload-dev section.

Exemplo:

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

Exemplo:

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

### minimum-stability <span>([root-only](#pacote-raiz))</span> {: #minimum-stability }

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

### prefer-stable <span>([root-only](#pacote-raiz))</span> {: #prefer-stable }

When this is enabled, Composer will prefer more stable packages over unstable
ones when finding compatible stable packages is possible. If you require a
dev version or only alphas are available for a package, those will still be
selected granted that the minimum-stability allows for it.

Use `"prefer-stable": true` to enable.

### repositories <span>([root-only](#pacote-raiz))</span> {: #repositories }

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

Exemplo:

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

### config <span>([root-only](#pacote-raiz))</span> {: #config }

A set of configuration options. It is only used for projects. See
[Config](06-config.md) for a description of each individual option.

### scripts <span>([root-only](#pacote-raiz))</span> {: #scripts }

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

Exemplo:

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

[art-aliases]: artigos/aliases.md
[art-installers]: artigos/custom-installers.md
[art-versions]: artigos/versions.md
[json-schema]: http://json-schema.org
[licenses]: https://spdx.org/licenses/
[min-stability]: #minimum-stability
[root-package]: #pacote-raiz
[schema-page]: https://getcomposer.org/schema.json
[sf-standard]: https://github.com/symfony/symfony-standard
[silverstripe-installer]: https://github.com/silverstripe/silverstripe-installer
