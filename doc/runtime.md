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

O `composer-runtime-api` 2.0 introduziu uma nova classe
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

O método `getInstalledPackagesByType` aceita um tipo de pacote (por exemplo,
`foo-plugin`) e lista os pacotes desse tipo que estão instalados.
Se necessário, é possível usar os métodos acima para recuperar mais informações
sobre cada pacote.

Este método deve aliviar a necessidade de instaladores personalizados colocarem
plug-ins em um caminho específico, em vez de deixá-los no diretório do
fornecedor.
You can then find plugins to initialize at runtime
via InstalledVersions, including their paths via getInstallPath if needed.

```php
\Composer\InstalledVersions::getInstalledPackagesByType('foo-plugin');
```

> Disponível a partir do Composer 2.1 (ou seja, `composer-runtime-api ^2.1`).

## Platform check

composer-runtime-api 2.0 introduced a new `vendor/composer/platform_check.php` file, which
is included automatically when you include the Composer autoloader.

It verifies that platform requirements (i.e., php and php extensions) are fulfilled
by the PHP process currently running. If the requirements are not met, the script
prints a warning with the missing requirements and exits with code 104.

To avoid an unexpected white page of death with some obscure PHP extension warning in
production, you can run `composer check-platform-reqs` as part of your
deployment/build and if that returns a non-0 code you should abort.

The default value is `php-only` which only checks the PHP version.

If you for some reason do not want to use this safety check, and would rather
risk runtime errors when your code executes, you can disable this by setting the
[`platform-check`](06-config.md#platform-check) config option to `false`.

If you want the check to include verifying the presence of PHP extensions,
set the config option to `true`. `ext-*` requirements will then be verified
but for performance reasons Composer only checks the extension is present,
not its exact version.

`lib-*` requirements are never supported/checked by the platform check feature.

## Autoloader path in binaries

composer-runtime-api 2.2 introduced a new `$_composer_autoload_path` global
variable set when running binaries installed with Composer. Read more
about this [on the vendor binaries docs](articles/vendor-binaries.md#finding-the-composer-autoloader-from-a-binary).

This is set by the binary proxy and as such is not made available to projects
by Composer's `vendor/autoload.php`, which would be useless as it would point back
to itself.

## Binary (bin-dir) path in binaries

composer-runtime-api 2.2.2 introduced a new `$_composer_bin_dir` global
variable set when running binaries installed with Composer. Read more
about this [on the vendor binaries docs](articles/vendor-binaries.md#finding-the-composer-bin-dir-from-a-binary).

This is set by the binary proxy and as such is not made available to projects
by Composer's `vendor/autoload.php`.

[1]: uso-basico.md#autoloading

[2]: https://github.com/composer/composer/blob/main/src/Composer/InstalledVersions.php
