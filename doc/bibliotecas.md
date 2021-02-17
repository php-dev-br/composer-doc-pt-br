# Bibliotecas

Este capítulo mostrará como tornar a sua biblioteca instalável através do
Composer.

## Todo Projeto É um Pacote

Assim que você tiver um arquivo `composer.json` num diretório, esse diretório
será um pacote. Ao adicionar um [`require`][book-require] a um projeto, você
está criando um pacote que depende de outros pacotes. A única diferença entre o
seu projeto e uma biblioteca é que o seu projeto é um pacote sem nome.

Para tornar esse pacote instalável, você precisa dar um nome a ele. Você faz
isso adicionando a propriedade [`name`][book-name] ao `composer.json`:

```json
{
    "name": "acme/ola-mundo",
    "require": {
        "monolog/monolog": "1.0.*"
    }
}
```

Nesse caso, o nome do projeto é `acme/ola-mundo`, onde `acme` é o nome do
vendor. Fornecer o nome do vendor é obrigatório.

> **Nota:** Se você não sabe o que usar como nome do vendor, o seu nome de
> usuário do GitHub geralmente é uma boa aposta. Embora os nomes de pacotes não
> façam distinção entre maiúsculas e minúsculas, a convenção é usar apenas
> minúsculas e hífen para separar as palavras.

## Versionamento de Biblioteca

Na grande maioria dos casos, você manterá a sua biblioteca usando algum tipo de
sistema de controle de versão como git, svn, hg ou fossil. Nesses casos, o
Composer deduz as versões a partir do seu VCS e você **não deve** especificar
uma versão no arquivo `composer.json`. (Consulte o [artigo sobre versões]
[article-versions] para saber como o Composer usa branches e tags do VCS para
resolver as restrições de versão.)

Se você estiver mantendo pacotes manualmente (ou seja, sem um VCS), precisará
especificar a versão explicitamente, adicionando uma propriedade `version` no
arquivo `composer.json`:

```json
{
    "version": "1.0.0"
}
```

> **Nota:** Quando você adiciona uma versão fixa no código ao VCS, a versão
> entrará em conflito com os nomes das tags. O Composer não será capaz de
> determinar o número da versão.

### Versionamento do VCS

O Composer usa as tags e branches do VCS para resolver as restrições de versão
que você especifica no campo [`require`][book-require] para conjuntos
específicos de arquivos. Ao determinar as versões válidas disponíveis, o
Composer examina todas as suas tags e branches, e converte os seus nomes para
uma lista interna de opções que, em seguida, compara com a restrição de versão
que você forneceu.

Para saber mais sobre como o Composer trata tags e branches e como ele resolve
as restrições de versão de pacote, leia o artigo sobre [versões]
[article-versions].

## Arquivo Lock

Para a sua biblioteca, você pode fazer o commit do arquivo `composer.lock`, se
desejar. Isso pode ajudar o seu time a testar sempre as mesmas versões das
dependências. No entanto, esse arquivo lock não terá nenhum efeito em outros
projetos que dependem da sua biblioteca. Ele só afeta o projeto principal.

Se você não deseja fazer o commit do arquivo lock e estiver usando o git,
adicione-o ao `.gitignore`.

## Publicando em um VCS

Após ter um repositório VCS (sistema de controle de versão, por exemplo, git)
contendo um arquivo `composer.json`, sua biblioteca já pode ser instalada pelo
Composer. Neste exemplo, publicaremos a biblioteca `acme/ola-mundo` no GitHub em
`github.com/<usuario>/ola-mundo`.

Agora, para testar a instalação do pacote `acme/ola-mundo`, criaremos um projeto
localmente. Iremos chamá-lo `acme/blog`. Este blog dependerá do
`acme/ola-mundo`, que depende do `monolog/monolog`. Podemos fazer isso criando
um novo diretório `blog` em algum lugar, contendo um `composer.json`:

```json
{
    "name": "acme/blog",
    "require": {
        "acme/ola-mundo": "dev-master"
    }
}
```

O nome não é necessário neste caso, pois não queremos publicar o blog como uma
biblioteca. Ele é adicionado aqui para esclarecer qual `composer.json` está
sendo descrito.

Agora precisamos informar à aplicação do blog onde encontrar a dependência
`ola-mundo`. Fazemos isso adicionando uma especificação de repositório de
pacotes ao `composer.json` do blog:

```json
{
    "name": "acme/blog",
    "repositories": [
        {
            "type": "vcs",
            "url": "https://github.com/<usuario>/ola-mundo"
        }
    ],
    "require": {
        "acme/ola-mundo": "dev-master"
    }
}
```

Para obter mais detalhes sobre como os repositórios de pacotes funcionam e quais
outros tipos estão disponíveis, consulte [Repositórios][book-repos].

Isso é tudo. Agora você pode instalar as dependências executando o comando
[`install`][book-install] do Composer!

**Recapitulando:** Qualquer repositório git/svn/hg/fossil que contenha um
`composer.json` pode ser adicionado ao seu projeto especificando o repositório
do pacote e declarando a dependência no campo [`require`][book-require].

## Publicando no Packagist

Tudo bem, agora você pode publicar pacotes. Mas especificar o repositório VCS o
tempo todo é complicado. Você não quer forçar todos os seus usuários a fazer
isso.

A outra coisa que você deve ter notado é que não especificamos um repositório de
pacotes para o `monolog/monolog`. Como isso funcionou? A resposta é Packagist.

O [Packagist][page-packagist] é o principal repositório de pacotes do Composer e
está habilitado por padrão. Tudo o que é publicado no Packagist está disponível
automaticamente através do Composer. Como o [Monolog está no Packagist]
[page-monolog], podemos depender dele sem precisar especificar repositórios
adicionais.

Se quiséssemos compartilhar o `ola-mundo` com o mundo, também iríamos publicá-lo
no Packagist.

Você acessa o [Packagist][page-packagist] e clica no botão “Submit”. Você será
solicitado a se inscrever, caso ainda não o tenha feito, e então poderá enviar o
URL do seu repositório VCS. A partir daí, o Packagist começará a pesquisá-lo.
Feito isso, o seu pacote estará disponível para qualquer pessoa!

[article-versions]: artigos/versions.md
[book-install]: cli.md#install-i
[book-name]: esquema.md#name
[book-repos]: repositorios.md
[book-require]: esquema.md#require
[page-monolog]: https://packagist.org/packages/monolog/monolog
[page-packagist]: https://packagist.org/
