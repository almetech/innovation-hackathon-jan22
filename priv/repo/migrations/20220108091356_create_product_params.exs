defmodule Eoq.Repo.Migrations.CreateProductParams do
  use Ecto.Migration

  def change do
    create table(:product_params, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :cost_ordering, :float
      add :cost_holding, :float
      add :cost_stockout, :float
      add :price, :float
      add :demand_cumulative, :integer
      add :demand_daily, :integer
      add :demand_std_deviation, :integer
      add :service_level, :integer
      add :lead_time_days, :integer
      add :review_time_days, :integer
      add :lot_size, :integer
      add :optimum_service_level, :integer
      add :optimum_lot_size, :integer
      add :optimum_cost, :float
      add :cost, :float
      add :product_id, references(:products, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create index(:product_params, [:product_id])
  end
end
