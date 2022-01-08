defmodule EoqWeb.SellerControllerTest do
  use EoqWeb.ConnCase

  import Eoq.AccountFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  describe "index" do
    test "lists all sellers", %{conn: conn} do
      conn = get(conn, Routes.seller_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Sellers"
    end
  end

  describe "new seller" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.seller_path(conn, :new))
      assert html_response(conn, 200) =~ "New Seller"
    end
  end

  describe "create seller" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.seller_path(conn, :create), seller: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.seller_path(conn, :show, id)

      conn = get(conn, Routes.seller_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Seller"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.seller_path(conn, :create), seller: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Seller"
    end
  end

  describe "edit seller" do
    setup [:create_seller]

    test "renders form for editing chosen seller", %{conn: conn, seller: seller} do
      conn = get(conn, Routes.seller_path(conn, :edit, seller))
      assert html_response(conn, 200) =~ "Edit Seller"
    end
  end

  describe "update seller" do
    setup [:create_seller]

    test "redirects when data is valid", %{conn: conn, seller: seller} do
      conn = put(conn, Routes.seller_path(conn, :update, seller), seller: @update_attrs)
      assert redirected_to(conn) == Routes.seller_path(conn, :show, seller)

      conn = get(conn, Routes.seller_path(conn, :show, seller))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, seller: seller} do
      conn = put(conn, Routes.seller_path(conn, :update, seller), seller: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Seller"
    end
  end

  describe "delete seller" do
    setup [:create_seller]

    test "deletes chosen seller", %{conn: conn, seller: seller} do
      conn = delete(conn, Routes.seller_path(conn, :delete, seller))
      assert redirected_to(conn) == Routes.seller_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.seller_path(conn, :show, seller))
      end
    end
  end

  defp create_seller(_) do
    seller = seller_fixture()
    %{seller: seller}
  end
end
