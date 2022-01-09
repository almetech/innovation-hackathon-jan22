# Alme - Inventory management

Demo URL: https://alme.tech

This is the repository that houses the solution to the ONDC Grand Hackathon
Challenge 6 - Inventory Management.

### API endpoints

#### Request headers

The app uses Bearer tokens to authenticate the client.
Use the header `Authentication` with the value `Bearer <token>` to authenticate
the API requests. Also include `Content-Type` header with the value `application/json`.

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
    "review_time_days": integer, // Frequency of ordering inventory in days
    "cost_holding": float, // Estimated holding cost of inventory for a month as percentage of price of product.
    "cost_stockout": float // Percentage of the price of the product.
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
    "review_time_days": integer, // Frequency of ordering inventory in days
    "cost_holding": float, // Estimated holding cost of inventory for a month as percentage of price of product.
    "cost_stockout": float // Percentage of the price of the product.
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


### How to run the app locally

The first step is to make sure you have the following tools in your system:

```
erlang 24.1.1
nodejs 17.3.0
elixir 1.12.3

```

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
