defmodule Eoq.InventoryFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Eoq.Inventory` context.
  """

  @doc """
  Generate a product.
  """
  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Eoq.Inventory.create_product()

    product
  end

  @doc """
  Generate a order.
  """
  def order_fixture(attrs \\ %{}) do
    {:ok, order} =
      attrs
      |> Enum.into(%{
        price: 120.5,
        quantity: 42
      })
      |> Eoq.Inventory.create_order()

    order
  end
end
