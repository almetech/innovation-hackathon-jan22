defmodule Eoq.Inventory.ProductParam do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "product_params" do
    field :cost_holding, :float
    field :cost_ordering, :float
    field :cost_stockout, :float
    field :demand_cumulative, :integer
    field :demand_daily, :integer
    field :demand_std_deviation, :integer
    field :lead_time_days, :integer
    field :lot_size, :integer
    field :price, :float
    field :review_time_days, :integer
    field :service_level, :integer
    field :optimum_service_level, :integer
    field :optimum_lot_size, :integer
    field :optimum_cost, :float
    field :cost, :float
    field :product_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(product_param, attrs) do
    product_param
    |> cast(attrs, [
      :cost_ordering,
      :cost_holding,
      :cost_stockout,
      :price,
      :demand_cumulative,
      :demand_daily,
      :demand_std_deviation,
      :service_level,
      :lead_time_days,
      :review_time_days,
      :lot_size,
      :optimum_service_level,
      :optimum_lot_size,
      :optimum_cost,
      :cost
    ])
  end
end
