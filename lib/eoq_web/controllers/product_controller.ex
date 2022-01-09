defmodule EoqWeb.ProductController do
  use EoqWeb, :controller

  plug :put_layout, "admin.html"

  alias Eoq.Inventory
  alias Eoq.Inventory.Product

  def index(conn, _params) do
    products = Inventory.list_products(conn.assigns.seller_id)
    render(conn, "index.html", products: products)
  end

  def new(conn, _params) do
    changeset = Inventory.change_product(%Product{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"product" => product_params}) do
    case Inventory.create_product(product_params, conn.assigns.seller_id) do
      {:ok, product} ->
        if product_params["randomize_orders"] == "true" do
          Inventory.randomize(product.id, conn.assigns.seller_id)
        end

        Eoq.Calculator.run_for_product(product.id)
        conn
        |> put_flash(:info, "Product created successfully.")
        |> redirect(to: Routes.product_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    product = Inventory.get_product!(id)
    render(conn, "show.html", product: product)
  end

  def edit(conn, %{"id" => id}) do
    product = Inventory.get_product_with_latest_param!(id)
    changeset = Inventory.change_product(product)
    render(conn, "edit.html", product: product, changeset: changeset)
  end

  def update(conn, %{"id" => id, "product" => product_params}) do
    product = Inventory.get_product!(id)

    case Inventory.update_product(product, product_params) do
      {:ok, _} ->
        if product_params["randomize_orders"] == "true" do
          Inventory.randomize(product.id, conn.assigns.seller_id)
        end

        Eoq.Calculator.run_for_product(product.id)
        conn
        |> put_flash(:info, "Product updated successfully.")
        |> redirect(to: Routes.product_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", product: product, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    product = Inventory.get_product!(id)
    {:ok, _product} = Inventory.delete_product(product)

    conn
    |> put_flash(:info, "Product deleted successfully.")
    |> redirect(to: Routes.product_path(conn, :index))
  end

  def reset(conn, _) do
    Inventory.randomize(conn.assigns.seller_id)
    Eoq.Calculator.run_all_sync()
    conn
    |> redirect(to: Routes.product_path(conn, :index))
  end
end
