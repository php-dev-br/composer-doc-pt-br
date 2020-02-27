# Repositórios

Este capítulo explicará o conceito de pacotes e repositórios, que tipos de
repositórios estão disponíveis e como eles funcionam.

## Conceitos

Antes de examinarmos os diferentes tipos de repositórios existentes, precisamos
entender alguns dos conceitos básicos sobre os quais o Composer é construído.

### Pacote

O Composer é um gerenciador de dependências. Ele instala pacotes localmente. Um
pacote é essencialmente um diretório que contém alguma coisa. Nesse caso, código
PHP, mas em teoria poderia ser qualquer coisa. E ele contém uma descrição do
pacote que possui um nome e uma versão. O nome e a versão são usados para
identificar o pacote.

De fato, internamente o Composer vê cada versão como um pacote separado. Embora
essa distinção não importe quando você estiver usando o Composer, ela é muito
importante quando você quiser alterar o pacote.

Além do nome e da versão, existem metadados úteis. A informação mais relevante
para a instalação é a definição da fonte, que descreve onde obter o conteúdo do
pacote. Os dados do pacote apontam para o conteúdo do pacote. E há duas opções
aqui: `dist` e `source`.

**Dist:** é uma versão empacotada dos dados do pacote. Geralmente é uma versão
publicada, normalmente é uma versão estável.

**Source:** é usada para desenvolvimento. Ela geralmente se origina de um
repositório de código-fonte, como o git. Você pode obter o código-fonte quando
quiser modificar o pacote baixado.

Os pacotes podem fornecer uma dessas ou até mesmo as duas. Dependendo de certos
fatores, como as opções fornecidas pela pessoa e a estabilidade do pacote, uma
delas terá a preferência.

### Repositório

Um repositório é uma fonte de pacotes. É uma lista de pacotes/versões. O
Composer procurará em todos os seus repositórios para encontrar os pacotes que
seu projeto exige.

Por padrão, apenas o repositório Packagist está registrado no Composer. Você
pode adicionar mais repositórios ao seu projeto declarando-os no
`composer.json`.

Os repositórios estão disponíveis apenas para o pacote raiz e os repositórios
definidos em suas dependências não serão carregados. Leia a [FAQ]
[faq-recursive-repos] se quiser saber o porquê.

## Tipos

### composer

O principal tipo de repositório é o repositório `composer`. Ele usa um único
arquivo `packages.json` que contém todos os metadados dos pacotes.

Este também é o tipo de repositório que o Packagist usa. Para referenciar um
repositório `composer`, forneça o caminho antes do arquivo `packages.json`. No
caso do Packagist, esse arquivo está localizado em `/packages.json`, portanto, a
URL do repositório seria `repo.packagist.org`. Para
`exemplo.org.br/packages.json`, a URL do repositório seria `exemplo.org.br`.

#### packages

O único campo obrigatório é `packages`. A estrutura JSON é a seguinte:

```json
{
    "packages": {
        "vendor/nome-pacote": {
            "dev-master": { @composer.json },
            "1.0.x-dev": { @composer.json },
            "0.0.1": { @composer.json },
            "1.0.0": { @composer.json }
        }
    }
}
```

O marcador `@composer.json` seria o conteúdo do `composer.json` dessa versão do
pacote, incluindo no mínimo:

* `name`
* `version`
* `dist` ou `source`

Aqui está uma definição mínima de pacote:

```json
{
    "name": "smarty/smarty",
    "version": "3.1.7",
    "dist": {
        "url": "https://www.smarty.net/files/Smarty-3.1.7.zip",
        "type": "zip"
    }
}
```

Ela pode incluir qualquer um dos outros campos especificados no [esquema]
[schema].

#### notify-batch

O campo `notify-batch` permite especificar uma URL que será chamada sempre que
alguém instalar um pacote. A URL pode ser um caminho absoluto (que usará o mesmo
domínio que o repositório) ou uma URL completamente qualificada.

Um exemplo de valor:

```json
{
    "notify-batch": "/downloads/"
}
```

Para `exemplo.org.br/packages.json` contendo um pacote `monolog/monolog`, isso
enviaria uma requisição `POST` para `exemplo.org.br/downloads/` com o seguinte
corpo da requisição JSON:

```json
{
    "downloads": [
        {"name": "monolog/monolog", "version": "1.2.1.0"}
    ]
}
```

O campo `version` conterá a representação normalizada do número da versão.

