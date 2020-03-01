# Config

Este capítulo descreve a seção `config` do [esquema][schema] do `composer.json`.

## process-timeout

O padrão é `300`. A duração que processos como `git clone` podem ser executados
antes que o Composer assuma que eles morreram. Pode ser necessário aumentar isso
se você tiver uma conexão lenta ou grandes vendors.

Para desabilitar o tempo limite do processo em um comando personalizado em
`scripts`, um auxiliar estático está disponível:

```json
{
    "scripts": {
        "test": [
            "Composer\\Config::disableProcessTimeout",
            "phpunit"
        ]
    }
}
```

## use-include-path

O padrão é `false`. Se `true`, o autoloader do Composer também procurará classes
no `include_path` do PHP.

## preferred-install

O padrão é `auto` e pode ser `source`, `dist` ou `auto`. Essa opção permite
definir o método de instalação que o Composer usará preferencialmente.
Opcionalmente, pode ser um hash de padrões para preferências de instalação mais
granulares.

```json
{
    "config": {
        "preferred-install": {
            "minha-organizacao/pacote-estavel": "dist",
            "minha-organizacao/*": "source",
            "organizacao-parceira/*": "auto",
            "*": "dist"
        }
    }
}
```

> **Nota:** A ordem importa. Padrões mais específicos devem vir antes de padrões
> mais relaxados. Ao misturar a notação de string com a configuração de hash nas
> configurações global e de pacote, a notação de string é convertida em um
> padrão de pacote `*`.

## store-auths

O que fazer depois de solicitar a autenticação, uma das seguintes opções: `true`
(sempre armazenar), `false` (não armazenar) e `prompt` (perguntar sempre), o
padrão é `prompt`.

## github-protocols

O padrão é `["https", "ssh", "git"]`. Uma lista de protocolos a serem usados ao
clonar de github.com, em ordem de prioridade. Por padrão, `git` está presente,
mas apenas se [secure-http][secure-http] estiver desabilitada, pois o protocolo
git não é criptografado. Se você deseja que as URLs de push do seu repositório
remoto `origin` usem https e não ssh (`git@github.com:...`), defina a lista de
protocolos como somente `["https"]` e o Composer parará de substituir a URL de
push por uma URL ssh.

## github-oauth

Uma lista de nomes de domínio e chaves OAuth. Por exemplo, ao usar
`{"github.com": "token-oauth"}` como valor desta opção, `token-oauth` será usado
para acessar repositórios privados no GitHub e contornar a baixa limitação de
uso baseada em IP da API deles. [Leia mais][art-troubleshooting] sobre como
obter um token OAuth para o GitHub.

## gitlab-oauth

Uma lista de nomes de domínio e chaves OAuth. Por exemplo, ao usar
`{"gitlab.com": "token-oauth"}` como valor desta opção, `token-oauth` será usado
para acessar repositórios privados no GitLab. Note que, se o pacote não estiver
hospedado em gitlab.com, os nomes de domínio também devem ser especificados com
a opção [`gitlab-domains`][gitlab-domains].

## gitlab-token

Uma lista de nomes de domínio e tokens privados. Por exemplo, ao usar
`{"gitlab.com": "token-privado"}` como valor desta opção, `token-privado` será
usado para acessar repositórios privados no GitLab. Note que, se o pacote não
estiver hospedado em gitlab.com, os nomes de domínio também devem ser
especificados com a opção [`gitlab-domains`][gitlab-domains].

## disable-tls

O padrão é `false`. Se definida como `true`, todas as URLs HTTPS serão acessadas
com HTTP e nenhuma criptografia no nível de rede será usada. Habilitar esta
opção é um risco à segurança e NÃO é recomendado. A melhor maneira é habilitar a
extensão `php_openssl` no `php.ini`.

## secure-http

