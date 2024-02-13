<!--
source_url: https://github.com/composer/composer/blob/2.6/doc/01-basic-usage.md
revision: b608b8e87eeafec47fa04a8156ea44fc3f9745b0
status: ready
-->

# Uso básico

## Introdução

Para a nossa introdução ao uso básico, instalaremos o `monolog/monolog`, uma
biblioteca de registro de logs.
Se o Composer ainda não foi instalado, consulte o capítulo [Introdução][1].

> **Nota:** por uma questão de simplicidade, esta introdução assumirá que foi
> realizada uma instalação [local][2] do Composer.

## `composer.json`: configuração do projeto {: #composer-json-configuracao-do-projeto }

Para começar a usar o Composer no projeto, tudo o que precisamos é de um arquivo
`composer.json`.
Esse arquivo descreve as dependências do projeto e também pode conter outros
metadados.
Normalmente, ele deve ficar no diretório mais alto do projeto/repositório VCS.
Tecnicamente, é possível executar o Composer de qualquer lugar, mas se quiser
publicar um pacote no Packagist.org, ele terá que encontrar o arquivo no topo do
repositório VCS.

### A chave `require`

A primeira coisa especificada no `composer.json` é a chave [`require`][3].
Ela informa ao Composer os pacotes dos quais o projeto depende.

```json
{
    "require": {
        "monolog/monolog": "2.0.*"
    }
}
```

Como é possível ver, [`require`][3] recebe um objeto que mapeia **nomes de
pacotes** (por exemplo, `monolog/monolog`) para **restrições de versão** (por
exemplo, `2.0.*`).

O Composer usa essas informações para procurar o conjunto correto de arquivos
nos "repositórios" de pacotes registrados com a chave [`repositories`][4], ou em
[Packagist.org][7], o repositório de pacotes padrão.
No exemplo acima, como nenhum outro repositório foi registrado no arquivo
`composer.json`, presume-se que o pacote `monolog/monolog` esteja registrado no
Packagist.org.
(Leia mais sobre o [Packagist][5] e sobre [repositórios][6]).

### Nomes de pacotes

O nome do pacote consiste no nome do fornecedor e no nome do projeto.
Geralmente, eles serão idênticos — o nome do fornecedor existe apenas para
evitar conflitos de nomes.
Por exemplo, isso permite que duas pessoas diferentes criem uma biblioteca
chamada `json`.
Uma pode ser chamada `igorw/json` enquanto a outra pode ser `seldaek/json`.

Leia mais sobre [publicação e nomenclatura de pacotes][8].
(Note que também é possível especificar "pacotes de plataforma" como
dependências, permitindo exigir determinadas versões de programas do servidor.
Consulte [pacotes de plataforma][9] abaixo.)

### Restrições de versão de pacote

No nosso exemplo, estamos solicitando o pacote Monolog com a restrição de versão
[`2.0.*`][10].
Isso significa qualquer versão no branch de desenvolvimento `2.0`, ou qualquer
versão maior ou igual a `2.0` e menor que `2.1` (`>=2.0 <2.1`).

Leia o [artigo sobre versões][11] para obter informações mais detalhadas sobre
versões, como elas se relacionam entre si e sobre restrições de versão.

> **Como o Composer baixa os arquivos corretos?** Quando uma dependência é
> especificada no `composer.json`, o Composer primeiro pega o nome do pacote
> solicitado e o procura em qualquer repositório registrado usando a chave
> [`repositories`][4].
> Se nenhum repositório extra foi registrado, ou se ele não encontrou um pacote
> com esse nome nos repositórios especificados, ele recorre ao Packagist (mais
> [abaixo][5]).
>
> Quando o Composer encontra o pacote correto, seja no Packagist.org ou num
> repositório especificado, ele usa os recursos de versionamento do VCS do
> pacote (ou seja, branches e tags) para tentar encontrar a melhor
> correspondência para a restrição de versão especificada.
> Leia sobre versões e resolução de pacotes no [artigo sobre versões][11].

> **Nota:** Se estiver tentando requisitar um pacote e o Composer gerar um erro
> referente à estabilidade do pacote, a versão especificada pode não atender aos
> requisitos mínimos de estabilidade padrão.
> Por padrão, apenas versões estáveis são consideradas ao procurar versões de
> pacotes válidas no seu VCS.
>
> Isso pode acontecer ao tentar requisitar versões `dev`, `alpha`, `beta` ou
> `RC` de um pacote.
> Leia mais sobre flags de estabilidade e a chave `minimum-stability` na [página
> do esquema][12].

## Instalando dependências

Para instalar inicialmente as dependências definidas no projeto, execute o
comando [`update`][13]:

```shell
php composer.phar update
```

Isso fará com que o Composer faça duas coisas:

