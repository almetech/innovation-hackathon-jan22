defmodule EoqWeb.LayoutView do
  use EoqWeb, :view

  # Phoenix LiveDashboard is available only in development by default,
  # so we instruct Elixir to not warn if the dashboard route is missing.
  @compile {:no_warn_undefined, {Routes, :live_dashboard_path, 2}}

  def body_class(conn) do
    if conn.request_path == "/" do
      "custom-dark-bg"
    else
      ""
    end
  end
end
