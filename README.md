# Eoq

### Schema

Seller
======
name: string

Product
=======
seller_id: references(Seller)
name: string

ProductParam
============
product_id: references(Product)
cost_ordering
cost_holding
cost_stockout
price
demand_cumulative
demand_daily
demand_std_deviation
service_level
lead_time
eoq
timestamp

Order
=====
product_id: string
quantity: string

### Setup

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
