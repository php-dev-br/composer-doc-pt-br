# Introdução

O Composer é uma ferramenta para gerenciamento de dependências em PHP. Ele
permite que as bibliotecas das quais o projeto depende sejam declaradas e
gerenciadas (instaladas/atualizadas).

## Gerenciamento de Dependências

O Composer **não** é um gerenciador de pacotes no mesmo sentido que o Yum ou
Apt. Sim, ele lida com "pacotes" ou bibliotecas, mas os gerencia separadamente
por projeto, instalando-os em um diretório (por exemplo, `vendor`) dentro do
projeto. Por padrão, ele não instala nada globalmente. Portanto, ele é um
gerenciador de dependências. No entanto, ele suporta um projeto "global" por
conveniência, através do comando [global][book-global].

Essa ideia não é nova e o Composer é fortemente inspirado pelo [npm][page-npmjs]
do node e pelo [bundler][page-bundler] do ruby.

Suponha que:

1. Há um projeto que depende de várias bibliotecas.
2. Algumas destas bibliotecas dependem de outras bibliotecas.

O Composer:

1. Permite declarar as bibliotecas das quais o projeto depende.
2. Descobre quais versões de quais pacotes podem e precisam ser instaladas, e as
   instala (o que significa que elas são baixadas no projeto).
3. Todas as dependências podem ser atualizadas em um comando.

Consulte o capítulo [Uso Básico][book-usage] para obter detalhes sobre a
declaração de dependências.

## Requisitos de Sistema

A versão mais recente do Composer requer o PHP 7.2.5 para executar. Uma versão
de suporte de longo prazo (2.2.x) ainda oferece suporte ao PHP 5.3.2+ caso você
esteja preso a uma versão legada do PHP. Algumas configurações sensíveis e
flags de compilação do PHP também são necessárias, mas ao usar o instalador,
você ficará sabendo de quaisquer incompatibilidades.

O Composer precisa de várias aplicações de suporte para funcionar de forma
eficaz, tornando o processo de tratamento de dependências de pacotes mais
eficiente. Para descompactar arquivos, o Composer conta com ferramentas como
`7z` (ou `7zz`), `gzip`, `tar`, `unrar`, `unzip` e `xz`. Quanto aos sistemas de
controle de versão, o Composer integra-se perfeitamente com Fossil, Git,
Mercurial, Perforce e Subversion, garantindo assim o bom funcionamento da
aplicação e o gerenciamento dos repositórios de bibliotecas. Antes de usar o
Composer, certifique-se de que estas dependências estejam instaladas
corretamente no sistema.

O Composer é multiplataforma e nos esforçamos para fazê-lo funcionar igualmente
bem no Windows, Linux e macOS.

## Instalação - Linux / Unix / macOS

### Baixando o Executável do Composer

O Composer oferece um instalador conveniente que pode ser executado diretamente
da linha de comando. Sinta-se à vontade para [baixar o instalador]
[page-installer] ou revisá-lo no [GitHub][page-github], se desejar saber mais
sobre o funcionamento interno do instalador. O código-fonte é PHP simples.

Em resumo, existem duas formas de instalar o Composer. Localmente como parte do
projeto, ou globalmente como um executável disponível em todo o sistema.

#### Localmente

Para instalar o Composer localmente, execute o instalador no diretório do
projeto. Consulte [a página de download][page-download] para obter instruções.

O instalador verificará algumas configurações do PHP e baixará o `composer.phar`
no diretório atual. Este arquivo é o binário do Composer. Ele é um PHAR (PHP
Archive), que é um formato de arquivo para PHP que pode ser executado na linha
de comando, entre outras coisas.

Agora execute `php composer.phar` para executar o Composer.

O Composer pode ser instalado em um diretório específico usando a opção
`--install-dir` e, adicionalmente, também pode ser renomeado usando a opção
`--filename`. Ao executar o instalador, seguindo [as instruções da página de
download][page-download], adicione os seguintes parâmetros:

```shell
php composer-setup.php --install-dir=bin --filename=composer
```

Agora execute `php bin/composer` para executar o Composer.

#### Globalmente

O PHAR do Composer pode ser colocado em qualquer lugar que desejar. Se ele for
colocado em um diretório que faça parte da variável de ambiente `PATH`, poderá
ser acessado globalmente. Nos sistemas Unix, ele poderá até ser executado sem
usar diretamente o interpretador `php`.

Após executar o instalador seguindo [as instruções da página de download]
[page-download], este comando pode ser executado para mover o `composer.phar`
para um diretório que esteja na variável `PATH`:

