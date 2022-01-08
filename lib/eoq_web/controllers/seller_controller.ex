defmodule EoqWeb.SellerController do
  use EoqWeb, :controller

  plug :put_layout, "admin.html"

  alias Eoq.Account
  alias Eoq.Account.Seller

  def index(conn, _params) do
    sellers = Account.list_sellers()
    render(conn, "index.html", sellers: sellers)
  end

  def new(conn, _params) do
    changeset = Account.change_seller(%Seller{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"seller" => seller_params}) do
    case Account.create_seller(seller_params) do
      {:ok, seller} ->
        conn
        |> put_flash(:info, "Seller created successfully.")
        |> redirect(to: Routes.seller_path(conn, :show, seller))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    seller = Account.get_seller!(id)
    render(conn, "show.html", seller: seller)
  end

  def edit(conn, %{"id" => id}) do
    seller = Account.get_seller!(id)
    changeset = Account.change_seller(seller)
    render(conn, "edit.html", seller: seller, changeset: changeset)
  end

  def update(conn, %{"id" => id, "seller" => seller_params}) do
    seller = Account.get_seller!(id)

    case Account.update_seller(seller, seller_params) do
      {:ok, seller} ->
        conn
        |> put_flash(:info, "Seller updated successfully.")
        |> redirect(to: Routes.seller_path(conn, :show, seller))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", seller: seller, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    seller = Account.get_seller!(id)
    {:ok, _seller} = Account.delete_seller(seller)

    conn
    |> put_flash(:info, "Seller deleted successfully.")
    |> redirect(to: Routes.seller_path(conn, :index))
  end
end