Este campo é opcional.

#### provider-includes e providers-url

O campo `provider-includes` permite listar um conjunto de arquivos que listam
nomes de pacotes fornecidos por este repositório. Nesse caso, o hash deve ser um
sha256 dos arquivos.

O campo `providers-url` descreve como os arquivos do provedor são encontrados no
servidor. É um caminho absoluto da raiz do repositório. Deve conter os
placeholders `%package%` e `%hash%`.

Um exemplo:

```json
{
    "provider-includes": {
        "providers-a.json": {
            "sha256": "f5b4bc0b354108ef08614e569c1ed01a2782e67641744864a74e788982886f4c"
        },
        "providers-b.json": {
            "sha256": "b38372163fac0573053536f5b8ef11b86f804ea8b016d239e706191203f6efac"
        }
    },
    "providers-url": "/p/%package%$%hash%.json"
}
```

Esses arquivos contêm listas de nomes de pacotes e hashes para verificar a
integridade do arquivo, por exemplo:

```json
{
    "providers": {
        "acme/foo": {
            "sha256": "38968de1305c2e17f4de33aea164515bc787c42c7e2d6e25948539a14268bb82"
        },
        "acme/bar": {
            "sha256": "4dd24c930bd6e1103251306d6336ac813b563a220d9ca14f4743c032fb047233"
        }
    }
}
```

O arquivo acima declara que `acme/foo` e `acme/bar` podem ser encontrados neste
repositório, carregando o arquivo referenciado por `providers-url`, substituindo
`%package%` pelo nome do pacote com o nome do vendor e `%hash%` pelo campo
`sha256`. Esses arquivos contêm definições de pacotes, conforme descrito [acima]
[packages].

Estes campos são opcionais. Você provavelmente não precisa deles para seu
próprio repositório personalizado.

#### Opções de Stream

O arquivo `packages.json` é carregado usando um stream PHP. Você pode definir
opções extras para esse stream usando o parâmetro `options`. Você pode definir
qualquer opção de contexto de stream PHP válida. Consulte [Opções e parâmetros
de contexto][php-context] para obter mais informações.

### VCS

VCS significa sistema de controle de versão. Isso inclui sistemas de
versionamento como git, svn, fossil ou hg. O Composer possui um tipo de
repositório para instalar pacotes desses sistemas.

#### Carregando um Pacote de um Repositório VCS

Existem alguns casos de uso para isso. O mais comum é manter seu próprio fork de
uma biblioteca de terceiros. Se você estiver usando uma determinada biblioteca
para seu projeto e decidir alterar algo na biblioteca, desejará que seu projeto
use a versão alterada. Se a biblioteca estiver no GitHub (esse é o caso na
maioria das vezes), você pode simplesmente fazer o fork dela lá e fazer o push
das suas alterações para o seu fork. Depois disso, você atualiza o
`composer.json` do projeto. Tudo que você precisa fazer é adicionar seu fork
como um repositório e atualizar a restrição de versão para apontar para seu
branch personalizado. No `composer.json`, você deve prefixar o nome do seu
branch personalizado com `dev-`. Para convenções de nomenclatura de restrições
de versão, consulte [Bibliotecas][libraries] para obter mais informações.

Exemplo assumindo que você alterou o monolog para corrigir um erro no branch
`bugfix`:

```json
{
    "repositories": [
        {
            "type": "vcs",
            "url": "https://github.com/igorw/monolog"
        }
    ],
    "require": {
        "monolog/monolog": "dev-bugfix"
    }
}
```

Quando você executar `php composer.phar update`, você deve obter sua versão
modificada do `monolog/monolog` em vez da versão do Packagist.

Observe que você não deve renomear o pacote, a menos que realmente pretenda
fazer o fork do projeto a longo prazo e se afastar completamente do pacote
original. O Composer selecionará seu pacote corretamente no lugar do original,
já que o repositório personalizado tem prioridade sobre o Packagist. Se você
deseja renomear o pacote, deve fazê-lo no branch padrão (geralmente `master`) e
não no feature branch, pois o nome do pacote é obtido do branch padrão.

Observe também que a substituição não funcionará se você alterar a propriedade
`name` no arquivo `composer.json` do repositório criado pelo fork, pois ela
precisa corresponder à original para a substituição funcionar.

