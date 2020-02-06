# Introdução

O Composer é uma ferramenta para gerenciamento de dependências no PHP. Ele
permite que você declare as bibliotecas das quais seu projeto depende e as
gerencia (instala/atualiza) para você.

## Gerenciamento de Dependências

O Composer **não** é um gerenciador de pacotes no mesmo sentido que o Yum ou
Apt. Sim, ele lida com "pacotes" ou bibliotecas, mas os gerencia separadamente
por projeto, instalando-os em um diretório (por exemplo, `vendor`) dentro do seu
projeto. Por padrão, ele não instala nada globalmente. Portanto, ele é um
gerenciador de dependências. No entanto, ele suporta um projeto "global" por
conveniência, através do comando [global][cli-global].

Essa ideia não é nova e o Composer é fortemente inspirado pelo [npm][npmjs-page]
do node e pelo [bundler][bundler-page] do ruby.

Suponha que:

1. Você tem um projeto que depende de várias bibliotecas.
1. Algumas dessas bibliotecas dependem de outras bibliotecas.

O Composer:

1. Permite declarar as bibliotecas das quais você depende.
1. Descobre quais versões de quais pacotes podem e precisam ser instaladas e as
   instala (o que significa que elas são baixadas no seu projeto).

Consulte o capítulo [Uso Básico][basic-usage] para obter mais detalhes sobre a
declaração de dependências.

## Requisitos de Sistema

O Composer requer o PHP 5.3.2+ para executar. Algumas configurações sensíveis do
PHP e flags de compilação também são necessárias, mas ao usar o instalador, você
será avisado sobre quaisquer incompatibilidades.

Para instalar pacotes a partir do código-fonte, em vez de arquivos zip simples,
você precisará do git, svn, fossil ou hg, dependendo de como é feito o controle
de versão do pacote.

O Composer é multiplataforma e nós nos esforçamos para fazê-lo funcionar
igualmente bem no Windows, Linux e macOS.

## Instalação - Linux / Unix / macOS

### Baixando o Executável do Composer

O Composer oferece um instalador conveniente que você pode executar diretamente
da linha de comando. Sinta-se à vontade para [baixar esse arquivo][installer]
ou revisá-lo no [GitHub][installer-github], se desejar saber mais sobre
o funcionamento interno do instalador. O código-fonte é PHP simples.

Em resumo, existem duas formas de instalar o Composer. Localmente como parte do
seu projeto ou globalmente como um executável disponível em todo o sistema.

#### Localmente

Para instalar o Composer localmente, execute o instalador no diretório do seu
projeto. Consulte [a página de download][download-page] para obter instruções.

O instalador verificará algumas configurações do PHP e fará o download do
`composer.phar` no seu diretório atual. Esse arquivo é o binário do Composer.
Ele é um PHAR (PHP Archive), que é um formato de arquivo para PHP que pode ser
executado na linha de comando, entre outras coisas.

Agora execute `php composer.phar` para executar o Composer.

Você pode instalar o Composer em um diretório específico usando a opção
`--install-dir` e, adicionalmente, também renomeá-lo usando a opção
`--filename`. Ao executar o instalador, seguindo [as instruções da página de download][download-page],
adicione os seguintes parâmetros:

```sh
php composer-setup.php --install-dir=bin --filename=composer
```

Agora execute `php bin/composer` para executar o Composer.

#### Globalmente

Você pode colocar o PHAR do Composer em qualquer lugar que desejar. Se você o
colocar em um diretório que faça parte da sua variável de ambiente `PATH`, você
poderá acessá-lo globalmente. Nos sistemas Unix, você pode até torná-lo
executável e invocá-lo sem usar diretamente o interpretador `php`.

Após executar o instalador, seguindo [as instruções da página de download][download-page],
você pode executar isto para mover o composer.phar para um diretório que esteja
na sua variável `PATH`:

```sh
mv composer.phar /usr/local/bin/composer
```

Se você deseja instalá-lo apenas para o seu usuário e evitar exigir permissões
de root, use `~/.local/bin`, que está disponível por padrão em algumas
distribuições Linux.

> **Nota:** Se o comando acima falhar devido a permissões, pode ser necessário
> executá-lo novamente com sudo.

> **Nota:** Em algumas versões do macOS, o diretório `/usr` não existe por
> padrão. Se você receber o erro "/usr/local/bin/composer: No such file or
> directory", deverá criar o diretório manualmente antes de continuar:
> `mkdir -p /usr/local/bin`.

> **Nota:** Para obter informações sobre como alterar sua variável `PATH`, leia
> o [artigo da Wikipedia][path-variable] e/ou use seu mecanismo de busca
> preferido.

Agora execute `composer` para executar o Composer em vez de `php composer.phar`.

## Instalação - Windows

### Usando o Instalador

Esta é a maneira mais fácil de configurar o Composer na sua máquina.

Baixe e execute o [Composer-Setup.exe][installer-exe]. Ele instalará a versão
mais recente do Composer e configurará sua variável `PATH` para que você possa
executar o `composer` de qualquer diretório na sua linha de comando.

> **Nota:** Feche seu terminal atual. Teste o uso com um novo terminal: Isso é
> importante, pois a variável `PATH` só é carregada quando o terminal é
> iniciado.

### Instalação Manual

Mude para um diretório que esteja na sua variável `PATH` e execute o instalador
seguindo [as instruções da página de download][download-page] para baixar o
`composer.phar`.

Crie um novo arquivo `composer.bat` junto ao `composer.phar`:

```sh
C:\bin>echo @php "%~dp0composer.phar" %*>composer.bat
```

Adicione o diretório à sua variável de ambiente `PATH`, se ainda não estiver.
Para obter informações sobre como alterar sua variável `PATH`, consulte
[este artigo][path-article] e/ou use seu mecanismo de pesquisa preferido.

Feche o seu terminal atual. Teste o uso em um novo terminal:

```sh
C:\Users\username>composer -V
Composer version 1.0.0 2016-01-10 20:34:53
```

## Usando o Composer

Agora que você instalou o Composer, está tudo pronto para usá-lo! Vá para o
próximo capítulo para uma demonstração curta e simples.

[basic-usage]: 01-basic-usage.md
[bundler-page]: https://bundler.io/
[cli-global]: 03-cli.md#global
[download-page]: https://getcomposer.org/download/
[installer]: https://getcomposer.org/installer
[installer-github]: https://github.com/composer/getcomposer.org/blob/master/web/installer
[installer-exe]: https://getcomposer.org/Composer-Setup.exe
[npmjs-page]: https://www.npmjs.com/
[path-article]: https://www.computerhope.com/issues/ch000549.htm
[path-variable]: https://en.wikipedia.org/wiki/PATH_(variable)
