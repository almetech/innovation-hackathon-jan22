defmodule EoqWeb.Router do
  use EoqWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {EoqWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :assign_default_seller
  end

  pipeline :api do
    plug :accepts, ["json"]

    resources "/orders", EoqWeb.OrderController, only: [:create]
  end

  scope "/", EoqWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/sellers", SellerController
    resources "/products", ProductController
  end

  # Other scopes may use custom stacks.
  # scope "/api", EoqWeb do
  #   pipe_through :api
  # end
  def assign_default_seller(conn, _) do
    conn
    |> Plug.Conn.assign(:seller_id, "3daa0587-9327-4112-a79a-d5cc1482a52d")
  end
end
