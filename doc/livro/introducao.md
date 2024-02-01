<!--
source_url: https://github.com/composer/composer/blob/2.6/doc/00-intro.md
revision: 69746f699f01f7b33d411cd4ddceeeb3e26b5139
status: ready
-->

# Introdução

O Composer é uma ferramenta para gerenciamento de dependências em PHP.
Ele permite que as bibliotecas das quais o projeto depende sejam declaradas e
gerenciadas (instaladas/atualizadas).

## Gerenciamento de Dependências

O Composer **não** é um gerenciador de pacotes no mesmo sentido que o Yum ou
Apt.
Sim, ele lida com "pacotes" ou bibliotecas, mas os gerencia separadamente
por projeto, instalando-os em um diretório (por exemplo, `vendor`) dentro do
projeto.
Por padrão, ele não instala nada globalmente.
Portanto, ele é um gerenciador de dependências.
No entanto, ele suporta um projeto "global" por conveniência, através do comando
[global][1].

Essa ideia não é nova e o Composer é fortemente inspirado pelo [npm][2] do node
e pelo [bundler][3] do ruby.

Suponha que:

1. Há um projeto que depende de várias bibliotecas.
2. Algumas destas bibliotecas dependem de outras bibliotecas.

O Composer:

1. Permite declarar as bibliotecas das quais o projeto depende.
2. Descobre quais versões de quais pacotes podem e precisam ser instaladas, e as
   instala (o que significa que elas são baixadas no projeto).
3. Todas as dependências podem ser atualizadas em um comando.

Consulte o capítulo [Uso básico][4] para obter detalhes sobre a declaração de
dependências.

## Requisitos de sistema

A versão mais recente do Composer requer o PHP 7.2.5 para executar.
Uma versão de suporte de longo prazo (2.2.x) ainda oferece suporte ao PHP
5.3.2+, caso seja necessário usar uma versão legada do PHP.
Algumas configurações sensíveis e flags de compilação do PHP também são
necessárias, mas ao usar o instalador, será possível saber de quaisquer
incompatibilidades.

O Composer precisa de várias aplicações de suporte para funcionar de forma
eficaz, tornando mais eficiente o processo de tratamento de dependências de
pacotes.
Para descompactar arquivos, o Composer conta com ferramentas como
`7z` (ou `7zz`), `gzip`, `tar`, `unrar`, `unzip` e `xz`.
Quanto aos sistemas de controle de versão, o Composer integra-se perfeitamente
com Fossil, Git, Mercurial, Perforce e Subversion, garantindo assim o bom
funcionamento da aplicação e o gerenciamento dos repositórios de bibliotecas.
Antes de usar o Composer, certifique-se de que estas dependências estejam
instaladas corretamente no sistema.

O Composer é multiplataforma e nos esforçamos para fazê-lo funcionar igualmente
bem no Windows, Linux e macOS.

## Instalação - Linux / Unix / macOS

### Baixando o executável do Composer

O Composer oferece um instalador conveniente que pode ser executado diretamente
da linha de comando.
Sinta-se à vontade para [baixar o instalador][5] ou revisá-lo no [GitHub][6], se
desejar saber mais sobre o funcionamento interno do instalador.
O código-fonte é PHP puro.

Em resumo, existem duas formas de instalar o Composer.
Localmente como parte do projeto, ou globalmente como um executável disponível
em todo o sistema.

#### Localmente

Para instalar o Composer localmente, execute o instalador no diretório do
projeto.
Consulte [a página de download][7] para obter instruções.

O instalador verificará algumas configurações do PHP e baixará o `composer.phar`
no diretório atual.
Este arquivo é o binário do Composer.
Ele é um PHAR (PHP Archive), que é um formato de arquivo para PHP que pode ser
executado na linha de comando, entre outras coisas.

Agora execute `php composer.phar` para executar o Composer.

O Composer pode ser instalado em um diretório específico usando a opção
`--install-dir` e, adicionalmente, também pode ser renomeado usando a opção
`--filename`.
Ao executar o instalador, seguindo [as instruções da página de download][7],
adicione os seguintes parâmetros:

