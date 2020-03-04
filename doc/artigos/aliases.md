<!--
    tagline: Cria alias de nomes de branch para versões
-->

# Aliases

## Por que Aliases?

Quando você estiver usando um repositório VCS, você obterá apenas versões
comparáveis dos branches semelhantes a versões, como `2.0` ou `2.0.x`. Para o
branch `master`, você obterá uma versão `dev-master`. Para o branch `bugfix`,
você obterá uma versão `dev-bugfix`.

Se o branch `master` for usado para criar tags de lançamentos da linha de
desenvolvimento `1.0`, ou seja, `1.0.1`, `1.0.2`, `1.0.3`, etc., qualquer pacote
dependendo dele provavelmente exigirá a versão `1.0.*`.

Se alguém quiser exigir o `dev-master` mais recente, terá um problema: outros
pacotes podem exigir `1.0.*`, portanto, exigir essa versão de desenvolvimento
levará a conflitos, pois `dev-master` não corresponde à restrição `1.0.*`.

É aí que entram os aliases.

## Branch alias

The `dev-master` branch is one in your main VCS repo. It is rather common that
someone will want the latest master dev version. Thus, Composer allows you to
alias your `dev-master` branch to a `1.0.x-dev` version. It is done by
specifying a `branch-alias` field under `extra` in `composer.json`:

```json
{
    "extra": {
        "branch-alias": {
            "dev-master": "1.0.x-dev"
        }
    }
}
```

If you alias a non-comparable version (such as dev-develop) `dev-` must prefix the
branch name. You may also alias a comparable version (i.e. start with numbers,
and end with `.x-dev`), but only as a more specific version.
For example, 1.x-dev could be aliased as 1.2.x-dev.

The alias must be a comparable dev version, and the `branch-alias` must be present on
the branch that it references. For `dev-master`, you need to commit it on the
`master` branch.

As a result, anyone can now require `1.0.*` and it will happily install
`dev-master`.

In order to use branch aliasing, you must own the repository of the package
being aliased. If you want to alias a third party package without maintaining
a fork of it, use inline aliases as described below.

## Require inline alias

Branch aliases are great for aliasing main development lines. But in order to
use them you need to have control over the source repository, and you need to
commit changes to version control.

This is not really fun when you want to try a bugfix of some library that
is a dependency of your local project.

For this reason, you can alias packages in your `require` and `require-dev`
fields. Let's say you found a bug in the `monolog/monolog` package. You cloned
[Monolog](https://github.com/Seldaek/monolog) on GitHub and fixed the issue in
a branch named `bugfix`. Now you want to install that version of monolog in your
local project.

You are using `symfony/monolog-bundle` which requires `monolog/monolog` version
`1.*`. So you need your `dev-bugfix` to match that constraint.

Add this to your project's root `composer.json`:

```json
{
    "repositories": [
        {
            "type": "vcs",
            "url": "https://github.com/you/monolog"
        }
    ],
    "require": {
        "symfony/monolog-bundle": "2.0",
        "monolog/monolog": "dev-bugfix as 1.0.x-dev"
    }
}
```

Or let composer add it for you with:

```
php composer.phar require monolog/monolog:"dev-bugfix as 1.0.x-dev"
```

That will fetch the `dev-bugfix` version of `monolog/monolog` from your GitHub
and alias it to `1.0.x-dev`.

> **Note:** Inline aliasing is a root-only feature. If a package with inline
> aliases is required, the alias (right of the `as`) is used as the version
> constraint. The part left of the `as` is discarded. As a consequence, if
> A requires B and B requires `monolog/monolog` version `dev-bugfix as 1.0.x-dev`,
> installing A will make B require `1.0.x-dev`, which may exist as a branch
> alias or an actual `1.0` branch. If it does not, it must be
> inline-aliased again in A's `composer.json`.

> **Note:** Inline aliasing should be avoided, especially for published
> packages/libraries. If you found a bug, try and get your fix merged upstream.
> This helps to avoid issues for users of your package.
