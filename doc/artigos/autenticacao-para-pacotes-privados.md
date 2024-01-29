<!--
tagline: Acesse pacotes e repositórios privados
source_url: https://github.com/composer/composer/blob/2.6/doc/articles/authentication-for-private-packages.md
revision: de3698f53588cff7a803137f4fc5b36f54574487
status: wip
-->

# Autenticação para pacotes e repositórios privados

O [servidor de pacotes privado][1] ou sistema de controle de versão
provavelmente está protegido com uma ou mais opções de autenticação.
Para permitir que um projeto tenha acesso a esses pacotes e repositórios, o
Composer deve ser informado sobre como se autenticar no servidor que os hospeda.

## Princípios de autenticação

Sempre que o Composer encontrar um repositório protegido, ele tentará se
autenticar primeiro usando credenciais já definidas.
Quando nenhuma dessas credenciais puder ser aplicada, ele solicitará credenciais
e as salvará (ou um token, se o Composer puder recuperar um).

| Tipo                   | Gerado por Prompt? |
|------------------------|:------------------:|
| [http-basic][2]        |        sim         |
| [Inline http-basic][3] |        não         |
| [HTTP Bearer][4]       |        não         |
| [Custom header][5]     |        não         |
| [gitlab-oauth][6]      |        sim         |
| [gitlab-token][7]      |        sim         |
| [github-oauth][8]      |        sim         |
| [bitbucket-oauth][9]   |        sim         |

Às vezes, a autenticação automática não é possível ou alguém pode querer
predefinir as credenciais de autenticação.

As credenciais podem ser armazenadas em 4 locais diferentes: em um arquivo
`auth.json` do projeto, um arquivo `auth.json` global, no próprio
`composer.json` ou na variável de ambiente `COMPOSER_AUTH`.

### Autenticação usando um arquivo `auth.json` por projeto {: #autenticacao-usando-um-arquivo-auth-json-por-projeto }

Neste método de armazenamento de autenticação, um arquivo `auth.json` estará na
mesma pasta que o arquivo `composer.json` do projeto.
Este arquivo pode ser criado e editado usando a linha de comando ou manualmente.

> **Nota: Certifique-se de que o arquivo `auth.json` esteja no `.gitignore`**
> para evitar o vazamento de credenciais no histórico do git.

### Credenciais de autenticação global

Se não quiser fornecer credenciais para cada projeto em que trabalha, armazenar
as credenciais globalmente pode ser uma ideia melhor.
Essas credenciais são armazenadas em um arquivo `auth.json` global no diretório
[`COMPOSER_HOME`][10].

#### Editando as credenciais globais na linha de comando

É possível editar todos os métodos de autenticação usando a linha de comando:

- [http-basic][11]
- [Inline http-basic][12]
- [HTTP Bearer][13]
- [gitlab-oauth][14]
- [gitlab-token][15]
- [github-oauth][16]
- [bitbucket-oauth][17]

#### Editando manualmente as credenciais de autenticação global

> **Nota:** Não é recomendado editar manualmente as opções de autenticação, pois
> isso pode resultar em JSON inválido.
> Em vez disso, use preferencialmente [a linha de comando][18].

Para editá-las manualmente, execute o seguinte:

```shell
php composer.phar config --global --editor [--auth]
```

Para implementações de autenticação específicas, consulte suas seções:

- [http-basic][19]
- [Inline http-basic][20]
- [HTTP Bearer][21]
- [custom header][22]
- [gitlab-oauth][23]
- [gitlab-token][24]
- [github-oauth][25]
- [bitbucket-oauth][26]

Editar manualmente este arquivo em vez de usar a linha de comando pode resultar
em erros de JSON inválidos.
Para corrigir isso, é preciso abrir o arquivo em um editor e corrigir o erro.
Para encontrar a localização do arquivo `auth.json` global, execute:

```shell
php composer.phar config --global home
```

A pasta conterá o arquivo `auth.json` global, se ele existir.

É possível abrir esse arquivo em um editor e corrigir o erro.

### Autenticação no próprio arquivo `composer.json` {: #autenticacao-no-proprio-arquivo-composer-json }

> **Nota:** **Isso não é recomendado**, pois essas credenciais serão visíveis
> para qualquer pessoa com acesso ao `composer.json` quando ele for
> compartilhado por meio de um sistema de controle de versão como o git ou
> se um atacante obtiver acesso (leitura) aos arquivos do servidor de produção.