```shell
php composer-setup.php --install-dir=bin --filename=composer
```

Agora execute `php bin/composer` para executar o Composer.

#### Globalmente

O PHAR do Composer pode ser colocado em qualquer lugar que desejar.
Se ele for colocado em um diretório que faça parte da variável de ambiente
`PATH`, poderá ser acessado globalmente.
Nos sistemas Unix, ele poderá até ser executado sem usar diretamente o
interpretador `php`.

Após executar o instalador seguindo [as instruções da página de download][7],
este comando pode ser executado para mover o `composer.phar` para um diretório
que esteja na variável `PATH`:

```shell
mv composer.phar /usr/local/bin/composer
```

Se deseja instalar o Composer apenas para um usuário e evitar a necessidade de
permissões de administrador, use `~/.local/bin`, que está disponível por padrão
em algumas distribuições Linux.

> **Nota:** Se o comando acima falhar devido a permissões, pode ser necessário
> executá-lo novamente com `sudo`.

> **Nota:** Em algumas versões do macOS, o diretório `/usr` não existe por
> padrão.
> Se ocorrer o erro `/usr/local/bin/composer: No such file or directory`, o
> diretório deverá ser criado manualmente antes de continuar:
> `mkdir -p /usr/local/bin`.

> **Nota:** Para obter informações sobre como alterar a variável `PATH`, leia o
> [artigo da Wikipedia][8] ou use um mecanismo de pesquisa.

Agora execute `composer` para executar o Composer em vez de `php composer.phar`.

## Instalação - Windows

### Usando o instalador

Esta é a maneira mais fácil de configurar o Composer na máquina.

Baixe e execute o binário [Composer-Setup.exe][9].
Ele instalará a versão mais recente do Composer e configurará a variável `PATH`
para que o `composer` possa ser executado de qualquer diretório na linha de
comando.

> **Nota:** Feche o terminal atual.
> Teste o uso em um novo terminal: isso é importante, pois a variável `PATH` só
> é carregada quando o terminal é iniciado.

### Instalação Manual

Mude para um diretório que esteja na variável `PATH` e execute o instalador
seguindo [as instruções da página de download][7] para baixar o `composer.phar`.

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
adicionado.
Para obter informações sobre como alterar a variável `PATH`, consulte [este
artigo][10] ou use um mecanismo de pesquisa.

Feche o terminal atual.
Teste o uso em um novo terminal:

```shell
C:\Users\username>composer -V
```

```text
Composer version 2.4.0 2022-08-16 16:10:48
```

## Imagem do Docker

O Composer é publicado como imagem do Docker em alguns lugares, veja a lista no
[README do composer/docker][11].

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

Leia a [descrição da imagem][12] para obter informações de uso.

**Nota:** Problemas específicos do Docker devem ser informados [no repositório
composer/docker][13].

**Nota:** `composer` também pode ser usado em vez de `composer/composer` como
nome da imagem acima.
É mais curto e é uma imagem oficial do Docker, mas não é publicado diretamente
por nós e por isso costuma receber novos lançamentos com atraso de alguns dias.
**Importante**: imagens com apelidos curtos não possuem equivalentes apenas com
binários, então para a abordagem `COPY --from` é melhor usar
`composer/composer`.

## Usando o Composer

Agora que o Composer foi instalado, está tudo pronto para usá-lo!
Leia o próximo capítulo para uma breve demonstração.

[1]: cli.md#global

[2]: https://www.npmjs.com/

[3]: https://bundler.io/

[4]: uso-basico.md

[5]: https://getcomposer.org/installer

[6]: https://github.com/composer/getcomposer.org/blob/main/web/installer

[7]: https://getcomposer.org/download/

[8]: https://en.wikipedia.org/wiki/PATH_(variable)

[9]: https://getcomposer.org/Composer-Setup.exe

[10]: https://www.computerhope.com/issues/ch000549.htm

[11]: https://github.com/composer/docker

[12]: https://hub.docker.com/r/composer/composer

[13]: https://github.com/composer/docker/issues
