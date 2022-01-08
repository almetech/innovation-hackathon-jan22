defmodule EoqWeb.OrderController do
  use EoqWeb, :controller

  alias Eoq.Inventory
  alias Eoq.Inventory.Order

  action_fallback EoqWeb.FallbackController

  # Params:
  # {
  #   order: {
  #     seller_id: string,
  #     product_id: string,
  #     order_id: string,
  #     quantity: integer,
  #     price: float
  #   }
  # }
  def create(conn, %{"order" => order_params}) do
    with {:ok, %Order{} = order} <- Inventory.save_order(order_params) do
      send_resp(conn, :created, "")
    end
  end
end