Também é possível adicionar credenciais a um `composer.json` por projeto na
seção `config` ou diretamente na definição do repositório.

### Autenticação usando a variável de ambiente `COMPOSER_AUTH` {: #autenticacao-usando-a-variavel-de-ambiente-composer-auth }

> **Nota:** Usar o método de variável de ambiente na linha de comando também tem
> implicações de segurança.
> Essas credenciais provavelmente serão armazenadas em memória e podem ser
> persistidas em um arquivo como `~/.bash_history` (Linux) ou
> `ConsoleHost_history.txt` (PowerShell no Windows) ao fechar a sessão.

A última opção para fornecer credenciais ao Composer é usar a variável de
ambiente `COMPOSER_AUTH`.
Essa variável pode ser passada como variável de linha de comando ou definida
como uma variável de ambiente real.
Leia mais sobre o uso desta variável de ambiente [aqui][27].

## Authentication methods

### http-basic

#### Command line http-basic

```shell
php composer.phar config [--global] http-basic.repo.example.org username password
```

In the above command, the config key `http-basic.repo.example.org` consists of two parts:

- `http-basic` is the authentication method.
- `repo.example.org` is the repository host name, you should replace it with the host name of your repository.

#### Manual http-basic

```shell
php composer.phar config [--global] --editor --auth
```

```json
{
  "http-basic": {
    "example.org": {
      "username": "username",
      "password": "password"
    }
  }
}
```

### Inline http-basic

For the inline http-basic authentication method the credentials are not stored in a separate
`auth.json` in the project or globally, but in the `composer.json` or global configuration
in the same place where the Composer repository definition is defined.

Make sure that the username and password are encoded according to [RFC 3986](http://www.faqs.org/rfcs/rfc3986.html) (
2.1. Percent-Encoding).
If the username e.g. is an email address it needs to be passed as `name%40example.com`.

#### Command line inline http-basic

```shell
php composer.phar config [--global] repositories composer.unique-name https://username:password@repo.example.org
```

#### Manual inline http-basic

```shell
php composer.phar config [--global] --editor
```

```json
{
  "repositories": [
    {
      "type": "composer",
      "url": "https://username:password@example.org"
    }
  ]
}
```

### HTTP Bearer

#### Command line HTTP Bearer authentication

```shell
php composer.phar config [--global] bearer.repo.example.org token
```

In the above command, the config key `bearer.repo.example.org` consists of two parts:

- `bearer` is the authentication method.
- `repo.example.org` is the repository host name, you should replace it with the host name of your repository.

#### Manual HTTP Bearer authentication

```shell
php composer.phar config [--global] --editor --auth
```

```json
{
  "bearer": {
    "example.org": "TOKEN"
  }
}
```

### Custom token authentication

#### Manual custom token authentication

```shell
php composer.phar config [--global] --editor
```

```json
{
  "repositories": [
    {
      "type": "composer",
      "url": "https://example.org",
      "options": {
        "http": {
          "header": [
            "API-TOKEN: YOUR-API-TOKEN"
          ]
        }
      }
    }
  ]
}
```

### gitlab-oauth

