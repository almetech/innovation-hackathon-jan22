defmodule Eoq.AccountFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Eoq.Account` context.
  """

  @doc """
  Generate a seller.
  """
  def seller_fixture(attrs \\ %{}) do
    {:ok, seller} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Eoq.Account.create_seller()

    seller
  end
end