- Ele resolverá todas as dependências listadas no arquivo `composer.json` e
  gravará todos os pacotes e suas versões exatas no arquivo `composer.lock`,
  fixando o projeto nessas versões específicas.
  O arquivo `composer.lock` deve ser enviado ao repositório do projeto para que
  todas as pessoas que trabalham no projeto usem as mesmas versões fixas de
  dependências (mais abaixo).
  Esta é a função principal do comando `update`.
- Em seguida, ele executará implicitamente o comando [`install`][14].
  Isso baixará os arquivos das dependências no diretório `vendor` do projeto.
  (O diretório `vendor` é o local convencional para todos os códigos de
  terceiros em um projeto).
  Em nosso exemplo acima, os arquivos-fonte do Monolog acabariam em
  `vendor/monolog/monolog/`.
  Como o Monolog depende do pacote `psr/log`, os arquivos desse pacote também
  poderiam ser encontrados em `vendor`.

> **Dica:** Se o git estiver sendo usado no projeto, o diretório `vendor`
> provavelmente deverá ser adicionado ao `.gitignore`.
> Afinal, não queremos adicionar todo esse código de terceiros ao repositório
> versionado.

### Envie o arquivo `composer.lock` para o controle de versão

Fazer o commit desse arquivo para o controle de versão é essencial porque fará
com que qualquer pessoa que configurar o projeto use as mesmas versões das
dependências que foram usadas.
O servidor de integração contínua, máquinas de produção, outras pessoas no time,
tudo e todas as pessoas usarão as mesmas dependências, reduzindo o potencial de
erros que afetam apenas algumas partes das implantações.
Mesmo se o projeto for desenvolvido por apenas uma pessoa, em seis meses, ao
reinstalar o projeto, será possível ter certeza de que as dependências
instaladas ainda estarão funcionando, mesmo que tenham sido lançadas muitas
versões novas dessas dependências desde então.
(Veja a nota abaixo sobre como usar o comando `update`.)

> **Nota:** Para bibliotecas não é necessário fazer o commit do arquivo de
> travamento; veja também: [Bibliotecas - Arquivo de travamento][15].

### Instalando a partir do `composer.lock`

Se já houver um arquivo `composer.lock` na pasta do projeto, significa que o
comando `install` já foi executado ou outra pessoa no projeto executou o comando
`update` e fez o commit do arquivo `composer.lock` no projeto (o que é bom).

De qualquer forma, executar `install` quando um arquivo `composer.lock` estiver
presente resolverá e instalará todas as dependências listadas no
`composer.json`, mas o Composer usará as versões exatas listadas no
`composer.lock` para garantir que as versões dos pacotes sejam consistentes para
todas as pessoas que trabalham no projeto.
Como resultado, todas as dependências requisitadas no arquivo `composer.json`
serão obtidas, mas elas podem não estar nas versões mais recentes disponíveis
(algumas das dependências listadas no arquivo `composer.lock` podem ter lançado
versões mais recentes desde que o arquivo foi criado).
Isso é intencional e garante que o projeto não quebre devido a alterações
inesperadas nas dependências.

Portanto, após buscar novas alterações no repositório VCS, é recomendado
executar o comando `install` para garantir que o diretório `vendor` esteja
sincronizado com o arquivo `composer.lock`:

```shell
php composer.phar install
```

O Composer permite compilações reproduzíveis por padrão.
Isso significa que executar o mesmo comando várias vezes produzirá um diretório
`vendor` contendo arquivos idênticos (exceto por suas datas e horas), incluindo
os arquivos do carregador automático.
Isso é especialmente benéfico para ambientes que exigem processos de verificação
rigorosos, bem como para distribuições Linux que visam empacotar aplicações PHP
de maneira segura e previsível.

## Atualizando as Dependências para as Suas Versões mais Recentes

Como mencionado acima, o arquivo `composer.lock` impede que você obtenha
automaticamente as versões mais recentes das suas dependências. Para atualizar
para as versões mais recentes, use o comando [`update`][book-update]. Ele
buscará as versões correspondentes mais recentes (de acordo com o arquivo
`composer.json`) e atualizará o arquivo lock com as novas versões. (Isso é
equivalente a excluir o arquivo `composer.lock` e executar `install` novamente.)

```sh
php composer.phar update
```

> **Nota:** O Composer exibirá um alerta ao executar um comando `install` se o
> `composer.lock` não tiver sido atualizado depois que foram feitas alterações
> no `composer.json` que podem afetar a resolução de dependências.

Se você deseja instalar, atualizar ou remover apenas uma dependência, você pode
listá-la explicitamente como um argumento:

```sh
php composer.phar update monolog/monolog [...]
```

## Packagist

[Packagist][7] é o principal repositório do Composer. Um
repositório do Composer é basicamente uma fonte de pacotes: um lugar de onde
você pode obter pacotes. O Packagist é o repositório central que todas as
pessoas usam. Isso significa que você pode solicitar automaticamente qualquer
pacote disponível lá usando `require`, sem especificar mais detalhes sobre onde
o Composer deve procurar pelo pacote.