> **Nota:** For the gitlab authentication to work on private gitlab instances, the
> [`gitlab-domains`](../06-config.md#gitlab-domains) section should also contain the url.

#### Command line gitlab-oauth

```shell
php composer.phar config [--global] gitlab-oauth.gitlab.example.org token
```

In the above command, the config key `gitlab-oauth.gitlab.example.org` consists of two parts:

- `gitlab-oauth` is the authentication method.
- `gitlab.example.org` is the host name of your GitLab instance, you should replace it with the host name of your GitLab
  instance or use `gitlab.com` if you don't have a self-hosted GitLab instance.

#### Manual gitlab-oauth

```shell
php composer.phar config [--global] --editor --auth
```

```json
{
  "gitlab-oauth": {
    "example.org": "token"
  }
}
```

### gitlab-token

> **Nota:** For the gitlab authentication to work on private gitlab instances, the
> [`gitlab-domains`](../06-config.md#gitlab-domains) section should also contain the url.

To create a new access token, go to
your [access tokens section on GitLab](https://gitlab.com/-/profile/personal_access_tokens)
(or the equivalent URL on your private instance) and create a new token. See
also [the GitLab access token documentation](https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html#creating-a-personal-access-token)
for more information.

When creating a gitlab token manually, make sure it has either the `read_api` or `api` scope.

#### Command line gitlab-token

```shell
php composer.phar config [--global] gitlab-token.gitlab.example.org token
```

In the above command, the config key `gitlab-token.gitlab.example.org` consists of two parts:

- `gitlab-token` is the authentication method.
- `gitlab.example.org` is the host name of your GitLab instance, you should replace it with the host name of your GitLab
  instance or use `gitlab.com` if you don't have a self-hosted GitLab instance.

#### Manual gitlab-token

```shell
php composer.phar config [--global] --editor --auth
```

```json
{
  "gitlab-token": {
    "example.org": "token"
  }
}
```

### github-oauth

To create a new access token, head to your [token settings section on Github](https://github.com/settings/tokens)
and [generate a new token](https://github.com/settings/tokens/new).

For public repositories when rate limited, a token *without* any particular scope is sufficient (see `(no scope)` in
the [scopes documentation](https://docs.github.com/en/developers/apps/building-oauth-apps/scopes-for-oauth-apps)). Such
tokens grant read-only access to public information.

For private repositories, the `repo` scope is needed. Note that the token will be given broad read/write access to all
of your private repositories and much more - see
the [scopes documentation](https://docs.github.com/en/developers/apps/building-oauth-apps/scopes-for-oauth-apps) for a
complete list. As of writing (November 2021), it seems not to be possible to further limit permissions for such tokens.

Read more
about [Personal Access Tokens](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token),
or subscribe to the [roadmap item for better scoped tokens in GitHub](https://github.com/github/roadmap/issues/184).

#### Command line github-oauth

```shell
php composer.phar config [--global] github-oauth.github.com token
```

In the above command, the config key `github-oauth.github.com` consists of two parts:

- `github-oauth` is the authentication method.
- `github.com` is the host name for which this token applies. For GitHub you most likely do not need to change this.

#### Manual github-oauth

```shell
php composer.phar config [--global] --editor --auth
```

```json
{
  "github-oauth": {
    "github.com": "token"
  }
}
```

### bitbucket-oauth

The BitBucket driver uses OAuth to access your private repositories via the BitBucket REST APIs, and you will need to
create an OAuth consumer to use the driver, please refer
to [Atlassian's Documentation](https://support.atlassian.com/bitbucket-cloud/docs/use-oauth-on-bitbucket-cloud/). You
will need to fill the callback url with something to satisfy BitBucket, but the address does not need to go anywhere and
is not used by Composer.

#### Command line bitbucket-oauth

```shell
php composer.phar config [--global] bitbucket-oauth.bitbucket.org consumer-key consumer-secret
```

In the above command, the config key `bitbucket-oauth.bitbucket.org` consists of two parts:

- `bitbucket-oauth` is the authentication method.
- `bitbucket.org` is the host name for which this token applies. Unless you have a private instance you don't need to
  change this.

#### Manual bitbucket-oauth

```shell
php composer.phar config [--global] --editor --auth
```

```json
{
  "bitbucket-oauth": {
    "bitbucket.org": {
      "consumer-key": "key",
      "consumer-secret": "secret"
    }
  }
}
```

[1]: handling-private-packages.md
[2]: #http-basic
[3]: #inline-http-basic
[4]: #http-bearer
[5]: #custom-token-authentication
[6]: #gitlab-oauth
[7]: #gitlab-token
[8]: #github-oauth
[9]: #bitbucket-oauth
[10]: ../cli.md#composer-home
[11]: #command-line-http-basic
[12]: #command-line-inline-http-basic
[13]: #http-bearer
[14]: #command-line-gitlab-oauth
[15]: #command-line-gitlab-token
[16]: #command-line-github-oauth
[17]: #command-line-bitbucket-oauth
[18]: #editando-as-credenciais-globais-na-linha-de-comando
[19]: #manual-http-basic
[20]: #manual-inline-http-basic
[21]: #http-bearer
[22]: #manual-custom-token-authentication
[23]: #manual-gitlab-oauth
[24]: #manual-gitlab-token
[25]: #manual-github-oauth
[26]: #manual-bitbucket-oauth
[27]: ../cli.md#composer-auth
