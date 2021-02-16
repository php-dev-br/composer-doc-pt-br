# Introdução

O Composer é uma ferramenta para gerenciamento de dependências no PHP. Ele
permite que você declare as bibliotecas das quais o seu projeto depende e as
gerencia (instala/atualiza) para você.

## Gerenciamento de Dependências

O Composer **não** é um gerenciador de pacotes no mesmo sentido que o Yum ou
Apt. Sim, ele lida com “pacotes” ou bibliotecas, mas os gerencia separadamente
por projeto, instalando-os num diretório (por exemplo, `vendor`) dentro do seu
projeto. Por padrão, ele não instala nada globalmente. Portanto, ele é um
gerenciador de dependências. No entanto, ele suporta um projeto “global” por
conveniência, através do comando [global][book-global].

Essa ideia não é nova e o Composer é fortemente inspirado pelo [npm][page-npmjs]
do node e pelo [bundler][page-bundler] do ruby.

Suponha que:

1. Você tenha um projeto que depende de várias bibliotecas.
1. Algumas dessas bibliotecas dependem de outras bibliotecas.

O Composer:

1. Permite declarar as bibliotecas das quais o seu projeto depende.
1. Descobre quais versões de quais pacotes podem e precisam ser instaladas, e as
   instala (o que significa que elas são baixadas no seu projeto).

Consulte o capítulo [Uso Básico][book-usage] para obter mais detalhes sobre a
declaração de dependências.

## Requisitos de Sistema

O Composer requer o PHP 5.3.2+ para executar. Algumas configurações sensíveis e
flags de compilação do PHP também são necessárias, mas ao usar o instalador,
você ficará sabendo de quaisquer incompatibilidades.

Para instalar pacotes a partir do código-fonte, em vez dos arquivos comprimidos,
você precisará do git, svn, fossil ou hg, dependendo de como é feito o controle
de versão do pacote.

O Composer é multiplataforma e nós nos esforçamos para fazê-lo funcionar
igualmente bem no Windows, Linux e macOS.

## Instalação — Linux / Unix / macOS

### Baixando o Executável do Composer

O Composer oferece um instalador conveniente que você pode executar diretamente
da linha de comando. Sinta-se à vontade para [baixar esse arquivo]
[page-installer] ou revisá-lo no [GitHub][page-github], se desejar saber mais
sobre o funcionamento interno do instalador. O código-fonte é PHP simples.

Em resumo, existem duas formas de instalar o Composer. Localmente como parte do
seu projeto, ou globalmente como um executável disponível em todo o sistema.

#### Localmente

Para instalar o Composer localmente, execute o instalador no diretório do seu
projeto. Consulte [a página do instalador][page-download] para obter instruções.

O instalador verificará algumas configurações do PHP e baixará o `composer.phar`
no seu diretório atual. Esse arquivo é o binário do Composer. Ele é um PHAR (PHP
Archive), que é um formato de arquivo para PHP que pode ser executado na linha
de comando, entre outras coisas.

Agora execute `php composer.phar` para rodar o Composer.

Você pode instalar o Composer num diretório específico usando a opção
`--install-dir` e, adicionalmente, também renomeá-lo usando a opção
`--filename`. Ao executar o instalador, seguindo [as instruções da página do
instalador][page-download], adicione os seguintes parâmetros:

```sh
php composer-setup.php --install-dir=bin --filename=composer
```

Agora execute `php bin/composer` para rodar o Composer.

#### Globalmente

Você pode colocar o PHAR do Composer em qualquer lugar que desejar. Se você o
colocar num diretório que faça parte da sua variável de ambiente `PATH`, você
poderá acessá-lo globalmente. Nos sistemas Unix, você pode até torná-lo
executável e invocá-lo sem usar diretamente o interpretador `php`.

Após executar o instalador seguindo [as instruções da página do instalador]
[page-download], você pode executar esse comando para mover o `composer.phar`
para um diretório que esteja na sua variável `PATH`:

```sh
mv composer.phar /usr/local/bin/composer
```

Se você deseja instalá-lo apenas para o seu usuário e evitar a necessidade de
permissões de administrador, use `~/.local/bin`, que está disponível por padrão
em algumas distribuições Linux.

> **Nota:** Se o comando acima falhar devido a permissões, pode ser necessário
> executá-lo novamente com sudo.

> **Nota:** Em algumas versões do macOS, o diretório `/usr` não existe por
> padrão. Se você receber o erro `/usr/local/bin/composer: No such file or
> directory`, deverá criar o diretório manualmente antes de continuar:
> `mkdir -p /usr/local/bin`.

> **Nota:** Para obter informações sobre como alterar a sua variável `PATH`,
> leia o [artigo da Wikipedia][page-path-variable] ou use o seu mecanismo de
> busca preferido.

Agora execute `composer` para rodar o Composer em vez de `php composer.phar`.

## Instalação — Windows

### Usando o Instalador

Esta é a maneira mais fácil de configurar o Composer na sua máquina.

Baixe e execute o [Composer-Setup.exe][page-installer-exe]. Ele instalará a
versão mais recente do Composer e configurará a sua variável `PATH` para que
você possa executar o `composer` de qualquer diretório na sua linha de comando.

> **Nota:** Feche o seu terminal atual. Teste o uso num novo terminal: isso é
> importante, pois a variável `PATH` só é carregada quando o terminal é
> iniciado.

### Instalação Manual

Mude para um diretório que esteja na sua variável `PATH` e execute o instalador
seguindo [as instruções da página do instalador][page-download] para baixar o
`composer.phar`.

Crie um novo arquivo `composer.bat` junto ao `composer.phar`:

Usando `cmd.exe`:

```sh
C:\bin>echo @php "%~dp0composer.phar" %*>composer.bat
```

Usando PowerShell:

```sh
PS C:\bin> Set-Content composer.bat '@php "%~dp0composer.phar" %*'
```

Adicione o diretório à sua variável de ambiente `PATH`, se ainda não tiver
adicionado. Para obter informações sobre como alterar a sua variável `PATH`,
consulte [este artigo][page-path-article] ou use o seu mecanismo de pesquisa
preferido.

Feche o seu terminal atual. Teste o uso num novo terminal:

```sh
C:\Users\username>composer -V
Composer version 1.0.0 2016-01-10 20:34:53
```

## Usando o Composer

Agora que você instalou o Composer, está tudo pronto para usá-lo! Leia o próximo
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