Se você for ao [site do Packagist][7] (packagist.org), poderá
navegar e pesquisar os pacotes.

É recomendado que qualquer projeto de código aberto usando o Composer publique
seus pacotes no Packagist. Uma biblioteca não precisa estar no Packagist para
ser usada pelo Composer, mas estar lá permite a descoberta e adoção mais rápida
por outras pessoas.

## Pacotes de Plataforma

O Composer possui pacotes de plataforma, que são pacotes virtuais para itens que
estão instalados no sistema, embora não sejam realmente instaláveis pelo
Composer. Isso inclui o próprio PHP, extensões PHP e algumas bibliotecas do
sistema.

* `php` representa a versão do PHP do usuário, permitindo aplicar restrições,
  por exemplo, `^7.1`. Para exigir uma versão do PHP de 64 bits, você pode
  exigir o pacote `php-64bit`.

* `hhvm` representa a versão do runtime da HHVM e permite aplicar uma restrição,
  por exemplo, `^2.3`.

* `ext-<nome>` permite exigir extensões PHP (incluindo extensões nativas). O
  versionamento pode ser bastante inconsistente aqui, portanto é uma boa ideia
  definir a restrição como `*`. Um exemplo de nome de pacote de extensão é
  `ext-gd`.

* `lib-<nome>` permite que restrições sejam feitas nas versões das bibliotecas
  usadas pelo PHP. As seguintes estão disponíveis: `curl`, `iconv`, `icu`,
  `libxml`, `openssl`, `pcre`, `uuid`, `xsl`.

Você pode usar [`show --platform`][book-show] para obter uma lista dos seus
pacotes de plataforma disponíveis localmente.

## Autoloading

Para bibliotecas que especificam informações de autoload, o Composer gera um
arquivo `vendor/autoload.php`. Você pode simplesmente incluir esse arquivo e
começar a usar as classes que essas bibliotecas fornecem sem nenhum trabalho
extra:

```php
require __DIR__ . '/vendor/autoload.php';

$log = new Monolog\Logger('nome');
$log->pushHandler(new Monolog\Handler\StreamHandler('app.log', Monolog\Logger::WARNING));
$log->addWarning('Foo');
```

Você pode até adicionar o seu próprio código ao autoloader, adicionando um campo
[`autoload`][book-autoload] ao `composer.json`.

```json
{
    "autoload": {
        "psr-4": {
            "Acme\\": "src/"
        }
    }
}
```

O Composer registrará um autoloader [PSR-4][page-psr4] para o namespace `Acme`.

Você define um mapeamento de namespaces para diretórios. O diretório `src`
estaria na raiz do seu projeto, no mesmo nível que o diretório `vendor`. Um
exemplo de nome de arquivo seria `src/Foo.php` contendo uma classe `Acme\Foo`.

Depois de adicionar o campo [`autoload`][book-autoload], você deve executar
novamente este comando:

```sh
php composer.phar dump-autoload
```

Esse comando irá gerar novamente o arquivo `vendor/autoload.php`. Veja a seção
[`dump-autoload`][book-autoload] para mais informações.

A inclusão desse arquivo também retornará a instância do autoloader, portanto,
você pode armazenar o valor de retorno da chamada ao include numa variável e
então adicionar mais namespaces. Isso pode ser útil para fazer o autoloading de
classes numa suíte de testes, por exemplo.

```php
$loader = require __DIR__ . '/vendor/autoload.php';
$loader->addPsr4('Acme\\Test\\', __DIR__);
```

Além do autoloading PSR-4, o Composer também suporta PSR-0, mapas de classes e
o autoloading de arquivos. Consulte a referência de [`autoload`][book-autoload]
para obter mais informações.

Consulte também a documentação sobre [otimização do autoloader]
[article-autoloader].

> **Nota:** O Composer fornece o seu próprio autoloader. Se você não quiser
> usá-lo, pode incluir os arquivos `vendor/composer/autoload_*.php`, que
> retornam arrays associativos que permitem configurar o seu próprio autoloader.

[1]: introducao.md

[2]: introducao.md#localmente

[3]: esquema.md#require

[4]: esquema.md#repositories

[5]: #packagist

[6]: repositorios.md

[7]: https://packagist.org/

[8]: bibliotecas.md

[9]: #pacotes-de-plataforma

[10]: https://semver.mwl.be/#?package=monolog%2Fmonolog&version=2.0.*

[11]: ../artigos/versions.md

[12]: esquema.md

[13]: cli.md#update-u

[14]: cli.md#install-i

[15]: bibliotecas.md#arquivo-de-travamento

[article-autoloader]: ../artigos/autoloader-optimization.md

[book-autoload]: esquema.md#autoload

[book-dump-autoload]: cli.md#dump-autoload-dumpautoload

[book-show]: cli.md#show

[page-psr4]: https://www.php-fig.org/psr/psr-4/
