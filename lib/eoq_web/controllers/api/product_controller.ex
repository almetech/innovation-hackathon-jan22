defmodule EoqWeb.Api.ProductController do
  use EoqWeb, :controller

  alias Eoq.Inventory

  action_fallback EoqWeb.FallbackController

  # Params:
  # {
  #   "product": {
  #     "id": string, // Product ID or SKU in the seller app.
  #     "name": string, // Product name.
  #     "service_level": integer, // Service level, example: 95
  #     "lead_time_days": integer, // Delivery time after placing inventory orders
  #     "review_time_days": integer, // Frequency of ordering inventory in days
  #     "cost_holding": float, // Estimated holding cost of inventory for a month as percentage of price of product.
  #     "cost_stockout": float // Percentage of the price of the product.
  #   }
  # }
  def create(conn, %{"product" => product_params}) do
    product_params = Map.put(product_params, "external_product_id", product_params["id"])
    case Inventory.create_product(product_params, conn.assigns.seller_id) do
      {:ok, _} ->
        send_resp(conn, :created, "")
    end
  end

  # Params:
  # {
  #   "id": string, // Product ID or SKU in the seller app.
  #   "product": {
  #     "name": string, // Product name.
  #     "service_level": integer, // Service level, example: 95
  #     "lead_time_days": integer, // Delivery time after placing inventory orders
  #     "review_time_days": integer, // Frequency of ordering inventory in days
  #     "cost_holding": float, // Estimated holding cost of inventory for a month as percentage of price of product.
  #     "cost_stockout": float // Percentage of the price of the product.
  #   }
  # }
  def update(conn, %{"id" => id, "product" => product_params}) do
    product = Inventory.get_product_by_external_id!(id, conn.assigns.seller_id)
    product_params = Map.put(product_params, "external_product_id", id)

    case Inventory.update_product(product, product_params) do
      {:ok, _} ->
        send_resp(conn, :ok, "")
    end
  end
end