O padrão é `true`. Se definida como `true`, somente as URLs HTTPS poderão ser
baixadas pelo Composer. Se você realmente precisa de acesso HTTP a alguma coisa,
pode desabilitá-la, mas usar o [Let's Encrypt][letsencrypt] para obter um
certificado SSL gratuito geralmente é uma alternativa melhor.

## bitbucket-oauth

Uma lista de nomes de domínio e consumidores. Por exemplo, usando
`{"bitbucket.org": {"consumer-key": "minha-chave", "consumer-secret": "meu-segredo"}}`.
[Leia][atlassian-oauth] sobre como configurar um consumidor no Bitbucket.

## cafile

Localização do arquivo da Autoridade de Certificação no sistema de arquivos
local. No PHP 5.6+, você deve definir isso via `openssl.cafile` no `php.ini`,
embora o PHP 5.6+ possa detectar o arquivo CA do sistema automaticamente.

## capath

Se `cafile` não for especificado ou se o certificado não for encontrado lá, o
diretório apontado por `capath` será usado para procurar um certificado
adequado. `capath` deve ser um diretório de certificado com hash correto.

## http-basic

Uma lista de nomes de domínios e usuários/senhas com os quais se autenticar
nesses domínios. Por exemplo, usar
`{"exemplo.org.br": {"username": "alice", "password": "foo"}}` como valor desta
opção permitirá que o Composer se autentique em exemplo.org.br.

> **Nota:** Opções de configuração relacionadas à autenticação, como
> `http-basic` e `github-oauth`, também podem ser especificadas em um arquivo
> `auth.json` que fica junto ao seu arquivo `composer.json`. Dessa forma, você
> pode adicioná-lo ao `.gitignore` e cada desenvolvedor pode colocar suas
> próprias credenciais lá.

## platform

Permite simular pacotes de plataforma (PHP e extensões) para que você possa
emular um ambiente de produção ou definir sua plataforma de destino na
configuração. Exemplo: `{"php": "7.0.3", "ext-alguma-coisa": "4.0.3"}`.

## vendor-dir

O padrão é `vendor`. Você pode instalar dependências em um diretório diferente,
se desejar. `$HOME` e `~` serão substituídos pelo caminho do seu diretório
inicial em `vendor-dir` e todas as opções `*-dir` abaixo.

## bin-dir

O padrão é `vendor/bin`. Se um projeto incluir binários, serão criados links
simbólicos para eles neste diretório.

## data-dir

O padrão é `C:\Users\<usuario>\AppData\Roaming\Composer` no Windows,
`$XDG_DATA_HOME/composer` em sistemas \*nix que seguem as Especificações de
Diretório Base do XDG e `$HOME` em outros sistemas \*nix. No momento, é usada
apenas para armazenar arquivos `composer.phar` anteriores para poder reverter
para versões mais antigas. Veja também [COMPOSER_HOME][cli-composer-home].

## cache-dir

O padrão é `C:\Users\<usuario>\AppData\Local\Composer` no Windows,
`$XDG_CACHE_HOME/composer` em sistemas \*nix que seguem as Especificações de
Diretório Base do XDG e `$HOME/cache` em outros sistemas \*nix. Armazena todos
os caches usados pelo Composer. Veja também [COMPOSER_HOME][cli-composer-home].

## cache-files-dir

O padrão é `$cache-dir/files`. Armazena os arquivos zip dos pacotes.

## cache-repo-dir

O padrão é `$cache-dir/repo`. Armazena os metadados dos repositórios do tipo
`composer` e os repositórios VCS dos tipos `svn`, `fossil`, `github` e
`bitbucket`.

## cache-vcs-dir

O padrão é `$cache-dir/vcs`. Armazena clones VCS para carregar os metadados de
repositórios VCS dos tipos `git`/`hg` e acelerar as instalações.

## cache-files-ttl

O padrão é `15552000` (6 meses). O Composer armazena em cache todos os pacotes
`dist` (zip, tar, ...) que ele baixa. Por padrão, eles são eliminados após seis
meses sem serem utilizados. Esta opção permite ajustar essa duração (em
segundos) ou desabilitá-la completamente, definindo-a como `0`.

## cache-files-maxsize

O padrão é `300MiB`. O Composer armazena em cache todos os pacotes `dist` (zip,
tar, ...) que ele baixa. Quando a coleta de lixo é executada periodicamente,
esse é o tamanho máximo que o cache poderá usar. Os arquivos mais antigos (menos
usados) serão removidos primeiro até que o cache se ajuste a esse tamanho.

## bin-compat

O padrão é `auto`. Determina a compatibilidade dos binários a serem instalados.
Se for `auto`, o Composer instala apenas arquivos proxy .bat quando no Windows.
Se definida como `full`, os arquivos .bat para o Windows e scripts para sistemas
operacionais baseados em Unix serão instalados para cada binário. Isso é útil
principalmente se você executar o Composer dentro de uma VM Linux, mas ainda
desejar ter os proxies .bat disponíveis para usar no Windows do host.

## prepend-autoloader

O padrão é `true`. Se `false`, o autoloader do Composer não será adicionado
antes dos autoloaders existentes. Às vezes, isso é necessário para corrigir
erros de interoperabilidade com outros autoloaders.

## autoloader-suffix

O padrão é `null`. String a ser usada como sufixo pelo autoloader gerado pelo
Composer. Quando `null`, um sufixo aleatório será gerado.

## optimize-autoloader

O padrão é `false`. Se `true`, sempre otimizará ao fazer o dump do autoloader.

## sort-packages

O padrão é `false`. Se `true`, o comando `require` manterá os pacotes ordenados
por nome no `composer.json` ao adicionar um novo pacote.

## classmap-authoritative

O padrão é `false`. Se `true`, o autoloader do Composer carregará apenas classes
do mapa de classes. Implica `optimize-autoloader`.

## apcu-autoloader

O padrão é `false`. Se `true`, o autoloader do Composer procurará pela extensão
APCu e a usará para armazenar em cache as classes encontradas/não encontradas
quando ela estiver habilitada.

## github-domains

O padrão é `["github.com"]`. Uma lista de domínios a serem usados no modo
GitHub. Isso é usado para instalações do GitHub Enterprise.

## github-expose-hostname

O padrão é `true`. Se `false`, os tokens OAuth criados para acessar a API do
GitHub terão uma data em vez do hostname da máquina.

## gitlab-domains

O padrão é `["gitlab.com"]`. Uma lista de domínios de servidores GitLab. Isso é
usado se você usar o tipo de repositório `gitlab`.

## use-github-api

O padrão é `true`. Semelhante à chave `no-api` em um repositório específico,
definir `use-github-api` como `false` definirá o comportamento global para todos
os repositórios GitHub para clonar o repositório como clonaria qualquer outro
repositório git, em vez de usar a API do GitHub. Mas, em vez de usar o driver
`git` diretamente, o Composer ainda tentará usar os arquivos zip do GitHub.

## notify-on-install

O padrão é `true`. O Composer permite que repositórios definam uma URL de
notificação, para que sejam notificados sempre que um pacote desse repositório
for instalado. Esta opção permite desabilitar esse comportamento.

## discard-changes

O padrão é `false` e pode ser `true`, `false` ou `stash`. Esta opção permite
definir a forma padrão de lidar com atualizações sujas quando em modo não
interativo. `true` sempre descartará as alterações em vendors, enquanto `stash`
tentará fazer o stash e reaplicar. Use isso para servidores de CI ou scripts de
implantação se você tende a ter vendors modificados.

## archive-format

O padrão é `tar`. O Composer permite adicionar um formato de arquivo padrão
quando o fluxo de trabalho precisa criar um formato de arquivo dedicado.

## archive-dir

O padrão é `.`. O Composer permite adicionar um diretório de arquivo padrão
quando o fluxo de trabalho precisa criar um formato de arquivo dedicado. Ou para
um desenvolvimento mais fácil entre os módulos.

Exemplo:

```json
{
    "config": {
        "archive-dir": "/home/<usuario>/.composer/repo"
    }
}
```

## htaccess-protect

O padrão é `true`. Se definida como `false`, O Composer não criará arquivos
`.htaccess` nos diretórios inicial, de cache e de dados do Composer.

[Community](07-community.md) &rarr;

[art-troubleshooting]: artigos/troubleshooting.md#api-rate-limit-and-oauth-tokens
[atlassian-oauth]: https://confluence.atlassian.com/bitbucket/oauth-on-bitbucket-cloud-238027431.html
[cli-composer-home]: cli.md#composer-home
[gitlab-domains]: #gitlab-domains
[letsencrypt]: https://letsencrypt.org/
[schema]: esquema.md
[secure-http]: #secure-http
