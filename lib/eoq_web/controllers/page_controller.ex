defmodule EoqWeb.PageController do
  use EoqWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
