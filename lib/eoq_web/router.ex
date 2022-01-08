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
    plug EoqWeb.TokenAuth
  end

  scope "/", EoqWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/sellers", SellerController
    resources "/products", ProductController
  end

  # Other scopes may use custom stacks.
  scope "/api", EoqWeb.Api do
    pipe_through :api

    post "/orders", OrderController, :create

    post "/products", ProductController, :create
    put "/products", ProductController, :update
  end

  def assign_default_seller(conn, _) do
    conn
    |> Plug.Conn.assign(:seller_id, "3daa0587-9327-4112-a79a-d5cc1482a52d")
  end
end
