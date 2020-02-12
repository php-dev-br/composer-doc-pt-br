# Bibliotecas

Este capítulo mostrará como tornar sua biblioteca instalável através do
Composer.

## Todo Projeto É um Pacote

Assim que você tiver um `composer.json` em um diretório, esse diretório será um
pacote. Ao adicionar um [`require`][schema-require] a um projeto, você
está criando um pacote que depende de outros pacotes. A única diferença entre
seu projeto e uma biblioteca é que seu projeto é um pacote sem nome.

Para tornar esse pacote instalável, você precisa dar um nome a ele. Você faz
isso adicionando a propriedade [`name`][schema-name] ao `composer.json`:

```json
{
    "name": "acme/ola-mundo",
    "require": {
        "monolog/monolog": "1.0.*"
    }
}
```

Nesse caso, o nome do projeto é `acme/ola-mundo`, onde `acme` é o nome do
fornecedor. É obrigatório fornecer um nome de fornecedor.

> **Nota:** Se você não sabe o que usar como nome de fornecedor, seu nome de
> usuário do GitHub geralmente é uma boa aposta. Embora os nomes de pacotes não
> façam distinção entre maiúsculas e minúsculas, a convenção é usar apenas
> minúsculas e hífen para separar as palavras.

## Versionamento de Biblioteca

Na grande maioria dos casos, você manterá sua biblioteca usando algum tipo de
sistema de controle de versão como git, svn, hg ou fossil. Nesses casos, o
Composer deduz as versões a partir do seu VCS e você **não deve** especificar
uma versão no seu arquivo `composer.json`. (Consulte o [artigo sobre versões][article-versions]
para aprender sobre como o Composer usa branches e tags do VCS para resolver
restrições de versão.)

Se você estiver mantendo pacotes manualmente (ou seja, sem um VCS), precisará
especificar a versão explicitamente, adicionando uma propriedade `version` no
seu arquivo `composer.json`:

```json
{
    "version": "1.0.0"
}
```

> **Nota:** Quando você adiciona uma versão fixa no código ao VCS, a versão
> entra em conflito com os nomes das tags. O Composer não poderá determinar o
> número da versão.

### Versionamento do VCS

Composer uses your VCS's branch and tag features to resolve the version
constraints you specify in your `require` field to specific sets of files.
When determining valid available versions, Composer looks at all of your tags
and branches and translates their names into an internal list of options that
it then matches against the version constraint you provided.

For more on how Composer treats tags and branches and how it resolves package
version constraints, read the [versions][article-versions] article.

## Lock file

For your library you may commit the `composer.lock` file if you want to. This
can help your team to always test against the same dependency versions.
However, this lock file will not have any effect on other projects that depend
on it. It only has an effect on the main project.

If you do not want to commit the lock file and you are using git, add it to
the `.gitignore`.

## Publishing to a VCS

Once you have a VCS repository (version control system, e.g. git) containing a
`composer.json` file, your library is already composer-installable. In this
example we will publish the `acme/hello-world` library on GitHub under
`github.com/username/hello-world`.

Now, to test installing the `acme/hello-world` package, we create a new
project locally. We will call it `acme/blog`. This blog will depend on
`acme/hello-world`, which in turn depends on `monolog/monolog`. We can
accomplish this by creating a new `blog` directory somewhere, containing a
`composer.json`:

```json
{
    "name": "acme/blog",
    "require": {
        "acme/hello-world": "dev-master"
    }
}
```

The name is not needed in this case, since we don't want to publish the blog
as a library. It is added here to clarify which `composer.json` is being
described.

Now we need to tell the blog app where to find the `hello-world` dependency.
We do this by adding a package repository specification to the blog's
`composer.json`:

```json
{
    "name": "acme/blog",
    "repositories": [
        {
            "type": "vcs",
            "url": "https://github.com/username/hello-world"
        }
    ],
    "require": {
        "acme/hello-world": "dev-master"
    }
}
```

For more details on how package repositories work and what other types are
available, see [Repositories](05-repositories.md).

That's all. You can now install the dependencies by running Composer's
[`install`](03-cli.md#install) command!

**Recap:** Any git/svn/hg/fossil repository containing a `composer.json` can be
added to your project by specifying the package repository and declaring the
dependency in the [`require`][schema-require] field.

## Publishing to packagist

Alright, so now you can publish packages. But specifying the VCS repository
every time is cumbersome. You don't want to force all your users to do that.

The other thing that you may have noticed is that we did not specify a package
repository for `monolog/monolog`. How did that work? The answer is Packagist.

[Packagist](https://packagist.org/) is the main package repository for
Composer, and it is enabled by default. Anything that is published on
Packagist is available automatically through Composer. Since
[Monolog is on Packagist](https://packagist.org/packages/monolog/monolog), we
can depend on it without having to specify any additional repositories.

If we wanted to share `hello-world` with the world, we would publish it on
Packagist as well. Doing so is really easy.

You simply visit [Packagist](https://packagist.org) and hit the "Submit"
button. This will prompt you to sign up if you haven't already, and then
allows you to submit the URL to your VCS repository, at which point Packagist
will start crawling it. Once it is done, your package will be available to
anyone!

&larr; [Basic usage](01-basic-usage.md) |  [Command-line interface](03-cli.md) &rarr;

[article-versions]: articles/versions.md
[schema-name]: 04-schema.md#name
[schema-require]: 04-schema.md#require