Se outra dependência depender do pacote criado pelo fork, é possível adicionar
um alias em linha para que ela corresponda a uma restrição que, de outra forma,
ela não iria. Para obter mais informações, [consulte o artigo sobre aliases]
[art-aliases].

#### Usando Repositórios Privados

Exatamente a mesma solução permite que você trabalhe com seus repositórios
privados no GitHub e BitBucket:

```json
{
    "require": {
        "vendor/meu-repo-privado": "dev-master"
    },
    "repositories": [
        {
            "type": "vcs",
            "url":  "git@bitbucket.org:vendor/meu-repo-privado.git"
        }
    ]
}
```

O único requisito é a instalação de chaves SSH para um cliente git.

#### Alternativas ao Git

Git não é o único sistema de controle de versão suportado pelo repositório VCS.
Os seguintes são suportados:

* **Git:** [git-scm.com][vcs-git]
* **Subversion:** [subversion.apache.org][vcs-svn]
* **Mercurial:** [mercurial-scm.org][vcs-hg]
* **Fossil**: [fossil-scm.org][vcs-fossil]

Para obter pacotes desses sistemas, você precisa ter seus respectivos clientes
instalados. Isso pode ser inconveniente. E por esse motivo, há suporte especial
ao GitHub e BitBucket que usa as APIs fornecidas por esses sites para buscar os
pacotes sem precisar instalar o sistema de controle de versão. O repositório VCS
fornece opções `dist` para eles que buscam os pacotes como arquivos zip.

* **GitHub:** [github.com][github] (Git)
* **BitBucket:** [bitbucket.org][bitbucket] (Git e Mercurial)

O driver VCS a ser usado é detectado automaticamente com base na URL.
Entretanto, se você precisar especificar um por qualquer motivo, poderá usar
`git-bitbucket`, `hg-bitbucket`, `github`, `gitlab`, `perforce`, `fossil`,
`git`, `svn` ou `hg` como o tipo de repositório em vez de `vcs`.

Se você definir a chave `no-api` como `true` em um repositório `github`, clonará
o repositório como faria com qualquer outro repositório git, em vez de usar a
API do GitHub. Porém, diferente de usar o driver `git` diretamente, o Composer
ainda tentará usar os arquivos zip do GitHub.

Note que:

* **Para permitir que o Composer escolha qual driver usar**, o tipo de
  repositório precisa ser definido como `vcs`;
* **Se você já usou um repositório privado**, isso significa que o Composer deve
  ter clonado ele no cache. Se você deseja instalar o mesmo pacote com drivers,
  lembre-se de executar o comando `composer clearcache` seguido do comando
  `composer update` para atualizar o cache do Composer e instalar o pacote a
  partir de `dist`.

#### Configuração do Driver do BitBucket

O driver do BitBucket usa OAuth para acessar seus repositórios privados por meio
das APIs REST do BitBucket e você precisará criar um consumidor OAuth para usar
o driver, consulte a [Documentação da Atlassian][bitbucket-oauth]. Você
precisará preencher a URL de callback com algo para satisfazer o BitBucket, mas
o endereço não precisa ir a lugar algum e não é usado pelo Composer.

Depois de criar um consumidor OAuth no painel de controle do BitBucket, você
precisa configurar o arquivo `auth.json` com as credenciais desta forma (mais
informações [aqui][config-bitbucket]):

```json
{
    "bitbucket-oauth": {
        "bitbucket.org": {
            "consumer-key": "minha-chave",
            "consumer-secret": "meu-segredo"
        }
    }
}
```

**Observe que o endpoint do repositório precisa ser `https` em vez de `git`.**

Como alternativa, se você preferir não ter suas credenciais OAuth em seu sistema
de arquivos, poderá exportar o bloco `bitbucket-oauth` acima para a variável de
ambiente [COMPOSER_AUTH][composer-auth].

#### Opções do Subversion

Como o Subversion não possui um conceito nativo de branches e tags, o Composer
assume por padrão que o código está localizado em `$url/trunk`, `$url/branches`
e `$url/tags`. Se seu repositório tiver um layout diferente, você poderá alterar
esses valores. Por exemplo, se você usasse nomes com iniciais em maiúsculas,
poderia configurar o repositório desta forma:

```json
{
    "repositories": [
        {
            "type": "vcs",
            "url": "http://svn.exemplo.org.br/projeto-a/",
            "trunk-path": "Trunk",
            "branches-path": "Branches",
            "tags-path": "Tags"
        }
    ]
}
```

