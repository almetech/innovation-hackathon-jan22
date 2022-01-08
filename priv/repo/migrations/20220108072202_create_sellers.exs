defmodule Eoq.Repo.Migrations.CreateSellers do
  use Ecto.Migration

  def change do
    create table(:sellers, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :external_seller_id, :string

      timestamps()
    end

    create index(:sellers, [:external_seller_id])
  end
end
