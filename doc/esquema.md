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
        "email": "suporte@exemplo.org.br",
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

#### require-dev <span>([root-only][root-package])</span> {: #require-dev }

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

Lista os pacotes que são substituídos por este pacote. Isso permite que você
faça o fork de um pacote, publique-o com um nome diferente com seus próprios
números de versão, enquanto os pacotes que exigem o pacote original continuam a
funcionar com o seu fork, pois ele substitui o pacote original.

Isso também é útil para pacotes que contêm subpacotes, por exemplo, o pacote
principal `symfony/symfony` contém todos os Componentes do Symfony que também
estão disponíveis como pacotes individuais. Se você exigir o pacote principal,
ele atenderá automaticamente a qualquer requisito de um dos componentes
individuais, uma vez que os substitui.

Recomenda-se cuidado ao usar `replace` para a finalidade de subpacote explicada
acima. Em geral, você deve substituir apenas usando `self.version` como uma
restrição de versão, para garantir que o pacote principal substitua apenas os
subpacotes desta versão exata e de nenhuma outra versão, o que seria incorreto.

#### provide

Lista de outros pacotes que são fornecidos por este pacote. Isso é útil
principalmente para interfaces comuns. Um pacote pode depender de algum pacote
virtual `logger` e qualquer biblioteca que implemente esta interface `logger`
simplesmente irá listá-la em `provide`.

#### suggest

Pacotes sugeridos que podem melhorar ou funcionar bem com este pacote. Eles são
informativos e são exibidos após a instalação do pacote, para dar às pessoas uma
dica de que elas poderiam adicionar mais pacotes, mesmo que não sejam
estritamente necessários.

O formato é como os links de pacotes acima, exceto que os valores são texto
livre e não restrições de versão.

Exemplo:

```json
{
    "suggest": {
        "monolog/monolog": "Permite o registro mais avançado de logging do fluxo da aplicação",
        "ext-xml": "Necessária para suportar o formato XML na classe Foo"
    }
}
```

### autoload

Mapeamento de autoload para um autoloader PHP.

O autoloading [`PSR-4`][php-psr4] e [`PSR-0`][php-psr0], a geração de `classmap`
e a inclusão de `files` são suportados.

PSR-4 é a maneira recomendada, pois oferece maior facilidade de uso (não é
necessário gerar o autoloader novamente ao adicionar classes).

#### PSR-4

Usando a chave `psr-4`, você define um mapeamento de namespaces para caminhos
relativos à raiz do pacote. Ao fazer o autoloading de uma classe como
`Foo\\Bar\\Baz`, um prefixo de namespace `Foo\\` apontando para um diretório
`src/` significa que o autoloader procurará por um arquivo chamado
`src/Bar/Baz.php` e o incluirá, se ele existir. Observe que, ao contrário do
antigo estilo PSR-0, o prefixo (`Foo\\`) **não** está presente no caminho do
arquivo.

Os prefixos de namespace devem terminar em `\\` para evitar conflitos entre
prefixos semelhantes. Por exemplo, `Foo` corresponderia às classes no namespace
`FooBar`, por isso as barras invertidas à direita resolvem o problema: `Foo\\`
e `FooBar\\` são distintos.

As referências PSR-4 são todas combinadas, durante a instalação/atualização, em
um único array associativo, que pode ser encontrado no arquivo
`vendor/composer/autoload_psr4.php` gerado.

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

Se você precisar procurar um mesmo prefixo em vários diretórios, poderá
especificá-los como um array como:

```json
{
    "autoload": {
        "psr-4": { "Monolog\\": ["src/", "lib/"] }
    }
}
```

Se você deseja ter um diretório alternativo onde qualquer namespace será
procurado, use um prefixo vazio como:

```json
{
    "autoload": {
        "psr-4": { "": "src/" }
    }
}
```

#### PSR-0

Usando a chave `psr-0`, você define um mapeamento de namespaces para caminhos
relativos à raiz do pacote. Observe que ele também suporta a convenção sem
namespaces do estilo PEAR.

Observe que as declarações de namespaces devem terminar em `\\` para garantir
que o autoloader responda precisamente. Por exemplo, `Foo` corresponderia a
`FooBar` então as barras invertidas à direita resolvem o problema: `Foo\\` e
`FooBar\\` são distintos.

As referências PSR-0 são todas combinadas, durante a instalação/atualização, em
um único array associativo, que pode ser encontrado no arquivo
`vendor/composer/autoload_namespaces.php` gerado.

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

Se você precisar procurar um mesmo prefixo em vários diretórios, poderá
especificá-los como um array como:

```json
{
    "autoload": {
        "psr-0": { "Monolog\\": ["src/", "lib/"] }
    }
}
```

O estilo PSR-0 não se limita apenas às declarações de namespace, mas pode ser
especificado até o nível da classe. Isso pode ser útil para bibliotecas com
apenas uma classe no namespace global. Se o arquivo-fonte PHP também estiver
localizado na raiz do pacote, por exemplo, ele poderá ser declarado assim:

```json
{
    "autoload": {
        "psr-0": { "ClasseGlobalUnica": "" }
    }
}
```

Se você deseja ter um diretório alternativo onde qualquer namespace será
procurado, use um prefixo vazio como:

```json
{
    "autoload": {
        "psr-0": { "": "src/" }
    }
}
```

#### Classmap

As referências em `classmap` são todas combinadas, durante a
instalação/atualização, em um único array associativo, que pode ser encontrado
no arquivo `vendor/composer/autoload_classmap.php` gerado. Esse mapa é
construído pesquisando por classes em todos os arquivos `.php` e `.inc` nos
diretórios/arquivos fornecidos.

Você pode usar o suporte à geração de mapa de classes para definir o autoloading
para todas as bibliotecas que não seguem as PSR-0/4. Para configurar isso, você
especifica todos os diretórios ou arquivos onde procurar por classes.

Exemplo:

```json
{
    "autoload": {
        "classmap": ["src/", "lib/", "AlgumaCoisa.php"]
    }
}
```

#### Files

Se você deseja exigir determinados arquivos explicitamente em todas as
requisições, pode usar o mecanismo de autoloading `files`. Ele é útil se seu
pacote incluir funções PHP que não podem ser carregadas automaticamente pelo PHP.

Exemplo:

```json
{
    "autoload": {
        "files": ["src/MinhaBiblioteca/funcoes.php"]
    }
}
```

#### Excluir Arquivos do Mapa de Classes

Se você deseja excluir alguns arquivos ou pastas do mapa de classes, use a
propriedade `exclude-from-classmap`. Isso pode ser útil para excluir as classes
de teste em seu ambiente ativo, por exemplo, pois elas serão omitidas do mapa
de classes, até mesmo ao criar um autoloader otimizado.

O gerador de mapa de classes ignorará todos os arquivos nos caminhos
configurados aqui. Os caminhos são absolutos no diretório raiz do pacote (ou
seja, o local do `composer.json`) e suportam `*` para corresponder a qualquer
coisa, exceto uma barra, e `**` para corresponder a qualquer coisa. `**` é
incluído implicitamente ao final dos caminhos.

Exemplo:

```json
{
    "autoload": {
        "exclude-from-classmap": ["/Tests/", "/test/", "/tests/"]
    }
}
```

#### Otimizando o Autoloader

O autoloader pode ter um impacto bastante substancial no tempo da requisição
(50-100ms por requisição em frameworks grandes usando muitas classes). Consulte
o [artigo sobre otimização do autoloader][art-autoloader] para obter mais
detalhes sobre como reduzir esse impacto.

### autoload-dev <span>([root-only][root-package])</span> {: #autoload-dev }

Esta seção permite definir regras de autoload para fins de desenvolvimento.

As classes necessárias para executar a suíte de testes não devem ser
incluídas nas regras principais de autoload para evitar poluir o autoloader em
produção e quando outras pessoas usarem seu pacote como uma dependência.

Portanto, é uma boa ideia contar com um caminho dedicado para seus testes
unitários e adicioná-lo na seção `autoload-dev`.

Exemplo:

```json
{
    "autoload": {
        "psr-4": { "MinhaBiblioteca\\": "src/" }
    },
    "autoload-dev": {
        "psr-4": { "MinhaBiblioteca\\Tests\\": "tests/" }
    }
}
```

### include-path

> **OBSOLETA**: Esta propriedade está presente apenas para oferecer suporte a
> projetos legados e todo código novo deve preferencialmente usar o autoloading.
> Como tal, é uma prática desaprovada, mas o recurso em si provavelmente não
> desaparecerá do Composer.

Uma lista de caminhos que devem ser anexados ao `include_path` do PHP.

Exemplo:

```json
{
    "include-path": ["lib/"]
}
```

Opcional.

### target-dir

> **OBSOLETA**: Esta propriedade está presente apenas para oferecer suporte ao
> autoloading no estilo PSR-0 legado e todo código novo deve preferencialmente
> usar a PSR-4 sem `target-dir` e os projetos usando a PSR-0 com namespaces PHP
> são encorajados a migrar para a PSR-4.