Se você não tiver um diretório `branches` ou `tags`, poderá desabilitá-los
completamente definindo `branches-path` ou `tags-path` como `false`.

Se o pacote estiver em um subdiretório, por exemplo,
`/trunk/foo/bar/composer.json` e `/tags/1.0/foo/bar/composer.json`, você pode
fazer o Composer acessá-lo definindo a opção `package-path` com o subdiretório,
nesse exemplo seria `"package-path": "foo/bar/"`.

Se você possui um repositório Subversion privado, pode salvar as credenciais na
seção `http-basic` da sua configuração (consulte [Esquema][schema]):

```json
{
    "http-basic": {
        "svn.exemplo.org.br": {
            "username": "usuario",
            "password": "senha"
        }
    }
}
```

Se o seu cliente Subversion estiver configurado para armazenar credenciais por
padrão, essas credenciais serão salvas para o usuário atual e as credenciais
salvas anteriormente para esse servidor serão substituídas. Você pode alterar
esse comportamento definindo a opção `svn-cache-credentials` como `false` na
configuração do seu repositório:

```json
{
    "repositories": [
        {
            "type": "vcs",
            "url": "http://svn.exemplo.org.br/projeto-a/",
            "svn-cache-credentials": false
        }
    ]
}
```

### PEAR

É possível instalar pacotes de qualquer canal PEAR usando o repositório `pear`.
O Composer prefixará todos os nomes de pacotes com `pear-{NomeCanal}/` para
evitar conflitos. Todos os pacotes também têm alias com o prefixo
`pear-{AliasCanal}/`.

Exemplo usando `pear2.php.net`:

```json
{
    "repositories": [
        {
            "type": "pear",
            "url": "https://pear2.php.net"
        }
    ],
    "require": {
        "pear-pear2.php.net/PEAR2_Text_Markdown": "*",
        "pear-pear2/PEAR2_HTTP_Request": "*"
    }
}
```

Nesse caso, o nome abreviado do canal é `pear2`, portanto, o nome do pacote
`PEAR2_HTTP_Request` se torna `pear-pear2/PEAR2_HTTP_Request`.

> **Nota:** O repositório `pear` requer várias requisições por pacote, portanto,
> isso pode retardar consideravelmente o processo de instalação.

#### Alias de Vendor Personalizado

É possível criar um alias de pacotes de canais PEAR com um nome de vendor
personalizado.

Exemplo:

Suponha que você tenha um repositório PEAR privado e deseje usar o Composer para
incorporar dependências de um VCS. Seu repositório PEAR contém os seguintes
pacotes:

 * `PacoteBase`
 * `PacoteIntermediario`, que depende do `PacoteBase`
 * `PacoteDeAltoNivel1` e `PacoteDeAltoNivel2`, que dependem do
   `PacoteIntermediario`

Sem um alias de vendor, o Composer usará o nome do canal PEAR como a parte do
vendor no nome do pacote:

 * `pear-pear.foobar.repo/PacoteBase`
 * `pear-pear.foobar.repo/PacoteIntermediario`
 * `pear-pear.foobar.repo/PacoteDeAltoNivel1`
 * `pear-pear.foobar.repo/PacoteDeAltoNivel2`

Suponha que posteriormente você deseje migrar seus pacotes PEAR para um esquema
de nomenclatura e repositório do Composer e adote o nome de vendor `foobar`.
Os projetos que usam seus pacotes PEAR não veriam os pacotes atualizados, pois
eles têm um nome de vendor diferente (`foobar/PacoteIntermediario` vs.
`pear-pear.foobar.repo/PacoteIntermediario`).

Ao especificar `vendor-alias` para o repositório PEAR desde o início, você pode
evitar esse cenário e proteger os nomes de seus pacotes de mudanças futuras.

Para ilustrar, o exemplo a seguir obteria os pacotes `PacoteBase`,
`PacoteDeAltoNivel1` e `PacoteDeAltoNivel2` do seu repositório PEAR e o
`PacoteIntermediario` de um repositório do GitHub:

```json
{
    "repositories": [
        {
            "type": "git",
            "url": "https://github.com/foobar/intermediario.git"
        },
        {
            "type": "pear",
            "url": "http://pear.foobar.repo",
            "vendor-alias": "foobar"
        }
    ],
    "require": {
        "foobar/PacoteDeAltoNivel1": "*",
        "foobar/PacoteDeAltoNivel2": "*"
    }
}
```

