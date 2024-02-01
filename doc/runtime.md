<!--
source_url: https://github.com/composer/composer/blob/2.6/doc/07-runtime.md
revision: 31c7474cde1abe5bb5ea5bc9623c399797ba2f8e
status: wip
-->

# Utilitários do Runtime Composer

Embora o Composer seja usado principalmente para instalar as dependências do
projeto, algumas coisas são disponibilizadas para uso em tempo de execução.

Se precisar contar com alguns deles em uma versão específica, é possível exigir
o pacote `composer-runtime-api`.

## Carregamento automático

O carregador automático é o mais usado e já foi abordado em nosso [guia de uso
básico][1].
Ele está disponível em todas as versões do Composer.

## Versões instaladas

O `composer-runtime-api` `2.0` introduziu uma nova classe
`Composer\InstalledVersions` oferecendo alguns métodos estáticos para
inspecionar quais versões estão atualmente instaladas.
Isso estará automaticamente disponível para o seu código, se o carregador
automático do Composer for incluído.

Os principais casos de uso desta classe são os seguintes:

### Saber se o pacote X (ou pacote virtual) está presente

```php
\Composer\InstalledVersions::isInstalled('fornecedor/pacote'); // retorna booleano
\Composer\InstalledVersions::isInstalled('psr/log-implementation'); // retorna booleano
```

A partir do Composer 2.1, também é possível verificar se algo foi instalado via
`require-dev` ou não, passando `false` como segundo argumento:

```php
\Composer\InstalledVersions::isInstalled('fornecedor/pacote'); // retorna true assumindo que este pacote esteja instalado
\Composer\InstalledVersions::isInstalled('fornecedor/pacote', false); // retorna true se o fornecedor/pacote estiver em require, false se estiver em require-dev
```

Observe que isso não pode ser usado para verificar se os pacotes da plataforma
estão instalados.

### Saber se o pacote X está instalado na versão Y

> **Nota:** Para usar isso, seu pacote deve exigir `"composer/semver": "^3.0"`.

```php
use Composer\Semver\VersionParser;

\Composer\InstalledVersions::satisfies(new VersionParser, 'fornecedor/pacote', '2.0.*');
\Composer\InstalledVersions::satisfies(new VersionParser, 'psr/log-implementation', '^1.0');
```

Isso retornará `true` se, por exemplo, `fornecedor/pacote` estiver instalado em
uma versão correspondente `2.0.*`, mas também se o nome do pacote fornecido for
substituído ou fornecido por algum outro pacote.

### Saber qual a versão do pacote X

> **Nota:** Isso retornará `null` se o nome do pacote solicitado não estiver
> instalado, mas for apenas fornecido ou substituído por outro pacote.
> Portanto, recomendamos usar `satisfies()` pelo menos no código da biblioteca.
> No código da aplicação, é possível ter um pouco mais de controle e isso é
> menos importante.

```php
// retorna uma versão normalizada (por exemplo, 1.2.3.0) se fornecedor/pacote
// estiver instalado, ou null se for fornecido/substituído, ou lança
// OutOfBoundsException se o pacote não estiver instalado
\Composer\InstalledVersions::getVersion('fornecedor/pacote');
```

```php
// retorna a versão original (por exemplo, v1.2.3) se fornecedor/pacote estiver
// instalado, ou null se for fornecido/substituído, ou lança
// OutOfBoundsException se o pacote não estiver instalado
\Composer\InstalledVersions::getPrettyVersion('fornecedor/pacote');
```

```php
// retorna a referência do código-fonte ou da distribuição do pacote (por
// exemplo, um hash de commit do git) se fornecedor/pacote estiver instalado, ou
// null se for fornecido/substituído, ou lança OutOfBoundsException se o pacote
// não estiver instalado
\Composer\InstalledVersions::getReference('fornecedor/pacote');
```

### Saber qual a versão instalada do próprio pacote

Se quiser apenas obter a versão de um pacote, por exemplo, no código-fonte de
`acme/foo`, desejar saber qual versão de `acme/foo` está sendo executada
atualmente para exibi-la ao usuário, então é aceitável usar
`getVersion()`/`getPrettyVersion()`/`getReference()`.

O alerta na seção acima não se aplica neste caso, pois temos certeza de que o
pacote está presente e não será substituído se o código estiver em execução.

No entanto, lidar com o valor de retorno `null` da maneira mais elegante
possível por segurança é uma boa ideia.