Define o destino da instalação.

Caso a raiz do pacote esteja abaixo da declaração do namespace, você não poderá
fazer o autoload corretamente. `target-dir` resolve este problema.

Um exemplo é o Symfony. Existem pacotes individuais para os componentes. O
componente Yaml está em `Symfony\Component\Yaml`. A raiz do pacote é esse
diretório `Yaml`. Para tornar o autoloading possível, precisamos garantir que
ele não esteja instalado em `vendor/symfony/yaml`, mas sim em
`vendor/symfony/yaml/Symfony/Component/Yaml`, para que o autoloader possa
carregá-lo a partir de `vendor/symfony/yaml`.

Para fazer isso, `autoload` e `target-dir` são definidas da seguinte maneira:

```json
{
    "autoload": {
        "psr-0": { "Symfony\\Component\\Yaml\\": "" }
    },
    "target-dir": "Symfony/Component/Yaml"
}
```

Opcional.

### minimum-stability <span>([root-only][root-package])</span> {: #minimum-stability }

Isso define o comportamento padrão para filtrar pacotes pela estabilidade. O
padrão é `stable`, portanto, se você depender de um pacote `dev`, especifique-o
em seu arquivo para evitar surpresas.

Todas as versões de cada pacote são verificadas quanto à estabilidade, e as que
são menos estáveis que a configuração `minimum-stability` serão ignoradas ao
resolver as dependências do projeto. (Observe que você também pode especificar
requisitos de estabilidade por pacote, usando flags de estabilidade nas
restrições de versão especificadas em um bloco `require` (consulte os [links de
pacotes][package-links] para obter mais detalhes).

As opções disponíveis (em ordem de estabilidade) são `dev`, `alpha`, `beta`,
`RC` e `stable`.

### prefer-stable <span>([root-only][root-package])</span> {: #prefer-stable }

Quando isso está habilitado, o Composer prefere pacotes mais estáveis do que os
instáveis quando é possível encontrar pacotes estáveis compatíveis. Se você
precisar de uma versão de desenvolvimento ou apenas versões alpha estiverem
disponíveis para um pacote, elas ainda serão selecionadas, desde que a
`minimum-stability` permita.

Use `"prefer-stable": true` para habilitar.

### repositories <span>([root-only][root-package])</span> {: #repositories }

Repositórios de pacotes personalizados a serem usados.

Por padrão, o Composer usa apenas o repositório Packagist. Ao especificar
repositórios, você pode obter pacotes de outros lugares.

Os repositórios não são resolvidos recursivamente. Você pode adicioná-los apenas
ao seu `composer.json` principal. As declarações de repositórios do
`composer.json` das dependências são ignoradas.

Os seguintes tipos de repositórios são suportados:

* **composer:** Um repositório do Composer é simplesmente um arquivo
  `packages.json` servido via rede (HTTP, FTP, SSH), que contém uma lista de
  objetos `composer.json` com informações adicionais sobre `dist` e/ou `source`.
  O arquivo `packages.json` é carregado usando um stream PHP. Você pode definir
  opções extras para esse stream usando o parâmetro `options`.
* **vcs:** O repositório do sistema de controle de versão pode buscar pacotes
  nos repositórios do git, svn, fossil e hg.
* **pear:** Com isso, você pode importar qualquer repositório PEAR para o seu
  projeto Composer.
* **package:** Se você depende de um projeto que não possui absolutamente nenhum
  suporte ao Composer, você pode definir o pacote em linha usando um repositório
  `package`. Você basicamente adiciona o objeto `composer.json` em linha.

Para obter mais informações sobre qualquer um deles, consulte [Repositórios]
[repos].

Exemplo:

```json
{
    "repositories": [
        {
            "type": "composer",
            "url": "http://packages.exemplo.com.br"
        },
        {
            "type": "composer",
            "url": "https://packages.exemplo.com.br",
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

> **Nota:** Aqui a ordem é importante. Ao procurar um pacote, o Composer
> procurará do primeiro repositório ao último e escolherá a primeira
> correspondência. Por padrão, o Packagist é adicionado por último, o que
> significa que os repositórios personalizados podem sobrescrever os pacotes
> dele.

O uso da notação de objeto JSON também é possível. No entanto, os pares de
chave/valor JSON devem ser considerados ignorando a ordem, então um
comportamento consistente não pode ser garantido.

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

### config <span>([root-only][root-package])</span> {: #config }

Um conjunto de opções de configuração. É usada apenas para projetos. Consulte
[Configurações][conf] para obter uma descrição de cada opção individual.

### scripts <span>([root-only][root-package])</span> {: #scripts }

O Composer permite conectar-se a várias partes do processo de instalação através
do uso de scripts.

Consulte [Scripts][art-scripts] para obter detalhes e exemplos de eventos.

### extra

Dados extras arbitrários para consumo por `scripts`.

Isso pode ser praticamente qualquer coisa. Para acessá-los de dentro de um
manipulador de eventos de script, você pode fazer:

```php
$extra = $event->getComposer()->getPackage()->getExtra();
```

Opcional.

### bin

Um conjunto de arquivos que devem ser tratados como binários e ter links
simbólicos no `bin-dir` (da configuração).

Consulte os [Binários dos Vendors][art-binaries] para obter mais detalhes.

Opcional.

### archive

Um conjunto de opções para criar arquivos de pacotes compactados.

As seguintes opções são suportadas:

* **exclude:** Permite configurar uma lista de padrões para caminhos excluídos.
  A sintaxe do padrão corresponde aos arquivos `.gitignore`. Um ponto de
  exclamação (`!`) inicial resultará na inclusão de todos os arquivos
  correspondentes, mesmo que um padrão anterior os tenha excluído. Uma barra
  inicial corresponderá apenas no início do caminho relativo do projeto. Um
  asterisco não será expandido para um separador de diretório.

Exemplo:

```json
{
    "archive": {
        "exclude": ["/foo/bar", "baz", "/*.test", "!/foo/bar/baz"]
    }
}
```

O exemplo incluirá `/dir/foo/bar/arquivo`, `/foo/bar/baz`, `/arquivo.php`,
`/foo/meu.test`, mas excluirá `/foo/bar/qualquer`, `/foo/baz` e `/meu.test`.

Opcional.

### abandoned

Indica se este pacote foi abandonado.

Pode ser booleano ou um nome/URL de pacote apontando para uma alternativa
recomendada.

Exemplos:

Use `"abandoned": true` para indicar que este pacote foi abandonado.
Use `"abandoned": "monolog/monolog"` para indicar que este pacote foi abandonado
e a alternativa recomendada é `monolog/monolog`.

O padrão é `false`.

Opcional.

### non-feature-branches

Uma lista de padrões de expressões regulares de nomes de branches não numéricos
(por exemplo, "latest" ou algo parecido), que NÃO serão tratados como feature
branches. É um array de strings.

Se você tiver nomes de branches não numéricos, por exemplo, como "latest",
"current", "latest-stable" ou algo parecido, que não se pareçam com um número de
versão, o Composer tratará esses branches como feature branches. Isso significa
que ele procurará por branches pai, que se parecem com uma versão ou terminam em
branches especiais (como `master`) e o número da versão do pacote raiz se
tornará a versão do branch pai ou, pelo menos, `master` ou algo parecido.

Para tratar branches com nomes não numéricos como versões em vez de procurar por
um branch pai com uma versão válida ou nome de branch especial como `master`,
você pode definir padrões para nomes de branches, que devem ser tratados como
branches de versões de desenvolvimento.

Isso é realmente útil quando você tem dependências usando `self.version`, para
que não o `dev-master`, mas o mesmo branch seja instalado (no exemplo:
`latest-testing`).

Um exemplo:

Se você possui um branch `testing`, que é fortemente mantido durante uma fase de
testes e é implantado em seu ambiente staging, normalmente `composer show -s`
retornará `versions : * dev-master`.

Se você configurar `"latest-.*"` como um padrão para `non-feature-branches`
desta forma:

```json
{
    "non-feature-branches": ["latest-.*"]
}
```

Então `composer show -s` retornará `versions : * dev-latest-testing`.

Opcional.

[art-aliases]: artigos/aliases.md
[art-autoloader]: artigos/autoloader-optimization.md
[art-binaries]: artigos/vendor-binaries.md
[art-installers]: artigos/custom-installers.md
[art-scripts]: artigos/scripts.md
[art-versions]: artigos/versions.md
[conf]: 06-config.md
[json-schema]: https://json-schema.org/
[licenses]: https://spdx.org/licenses/
[min-stability]: #minimum-stability
[package-links]: #links-de-pacotes
[php-psr0]: https://www.php-fig.org/psr/psr-0/
[php-psr4]: https://www.php-fig.org/psr/psr-4/
[repos]: repositorios.md
[root-package]: #pacote-raiz
[schema-page]: https://getcomposer.org/schema.json
[sf-standard]: https://github.com/symfony/symfony-standard
[silverstripe-installer]: https://github.com/silverstripe/silverstripe-installer