```shell
mv composer.phar /usr/local/bin/composer
```

Se deseja instalar o Composer apenas para um usuário e evitar a necessidade de
permissões de administrador, use `~/.local/bin`, que está disponível por padrão
em algumas distribuições Linux.

> **Nota:** Se o comando acima falhar devido a permissões, pode ser necessário
> executá-lo novamente com `sudo`.

> **Nota:** Em algumas versões do macOS, o diretório `/usr` não existe por
> padrão. Se ocorrer o erro "/usr/local/bin/composer: No such file or
> directory", o diretório deverá ser criado manualmente antes de continuar:
> `mkdir -p /usr/local/bin`.

> **Nota:** Para obter informações sobre como alterar a variável `PATH`, leia o
> [artigo da Wikipedia][page-path-variable] ou use um mecanismo de pesquisa.

Agora execute `composer` para executar o Composer em vez de `php composer.phar`.

## Instalação - Windows

### Usando o Instalador

Esta é a maneira mais fácil de configurar o Composer na máquina.

Baixe e execute o binário [Composer-Setup.exe][page-installer-exe].
Ele instalará a versão mais recente do Composer e configurará a variável `PATH`
para que o `composer` possa ser executado de qualquer diretório na linha de
comando.

> **Nota:** Feche o terminal atual. Teste o uso em um novo terminal: isso é
> importante, pois a variável `PATH` só é carregada quando o terminal é
> iniciado.

### Instalação Manual

Mude para um diretório que esteja na variável `PATH` e execute o instalador
seguindo [as instruções da página de download][page-download] para baixar o
`composer.phar`.

Crie um novo arquivo `composer.bat` junto ao `composer.phar`:

Usando `cmd.exe`:

```shell
C:\bin>echo @php "%~dp0composer.phar" %*>composer.bat
```

Usando PowerShell:

```shell
PS C:\bin> Set-Content composer.bat '@php "%~dp0composer.phar" %*'
```

Adicione o diretório à variável de ambiente `PATH`, se ainda não tiver
adicionado. Para obter informações sobre como alterar a variável `PATH`,
consulte [este artigo][page-path-article] ou use um mecanismo de pesquisa.

Feche o terminal atual. Teste o uso em um novo terminal:

```shell
C:\Users\username>composer -V
```
```text
Composer version 2.4.0 2022-08-16 16:10:48
```

## Imagem Docker

O Composer é publicado como imagem Docker em alguns lugares, veja a lista no
[README do composer/docker][page-github-docker].

Exemplo de uso:

```shell
docker pull composer/composer
docker run --rm -it -v "$(pwd):/app" composer/composer install
```

Para adicionar o Composer a um **Dockerfile** existente, o arquivo binário
simplesmente pode ser copiado de imagens pré-construídas de tamanho reduzido:

```Dockerfile
# Última versão
COPY --from=composer/composer:latest-bin /composer /usr/bin/composer

# Versão específica
COPY --from=composer/composer:2-bin /composer /usr/bin/composer
```

Leia a [descrição da imagem][page-docker-composer] para obter informações de
uso.

**Nota:** Problemas específicos do Docker devem ser informados [no repositório
composer/docker][page-docker-issues].

**Nota:** `composer` também pode ser usado em vez de `composer/composer` como
nome da imagem acima. É mais curto e é uma imagem oficial do Docker, mas não é
publicado diretamente por nós e por isso costuma receber novos lançamentos com
atraso de alguns dias. **Importante**: imagens com apelidos curtos não possuem
equivalentes apenas com binários, então para a abordagem `COPY --from` é melhor
usar `composer/composer`.

## Usando o Composer

Agora que o Composer foi instalado, está tudo pronto para usá-lo! Leia o próximo
capítulo para uma breve demonstração.

[book-global]: cli.md#global
[book-usage]: uso-basico.md
[page-bundler]: https://bundler.io/
[page-download]: https://getcomposer.org/download/
[page-github]: https://github.com/composer/getcomposer.org/blob/master/web/installer
[page-installer]: https://getcomposer.org/installer
[page-installer-exe]: https://getcomposer.org/Composer-Setup.exe
[page-npmjs]: https://www.npmjs.com/
[page-path-article]: https://www.computerhope.com/issues/ch000549.htm
[page-path-variable]: https://en.wikipedia.org/wiki/PATH_(variable)
[page-github-docker]: https://github.com/composer/docker
[page-docker-composer]: https://hub.docker.com/r/composer/composer
[page-docker-issues]: https://github.com/composer/docker/issues
