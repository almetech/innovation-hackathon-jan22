defmodule Eoq.Inventory.Order do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "orders" do
    field :price, :float
    field :quantity, :integer
    field :product_id, :binary_id
    field :date, :date

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:quantity, :price, :date])
    |> validate_required([:quantity, :price])
  end
end
