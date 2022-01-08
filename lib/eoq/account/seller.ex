defmodule Eoq.Account.Seller do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "sellers" do
    field :name, :string
    field :external_seller_id, :string

    timestamps()
  end

  @doc false
  def changeset(seller, attrs) do
    seller
    |> cast(attrs, [:name, :external_seller_id])
    |> validate_required([:name])
  end
end
