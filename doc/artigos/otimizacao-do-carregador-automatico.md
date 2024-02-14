<!--
tagline: Como reduzir o impacto no desempenho do carregador automático
source_url: https://github.com/composer/composer/blob/2.6/doc/articles/autoloader-optimization.md
revision: 0d236858eca397f7d910533580b0d3a4944444dd
status: wip
-->

# Otimização do carregador automático

Por padrão, o carregador automático do Composer é executado relativamente
rápido.
No entanto, devido à forma como as regras de carregamento automático da PSR-4 e
da PSR-0 são configuradas, é necessário verificar o sistema de arquivos antes de
resolver um nome de classe de forma conclusiva.
Isso torna as coisas um pouco mais lentas, mas é conveniente em ambientes de
desenvolvimento porque quando uma nova classe é adicionada, ela pode ser
descoberta/usada imediatamente sem a necessidade de reconstruir a configuração
do carregador automático.

O problema, entretanto, é que em produção geralmente queremos que as coisas
aconteçam o mais rápido possível, pois podemos reconstruir a configuração toda
vez que implantamos e novas classes não aparecem aleatoriamente entre as
implantações.

Por isso, o Composer oferece algumas estratégias para otimizar o carregador
automático.

> **Nota:** Essas otimizações **não devem** ser habilitadas em
> **desenvolvimento**, pois todas elas causarão vários problemas ao
> adicionar/remover classes.
> Os ganhos de desempenho não compensam o esforço em um ambiente de
> desenvolvimento.

## Otimização Nível 1: Geração de mapa de classe

### Como executá-la?

Existem algumas opções para habilitar isso:

- Definir `"optimize-autoloader": true` dentro da chave de configuração do
  `composer.json`.
- Executar `install` ou `update` com `-o` ou `--optimize-autoloader`.
- Executar `dump-autoload` com `-o` ou `--optimize`.

### What does it do?

Class map generation essentially converts PSR-4/PSR-0 rules into classmap rules.
This makes everything quite a bit faster as for known classes the class map
returns instantly the path, and Composer can guarantee the class is in there so
there is no filesystem check needed.

On PHP 5.6+, the class map is also cached in opcache which improves the initialization
time greatly. If you make sure opcache is enabled, then the class map should load
almost instantly and then class loading is fast.

### Trade-offs

There are no real trade-offs with this method. It should always be enabled in
production.

The only issue is it does not keep track of autoload misses (i.e., when
it cannot find a given class), so those fallback to PSR-4 rules and can still
result in slow filesystem checks. To solve this issue two Level 2 optimization
options exist, and you can decide to enable either if you have a lot of
class_exists checks that are done for classes that do not exist in your project.

## Optimization Level 2/A: Authoritative class maps

### How to run it?

There are a few options to enable this:

- Set `"classmap-authoritative": true` inside the config key of composer.json
- Call `install` or `update` with `-a` / `--classmap-authoritative`
- Call `dump-autoload` with `-a` / `--classmap-authoritative`

### What does it do?

Enabling this automatically enables Level 1 class map optimizations.

This option says that if something is not found in the classmap,
then it does not exist and the carregador automático should not attempt to look on the
filesystem according to PSR-4 rules.

### Trade-offs

This option makes the carregador automático always return very quickly. On the flipside it
also means that in case a class is generated at runtime for some reason, it will
not be allowed to be autoloaded. If your project or any of your dependencies does that
then you might experience "class not found" issues in production. Enable this with care.

> Note: This cannot be combined with Level 2/B optimizations. You have to choose one as
> they address the same issue in different ways.

## Optimization Level 2/B: APCu cache

### How to run it?

There are a few options to enable this:

- Set `"apcu-carregador automático": true` inside the config key of composer.json
- Call `install` or `update` with `--apcu-carregador automático`
- Call `dump-autoload` with `--apcu`

### What does it do?

This option adds an APCu cache as a fallback for the class map. It will not
automatically generate the class map though, so you should still enable Level 1
optimizations manually if you so desire.

Whether a class is found or not, that fact is always cached in APCu, so it can be
returned quickly on the next request.

### Trade-offs

This option requires APCu which may or may not be available to you. It also
uses APCu memory for autoloading purposes, but it is safe to use and cannot
result in classes not being found like the authoritative class map
optimization above.

> Note: This cannot be combined with Level 2/A optimizations. You have to choose one as
> they address the same issue in different ways.
