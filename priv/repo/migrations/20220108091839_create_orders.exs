defmodule Eoq.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :quantity, :integer
      add :price, :float
      add :product_id, references(:products, on_delete: :delete_all, type: :binary_id)
      add :date, :date

      timestamps()
    end

    create unique_index(:orders, [:product_id, :date])
  end
end
