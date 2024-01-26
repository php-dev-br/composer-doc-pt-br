<!--
    tagline: Cria apelidos de nomes de branch para versões
    version: ceec6ff8e2a2cdf5becf5eab25a3d379181c9115
-->

# Apelidos

## Por que Apelidos?

Ao usar um repositório VCS, serão obtidas apenas versões comparáveis dos
branches que parecem versões, como `2.0` ou `2.0.x`. Para o branch `master`,
será obtida uma versão `dev-master`. Para o branch `bugfix`, será obtida uma
versão `dev-bugfix`.

Se o branch `master` for usado para criar tags de lançamento da linha de
desenvolvimento `1.0`, ou seja, `1.0.1`, `1.0.2`, `1.0.3`, etc., qualquer pacote
que dependa dele provavelmente exigirá a versão `1.0.*`.

Se alguém quiser exigir o `dev-master` mais recente, terá um problema: outros
pacotes podem exigir `1.0.*`, portanto, exigir essa versão de desenvolvimento
levará a conflitos, pois `dev-master` não corresponde à restrição `1.0.*`.

É aí que entram os apelidos.

## Apelidos de branch

O branch `dev-master` está no repositório VCS principal. É relativamente comum
que alguém queira a versão de desenvolvimento `master` mais recente. Assim, o
Composer permite apelidar o branch `dev-master` como uma versão `1.0.x-dev`.
Isso é feito especificando um campo `branch-alias` na seção `extra` do
`composer.json`:

```json
{
    "extra": {
        "branch-alias": {
            "dev-master": "1.0.x-dev"
        }
    }
}
```

Se uma versão não-comparável (como `dev-develop`) for apelidada, o nome do
branch deve ser prefixo com `dev-`. Uma versão comparável (ou seja, que começa
com números e termina com `.x-dev`), também pode ser apelidada, mas apenas como
uma versão mais específica.
Por exemplo, `1.x-dev` pode ser apelidada como `1.2.x-dev`.

O apelido deve ser uma versão de desenvolvimento comparável e o campo
`branch-alias` deve estar no branch ao qual faz referência. Para `dev-master`,
é necessário fazer o commit no branch `master`.

Como resultado, qualquer pessoa agora pode exigir `1.0.*`, e a versão
`dev-master` será instalada sem problemas.

Para usar apelidos de branch, é necessário possuir o repositório do pacote que
está sendo apelidado. Se quiser apelidar um pacote de terceiros sem manter um
fork dele, use apelidos em linha como descrito abaixo.

## Exigindo apelidos em linha

Os apelidos de branch são ótimos para apelidar as linhas de desenvolvimento
principais. Mas para usá-los, é preciso ter controle sobre o repositório de
origem e fazer o commit das mudanças no controle de versão.

Não é divertido quando queremos testar uma correção de uma falha de alguma
biblioteca que é uma dependência do projeto local.

Por esse motivo, é possível criar apelidos de pacotes nos campos `require` e
`require-dev`. Digamos que uma falha foi encontrada no pacote `monolog/monolog`.
O repositório [Monolog][page-github-monolog] foi clonado no GitHub e o problema
foi corrigido em um branch chamado `bugfix`. Agora, queremos instalar essa
versão do monolog no projeto local.

O pacote `symfony/monolog-bundle` está sendo usado e requer o `monolog/monolog`
na versão `1.*`. Então, é necessário que a versão `dev-bugfix` corresponda a
essa restrição.

Adicione isso ao `composer.json` na raiz do projeto:

```json
{
    "repositories": [
        {
            "type": "vcs",
            "url": "https://github.com/voce/monolog"
        }
    ],
    "require": {
        "symfony/monolog-bundle": "2.0",
        "monolog/monolog": "dev-bugfix as 1.0.x-dev"
    }
}
```

Ou deixe o Composer fazer o trabalho com:

```shell
php composer.phar require "monolog/monolog:dev-bugfix as 1.0.x-dev"
```

Isso buscará a versão `dev-bugfix` do `monolog/monolog` no GitHub e a apelidará
como `1.0.x-dev`.

> **Nota:** Apelidos em linha são um recurso do [pacote raiz][root-package]. Se
> um pacote com apelidos em linha for necessário, o apelido (à direita de `as`)
> será usado como restrição de versão. A parte à esquerda de `as` será
> descartada. Como consequência, se A requer B e B requer a versão
> `monolog/monolog` `dev-bugfix as 1.0.x-dev`, a instalação de A fará B requerer
> `1.0.x-dev`, que pode existir como um apelido de branch ou um branch `1.0`
> real. Se não existir, ele deve ser apelidado novamente no `composer.json` de
> A.

> **Nota:** Apelidos em linha devem ser evitados, especialmente em bibliotecas e
> pacotes publicados. Se uma falha for encontrada, tente enviar a correção para
> o repositório original.
> Isso ajuda a evitar problemas para os usuários do pacote.

[root-package]: ../esquema.md#pacote-raiz
[page-github-monolog]: https://github.com/Seldaek/monolog
