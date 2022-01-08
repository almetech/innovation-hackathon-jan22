defmodule Eoq.Repo do
  use Ecto.Repo,
    otp_app: :eoq,
    adapter: Ecto.Adapters.Postgres
end
