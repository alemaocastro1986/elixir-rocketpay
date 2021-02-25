# Rocketpay #NLW4


## Descrição
Desenvolvimento API de pagamentos, estilo PicPay

## Recursos
- Create users and accounts
- Deposit
- Withraw
- Transactions


### # Dia 1
- Fundamento do Elixir e Phoenix Framework
- Criação de novos projetos com Phoenix  
  - `mix phx.new rocketpay --no-webpack --no-html`
- Pattern Match
- Pipe operator `|>`

### # Dia 2
- Lindando com banco de dados com `Ecto`
  - migrations
    - generate `mix ecto.gen.migration <table_name>`
    - create - `mix ecto.migrate`
  - schemas
  - chageset
- Fluxo MVC Phoenix
  - routes
  - controller
  - views `.json`

  ### # Dia 3
- Separação por contextos
  - users
  - accounts
- Lindando com excessões com `Fallback Controller`
- Utilizando a library `Decimal` para trabalhar com valores monetários
- Otimizando execuções no banco com `Ecto.Mult`
- Transações com `Ecto.transaction`
- Criando relacionamentos e constraints no banco com `Ecto`
- Roteamento com parâmetros
- Padrão facade com `defdelegate`

### # Dia 4
- Refatorando regras de negócio aplicando o conceito de DRY
- Criação de custom structs com `defstruct`
- Criação de Atoms dinâmicos


# run project

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