----

Alguns outros métodos estão disponíveis para usos mais complexos; consulte o
código-fonte/blocos de documentação da [própria classe][2].

### Saber qual o caminho em que um pacote está instalado

O método `getInstallPath()` retorna o caminho absoluto de instalação de um pacote.

> **Nota:** O caminho, embora absoluto, pode conter `../` ou links simbólicos.
> Não é garantido que seja equivalente ao retorno de `realpath()`, então é
> necessário executar `realpath()` nele se isso for importante.

```php
// retorna um caminho absoluto para o local de instalação do pacote se
// fornecedor/pacote estiver instalado, ou null se for fornecido/substituído, ou
// o pacote for um meta-pacote ou lança OutOfBoundsException se o pacote não
//estiver instalado
\Composer\InstalledVersions::getInstallPath('fornecedor/pacote');
```

> Disponível a partir do Composer 2.1 (ou seja, `composer-runtime-api ^2.1`).

### Saber quais pacotes de um determinado tipo estão instalados

O método `getInstalledPackagesByType()` aceita um tipo de pacote (por exemplo,
`foo-plugin`) e lista os pacotes desse tipo que estão instalados.
Se necessário, é possível usar os métodos acima para recuperar mais informações
sobre cada pacote.

Este método deve aliviar a necessidade de instaladores personalizados colocarem
plugins em um caminho específico, em vez de deixá-los no diretório do
fornecedor.
Os plugins para inicializar em tempo de execução podem ser encontrados por meio
de `InstalledVersions`, incluindo seus caminhos por meio de `getInstallPath()`.

```php
\Composer\InstalledVersions::getInstalledPackagesByType('foo-plugin');
```

> Disponível a partir do Composer 2.1 (ou seja, `composer-runtime-api ^2.1`).

## Verificação de plataforma

O `composer-runtime-api` `2.0` introduziu um novo arquivo
`vendor/composer/platform_check.php`, que é incluído automaticamente quando o
carregador automático do Composer é incluído.

Ele verifica se o processo PHP atual atende aos requisitos da plataforma (ou
seja, PHP e extensões PHP).
Caso os requisitos não sejam atendidos, o script imprime um alerta com os
requisitos ausentes e sai com o código `104`.

Para evitar uma página em branco inesperada da morte com algum alerta obscuro de
extensão PHP em produção, é possível executar `composer check-platform-reqs`
como parte da instalação/construção e, se isso retornar um código diferente de
`0`, a operação deve ser abortada.

O valor padrão é `php-only`, que verifica apenas a versão do PHP.

Se, por algum motivo, não quiser usar esta verificação de segurança e preferir
arriscar erros de tempo de execução quando seu código for executado, é possível
desabilitar isso definindo a opção de configuração de [`platform-check`][3] como
`false`.

Se quiser que a verificação inclua a verificação da presença de extensões PHP,
defina a opção config como `true`.
Os requisitos `ext-*` serão então verificados, mas por razões de desempenho, o
Composer apenas verifica se a extensão está presente, não sua versão exata.

Os requisitos `lib-*` não são suportados/verificados pelo recurso de verificação
de plataforma.

## Caminho do carregador automático em binários

O `composer-runtime-api` `2.2` introduziu uma nova variável global
`$_composer_autoload_path` definida ao executar binários instalados com o
Composer.
Leia mais sobre isso na [documentação de binários dos fornecedores][4].

Isso é definido pelo proxy binário e, como tal, não é disponibilizado para
projetos pelo script `vendor/autoload.php` do Composer, o que seria inútil, pois
apontaria para si mesmo.

## Caminho dos binários (`bin-dir`) em binários

O `composer-runtime-api` `2.2.2` introduziu uma nova variável global
`$_composer_bin_dir` definida ao executar binários instalados com o Composer.
Leia mais sobre isso na [documentação de binários dos fornecedores][5].

Isso é definido pelo proxy binário e, como tal, não é disponibilizado para
projetos pelo script `vendor/autoload.php` do Composer.

[1]: uso-basico.md#autoloading

[2]: https://github.com/composer/composer/blob/main/src/Composer/InstalledVersions.php

[3]: config.md#platform-check

[4]: articles/vendor-binaries.md#finding-the-composer-autoloader-from-a-binary

[5]: articles/vendor-binaries.md#finding-the-composer-bin-dir-from-a-binary