### Package

Se você deseja usar um projeto que não oferece suporte ao Composer por qualquer
um dos meios acima, você mesmo ainda pode definir o pacote usando um repositório
`package`.

Basicamente, você define as mesmas informações incluídas no `packages.json` do
repositório `composer`, mas apenas para um único pacote. Novamente, os campos
mínimos necessários são `name`, `version` e `dist` ou `source`.

Aqui está um exemplo para o mecanismo de template Smarty:

```json
{
    "repositories": [
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
                    "url": "http://smarty-php.googlecode.com/svn/",
                    "type": "svn",
                    "reference": "tags/Smarty_3_1_7/distribution/"
                },
                "autoload": {
                    "classmap": ["libs/"]
                }
            }
        }
    ],
    "require": {
        "smarty/smarty": "3.1.*"
    }
}
```

Normalmente, você não incluiria a parte `source`, pois realmente não precisa
dela.

> **Nota**: Esse tipo de repositório possui algumas limitações e deve ser
> evitado sempre que possível:
>
> - O Composer não atualizará o pacote, a menos que você altere o campo
>   `version`.
> - O Composer não atualizará as referências dos commits, portanto, se você usar
>   `master` como referência, terá que excluir o pacote para forçar uma
>   atualização e precisará lidar com um arquivo lock instável.

A chave `package` em um repositório `package` pode ser definida como um array
para definir várias versões de um pacote:

```json
{
    "repositories": [
        {
            "type": "package",
            "package": [
                {
                    "name": "foo/bar",
                    "version": "1.0.0",
                    ...
                },
                {
                    "name": "foo/bar",
                    "version": "2.0.0",
                    ...
                }
            ]
        }
    ]
}
```

## Hospedando Seu Próprio Repositório

Embora você provavelmente deseje colocar seus pacotes no Packagist na maioria
das vezes, existem alguns casos de uso para hospedar seu próprio repositório.

* **Pacotes de empresas privadas:** Se você faz parte de uma empresa que usa o
  Composer para seus pacotes internamente, convém manter esses pacotes privados.

* **Ecossistema separado:** Se você tem um projeto que possui seu próprio
  ecossistema e os pacotes não são realmente reutilizáveis pela imensa
  comunidade PHP, convém mantê-los separados do Packagist. Um exemplo disso
  seriam os plugins do WordPress.

Para hospedar seus próprios pacotes, é recomendado o tipo de repositório nativo
`composer`, que oferece o melhor desempenho.

Existem algumas ferramentas que podem te ajudar a criar um repositório
`composer`.

### Packagist Privado

[Packagist Privado][packagist] é uma aplicação hospedada ou com hospedagem
própria que fornece hospedagem de pacotes privados, além do espelhamento do
GitHub, Packagist.org e outros repositórios de pacotes.

Visite [Packagist.com][packagist] para obter mais informações.

### Satis

Satis é um gerador de repositórios `composer` estáticos. Parece um pouco com uma
versão ultra leve e estática do Packagist, baseada em arquivos.

Você fornece a ele um `composer.json` contendo repositórios, geralmente VCS, e
definições de repositórios de pacotes. Ele buscará todos os pacotes que estão em
`require` e fará o dump de um `packages.json`, que é o seu repositório
`composer`.

Verifique [o repositório do Satis no GitHub][github-satis] e o [artigo sobre o
Satis][art-satis] para obter mais informações.

### Artifact

Existem alguns casos em que não é possível ter online nenhum dos tipos de
repositório mencionados anteriormente, nem mesmo o VCS. Um exemplo típico pode
ser a troca de bibliotecas entre organizações através de artefatos construídos.
Claro, na maioria das vezes eles são privados. Para simplificar a manutenção,
pode-se simplesmente usar um repositório do tipo `artifact` com um diretório
contendo arquivos zip desses pacotes privados:

```json
{
    "repositories": [
        {
            "type": "artifact",
            "url": "caminho/para/o/diretorio/com/zips/"
        }
    ],
    "require": {
        "vendor-privado-um/core": "15.6.2",
        "vendor-privado-dois/connectivity": "*",
        "acme-corp/parser": "10.3.5"
    }
}
```

Cada artefato zip é um arquivo zip com um `composer.json` no diretório raiz:

```sh
unzip -l acme-corp-parser-10.3.5.zip

composer.json
...
```

