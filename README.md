# Eoq

### API endpoints

#### Authentication

The app uses Bearer tokens to authenticate the client.
Use the header `Authentication` with the value `Bearer <token>` to authenticate
the API requests.

1. Create a product with the variables for lot size optimization model.

Endpoint: `POST /api/products`

Parameters
```
{
  "product": {
    "id": string, // Product ID or SKU in the seller app.
    "name": string, // Product name.
    "service_level": integer, // Service level, example: 95
    "lead_time_days": integer, // Delivery time after placing inventory orders
    "review_time_days": integer // Frequency of ordering inventory in days
  }
}
```

Response: `201`

2. Update a product and the variables used for lot size optimization.

Endpoint: `PUT /api/products`

Parameters
```
{
  "id": string, // Product ID or SKU in the seller app.
  "product": {
    "name": string, // Product name.
    "service_level": integer, // Service level, example: 95
    "lead_time_days": integer, // Delivery time after placing inventory orders
    "review_time_days": integer // Frequency of ordering inventory in days
  }
}
```

Response: `200`

3. Create an order

Endpoint: `POST /api/orders`

Parameters
```
{
  order: {
    product_id: string, // Product ID or SKU in the seller app.
    quantity: integer, // Order quantity
    price: float, // Unit price
    date: ISO8601 date // Optional order date, defaults to current date
  }
}
```

Response: `201`

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
