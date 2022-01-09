defmodule Eoq.Inventory.Product do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "products" do
    field :name, :string
    field :seller_id, :binary_id
    field :external_product_id, :string

    field :lead_time_days, :integer, virtual: true
    field :review_time_days, :integer, virtual: true
    field :service_level, :integer, virtual: true
    field :cost_holding, :float, virtual: true
    field :cost_stockout, :float, virtual: true
    field :price, :float, virtual: true

    has_many :product_params, Eoq.Inventory.ProductParam

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :external_product_id])
    |> validate_required([:name])
  end
end
