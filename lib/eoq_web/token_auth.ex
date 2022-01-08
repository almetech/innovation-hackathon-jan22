defmodule EoqWeb.TokenAuth do
  import Plug.Conn
  require Logger

  @token_age_secs 30 * 24 * 60 * 60

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, data} <- verify(token) do
      conn
      |> assign(:seller_id, data.seller_id)
    else
      error ->
        conn
        |> put_status(:unauthorized)
        |> Phoenix.Controller.put_view(EoqWeb.ErrorView)
        |> Phoenix.Controller.render(:"401")
        |> halt()
    end
  end

  def sign(seller_id) do
    Phoenix.Token.sign(EoqWeb.Endpoint, secret_key(), %{seller_id: seller_id})
  end

  def verify(token) do
    case Phoenix.Token.verify(EoqWeb.Endpoint, secret_key(), token,
             max_age: @token_age_secs
           ) do
      {:ok, data} -> {:ok, data}
      _error -> {:error, :unauthenticated}
    end
  end

  def secret_key do
    Application.get_env(:eoq, EoqWeb.Endpoint)[:secret_key_base]
  end
end
