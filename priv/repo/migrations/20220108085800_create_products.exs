defmodule Eoq.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :external_product_id, :string
      add :seller_id, references(:sellers, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create unique_index(:products, [:seller_id, :external_product_id])
  end
end
