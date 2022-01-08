defmodule Eoq.Inventory do
  @moduledoc """
  The Inventory context.
  """

  import Ecto.Query, warn: false
  alias Eoq.Repo

  alias Eoq.Inventory.{Product, ProductParam, Order}
  alias Eoq.Account

  @doc """
  Returns the list of products.

  ## Examples

      iex> list_products()
      [%Product{}, ...]

  """
  def list_products(seller_id) do
    preload_query =
      from pp in ProductParam,
      order_by: [desc: :inserted_at],
      limit: 1

    query =
      from p in Product,
      where: p.seller_id == ^seller_id,
      preload: [product_params: ^preload_query]
    Repo.all(query)
  end

  def all_products do
    preload_query =
      from pp in ProductParam,
      order_by: [desc: :inserted_at],
      limit: 1

    query =
      from p in Product,
      preload: [product_params: ^preload_query]
    Repo.all(query)
  end

  @doc """
  Gets a single product.

  Raises `Ecto.NoResultsError` if the Product does not exist.

  ## Examples

      iex> get_product!(123)
      %Product{}

      iex> get_product!(456)
      ** (Ecto.NoResultsError)

  """
  def get_product!(id), do: Repo.get!(Product, id)

  def get_product_by_external_id!(ext_id, seller_id) do
    Repo.get_by!(Product, external_product_id: ext_id, seller_id: seller_id)
  end

  def get_product_with_latest_param!(id) do
    preload_query =
      from pp in ProductParam,
      order_by: [desc: :inserted_at],
      limit: 1
    product = Repo.get!(Product, id) |> Repo.preload(product_params: preload_query)
    [product_param] = product.product_params
    %{product | lead_time_days: product_param.lead_time_days, review_time_days: product_param.review_time_days, service_level: product_param.service_level}
  end

  def create_product(attrs \\ %{}, seller_id) do
    Repo.transaction(fn ->
      product =
        %Product{seller_id: seller_id}
        |> Product.changeset(attrs)
        |> Repo.insert!()

      create_product_param!(attrs, product.id)
    end)
  end

  @doc """
  Updates a product.

  ## Examples

      iex> update_product(product, %{field: new_value})
      {:ok, %Product{}}

      iex> update_product(product, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_product(%Product{} = product, attrs) do
    Repo.transaction(fn ->
      product =
        product
        |> Product.changeset(attrs)
        |> Repo.update!()

      create_product_param!(attrs, product.id)
    end)
  end

  def create_product_param!(attrs, product_id) do
    %ProductParam{service_level: 95, product_id: product_id}
    |> ProductParam.changeset(attrs)
    |> Repo.insert!()
  end

  def update_product_param!(attrs, product_param_id) do
    product_param = Repo.get!(ProductParam, product_param_id)
    product_param
    |> ProductParam.changeset(attrs)
    |> Repo.update!()
  end

  @doc """
  Deletes a product.

  ## Examples

      iex> delete_product(product)
      {:ok, %Product{}}

      iex> delete_product(product)
      {:error, %Ecto.Changeset{}}

  """
  def delete_product(%Product{} = product) do
    Repo.delete(product)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product changes.

  ## Examples

      iex> change_product(product)
      %Ecto.Changeset{data: %Product{}}

  """
  def change_product(%Product{} = product, attrs \\ %{}) do
    Product.changeset(product, attrs)
  end

  alias Eoq.Inventory.Order

  @doc """
  Returns the list of orders.

  ## Examples

      iex> list_orders()
      [%Order{}, ...]

  """
  def list_orders do
    Repo.all(Order)
  end

  @doc """
  Gets a single order.

  Raises `Ecto.NoResultsError` if the Order does not exist.

  ## Examples

      iex> get_order!(123)
      %Order{}

      iex> get_order!(456)
      ** (Ecto.NoResultsError)

  """
  def get_order!(id), do: Repo.get!(Order, id)

  def save_order(ext_order_params, seller_id) do
    product = get_product_by_external_id!(ext_order_params["product_id"], seller_id)
    quantity = ext_order_params["quantity"]
    date = ext_order_params["date"]

    date =
      if date do
        Date.from_iso8601!(date)
      else
        Date.utc_today()
      end

    quantity =
      if is_binary(quantity) do
        String.to_integer(quantity)
      else
        quantity
      end


    %Order{product_id: product.id}
    |> Order.changeset(%{
      price: ext_order_params["price"],
      quantity: ext_order_params["quantity"],
      date: date
    })
    |> Repo.insert(conflict_target: [:product_id, :date], on_conflict: [inc: [quantity: quantity]])
  end

  @doc """
  Creates a order.

  ## Examples

      iex> create_order(%{field: value})
      {:ok, %Order{}}

      iex> create_order(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_order(attrs \\ %{}) do
    %Order{}
    |> Order.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a order.

  ## Examples

      iex> update_order(order, %{field: new_value})
      {:ok, %Order{}}

      iex> update_order(order, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_order(%Order{} = order, attrs) do
    order
    |> Order.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a order.

  ## Examples

      iex> delete_order(order)
      {:ok, %Order{}}

      iex> delete_order(order)
      {:error, %Ecto.Changeset{}}

  """
  def delete_order(%Order{} = order) do
    Repo.delete(order)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking order changes.

  ## Examples

      iex> change_order(order)
      %Ecto.Changeset{data: %Order{}}

  """
  def change_order(%Order{} = order, attrs \\ %{}) do
    Order.changeset(order, attrs)
  end

  def last_month_orders(product) do
    product_id = product.id

    query =
      from o in Order,
      where: o.date >= ago(30, "day"),
      where: o.product_id == ^product_id

    Repo.all(query)
  end

  def latest_product_params do
    query =
      from pp in ProductParam,
      where: is_nil(pp.lot_size),
      distinct: pp.product_id,
      select: pp.product_id

    Repo.all(query)
  end
end