Se houver dois arquivos com versões diferentes de um pacote, eles serão
importados. Quando um arquivo com uma versão mais recente for adicionado no
diretório de artefatos e você executar `update`, essa versão também será
importada e o Composer atualizará para a versão mais recente.

### Path

Além do repositório `artifact`, é possível usar o repositório `path`, que
permite depender de um diretório local, absoluto ou relativo. Isso pode ser
especialmente útil ao lidar com repositórios monolíticos.

Por exemplo, se você possui a seguinte estrutura de diretórios no seu
repositório:

```
apps
└── minha-aplicacao
    └── composer.json
pacotes
└── meu-pacote
    └── composer.json
```

Então, para adicionar o pacote `meu/pacote` como uma dependência, no arquivo
`apps/minha-aplicacao/composer.json`, você pode usar a seguinte configuração:

```json
{
    "repositories": [
        {
            "type": "path",
            "url": "../../pacotes/meu-pacote"
        }
    ],
    "require": {
        "meu/pacote": "*"
    }
}
```

Se o pacote for um repositório VCS local, a versão poderá ser inferida a partir
do branch ou tag do qual foi feito o checkout. Caso contrário, a versão deverá
ser explicitamente definida no arquivo `composer.json` do pacote. Se a versão
não puder ser resolvida por esses meios, presume-se que seja `dev-master`.

Se possível, será criado um link simbólico do pacote local; nesse caso a saída
no console exibirá `Symlinking from ../../pacotes/meu-pacote`. Se a criação do
link simbólico _não_ for possível, o pacote será copiado. Nesse caso, o console
exibirá `Mirrored from ../../pacotes/meu-pacote`.

Em vez da estratégia de fallback padrão, você pode forçar o uso do link
simbólico com a opção `"symlink": true` ou o espelhamento com a opção
`"symlink": false`. Forçar o espelhamento pode ser útil ao implantar ou gerar
pacotes a partir de um repositório monolítico.

> **Nota:** No Windows, os links simbólicos de diretório são implementados
> usando junções NTFS porque elas podem ser criadas por usuários não
> administradores. O espelhamento sempre será usado nas versões abaixo do
> Windows 7 ou se `proc_open` estiver desabilitado.

```json
{
    "repositories": [
        {
            "type": "path",
            "url": "../../pacotes/meu-pacote",
            "options": {
                "symlink": false
            }
        }
    ]
}
```

O til no início dos caminhos é expandido para a pasta inicial do usuário atual
e as variáveis de ambiente são processadas usando as notações do Windows e
Linux/Mac. Por exemplo, `~/git/meu-pacote` automaticamente carregará o clone de
`meu-pacote` de `/home/<usuario>/git/meu-pacote`, equivalente a
`$HOME/git/meu-pacote` ou `%USERPROFILE%/git/meu-pacote`.

> **Nota:** Caminhos de repositórios também podem conter curingas como `*` e
>`?`. Para mais detalhes, consulte a [função glob do PHP][php-glob].

## Desabilitando o Packagist.org

Você pode desabilitar o repositório padrão Packagist.org adicionando isto ao seu
`composer.json`:

```json
{
    "repositories": [
        {
            "packagist.org": false
        }
    ]
}
```

Você pode desabilitar o Packagist.org globalmente usando a flag de configuração
global:

```bash
composer config -g repo.packagist false
```

[Config](06-config.md) &rarr;

[art-aliases]: artigos/aliases.md
[art-satis]: artigos/handling-private-packages-with-satis.md
[bitbucket]: https://bitbucket.org
[bitbucket-oauth]: https://confluence.atlassian.com/bitbucket/oauth-on-bitbucket-cloud-238027431.html
[composer-auth]: cli.md#composer-auth
[config-bitbucket]: 06-config.md#bitbucket-oauth
[faq-recursive-repos]: faqs/why-can't-composer-load-repositories-recursively.md
[github]: https://github.com
[github-satis]: https://github.com/composer/satis
[libraries]: bibliotecas.md
[packages]: #packages
[packagist]: https://packagist.com/
[php-context]: https://www.php.net/manual/pt_BR/context.php
[php-glob]: https://php.net/glob
[schema]: esquema.md
[vcs-fossil]: https://www.fossil-scm.org/
[vcs-git]: https://git-scm.com
[vcs-hg]: https://www.mercurial-scm.org
[vcs-svn]: https://subversion.apache.org
