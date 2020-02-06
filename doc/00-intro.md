# Introdução

O Composer é uma ferramenta para gerenciamento de dependências no PHP. Ele
permite que você declare as bibliotecas das quais seu projeto depende e as
gerencia (instala/atualiza) para você.

## Gerenciamento de Dependências

O Composer **não** é um gerenciador de pacotes no mesmo sentido que o Yum ou
Apt. Sim, ele lida com "pacotes" ou bibliotecas, mas os gerencia em uma base por
projeto, instalando-os em um diretório (por exemplo, `vendor`) dentro do seu
projeto. Por padrão, ele não instala nada globalmente. Portanto, ele é um
gerenciador de dependências. No entanto, ele suporta um projeto "global" por
conveniência, através do comando [global](03-cli.md#global).

Essa ideia não é nova e o Composer é fortemente inspirado pelo [npm](https://www.npmjs.com/)
do node e pelo [bundler](https://bundler.io/) do ruby.

Suponha que:

1. Você tem um projeto que depende de várias bibliotecas.
1. Algumas dessas bibliotecas dependem de outras bibliotecas.

O Composer:

1. Permite declarar as bibliotecas das quais você depende.
1. Descobre quais versões de quais pacotes podem e precisam ser instaladas e as
   instala (o que significa que elas são baixadas no seu projeto).

Consulte o capítulo [Uso Básico](01-basic-usage.md) para obter mais detalhes
sobre a declaração de dependências.

## Requisitos de Sistema

O Composer requer o PHP 5.3.2+ para executar. Algumas configurações sensíveis do
PHP e flags de compilação também são necessárias, mas ao usar o instalador, você
será avisado sobre quaisquer incompatibilidades.

Para instalar pacotes a partir de arquivos fonte, em vez de arquivos zip
simples, você precisará do git, svn, fossil ou hg, dependendo de como é feito o
controle de versão do pacote.

O Composer é multiplataforma e nós nos esforçamos para fazê-lo funcionar
igualmente bem no Windows, Linux e macOS.

## Instalação - Linux / Unix / macOS

### Downloading the Composer Executable

Composer offers a convenient installer that you can execute directly from the
command line. Feel free to [download this file](https://getcomposer.org/installer)
or review it on [GitHub](https://github.com/composer/getcomposer.org/blob/master/web/installer)
if you wish to know more about the inner workings of the installer. The source
is plain PHP.

There are in short, two ways to install Composer. Locally as part of your
project, or globally as a system wide executable.

#### Locally

To install Composer locally, run the installer in your project directory. See 
[the Download page](https://getcomposer.org/download/) for instructions.

The installer will check a few PHP settings and then download `composer.phar`
to your working directory. This file is the Composer binary. It is a PHAR
(PHP archive), which is an archive format for PHP which can be run on
the command line, amongst other things.

Now run `php composer.phar` in order to run Composer.

You can install Composer to a specific directory by using the `--install-dir`
option and additionally (re)name it as well using the `--filename` option. When
running the installer when following
[the Download page instructions](https://getcomposer.org/download/) add the
following parameters:

```sh
php composer-setup.php --install-dir=bin --filename=composer
```

Now run `php bin/composer` in order to run Composer.

#### Globally

You can place the Composer PHAR anywhere you wish. If you put it in a directory
that is part of your `PATH`, you can access it globally. On Unix systems you
can even make it executable and invoke it without directly using the `php`
interpreter.

After running the installer following [the Download page instructions](https://getcomposer.org/download/)
you can run this to move composer.phar to a directory that is in your path:

```sh
mv composer.phar /usr/local/bin/composer
```

If you like to install it only for your user and avoid requiring root permissions,
you can use `~/.local/bin` instead which is available by default on some
Linux distributions.

> **Note:** If the above fails due to permissions, you may need to run it again
> with sudo.

> **Note:** On some versions of macOS the `/usr` directory does not exist by
> default. If you receive the error "/usr/local/bin/composer: No such file or
> directory" then you must create the directory manually before proceeding:
> `mkdir -p /usr/local/bin`.

> **Note:** For information on changing your PATH, please read the
> [Wikipedia article](https://en.wikipedia.org/wiki/PATH_(variable)) and/or use Google.

Now run `composer` in order to run Composer instead of `php composer.phar`.

## Installation - Windows

### Using the Installer

This is the easiest way to get Composer set up on your machine.

Download and run
[Composer-Setup.exe](https://getcomposer.org/Composer-Setup.exe). It will
install the latest Composer version and set up your PATH so that you can
call `composer` from any directory in your command line.

> **Note:** Close your current terminal. Test usage with a new terminal: This is
> important since the PATH only gets loaded when the terminal starts.

### Manual Installation

Change to a directory on your `PATH` and run the installer following
[the Download page instructions](https://getcomposer.org/download/)
to download `composer.phar`.

Create a new `composer.bat` file alongside `composer.phar`:

```sh
C:\bin>echo @php "%~dp0composer.phar" %*>composer.bat
```

Add the directory to your PATH environment variable if it isn't already.
For information on changing your PATH variable, please see
[this article](https://www.computerhope.com/issues/ch000549.htm) and/or
use Google.

Close your current terminal. Test usage with a new terminal:

```sh
C:\Users\username>composer -V
Composer version 1.0.0 2016-01-10 20:34:53
```

## Using Composer

Now that you've installed Composer, you are ready to use it! Head on over to the
next chapter for a short and simple demonstration.

[Basic usage](01-basic-usage.md) &rarr;
