defmodule EoqWeb.Api.OrderController do
  use EoqWeb, :controller

  alias Eoq.Inventory
  alias Eoq.Inventory.Order

  action_fallback EoqWeb.FallbackController

  # Params:
  # {
  #   order: {
  #     product_id: string,
  #     order_id: string,
  #     quantity: integer,
  #     price: float,
  #     date: ISO8601 date (optional)
  #   }
  # }
  def create(conn, %{"order" => order_params}) do
    with {:ok, %Order{}} <- Inventory.save_order(order_params, conn.assigns.seller_id) do
      send_resp(conn, :created, "")
    end
  end
end
