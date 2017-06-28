defmodule Shipping.Web.Tracking.CargoControllerTest do
  use Shipping.Web.ConnCase

  alias Shipping.Tracking

  @create_attrs %{status: "some status", tracking_id: "some tracking_id"}
  @update_attrs %{status: "some updated status", tracking_id: "some updated tracking_id"}
  @invalid_attrs %{status: nil, tracking_id: nil}

  def fixture(:cargo) do
    {:ok, cargo} = Tracking.create_cargo(@create_attrs)
    cargo
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, tracking_cargo_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing Cargoes"
  end

  test "renders form for new cargoes", %{conn: conn} do
    conn = get conn, tracking_cargo_path(conn, :new)
    assert html_response(conn, 200) =~ "New Cargo"
  end

  test "creates cargo and redirects to show when data is valid", %{conn: conn} do
    conn = post conn, tracking_cargo_path(conn, :create), cargo: @create_attrs

    assert %{id: id} = redirected_params(conn)
    assert redirected_to(conn) == tracking_cargo_path(conn, :show, id)

    conn = get conn, tracking_cargo_path(conn, :show, id)
    assert html_response(conn, 200) =~ "Show Cargo"
  end

  test "does not create cargo and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, tracking_cargo_path(conn, :create), cargo: @invalid_attrs
    assert html_response(conn, 200) =~ "New Cargo"
  end

  test "renders form for editing chosen cargo", %{conn: conn} do
    cargo = fixture(:cargo)
    conn = get conn, tracking_cargo_path(conn, :edit, cargo)
    assert html_response(conn, 200) =~ "Edit Cargo"
  end

  test "updates chosen cargo and redirects when data is valid", %{conn: conn} do
    cargo = fixture(:cargo)
    conn = put conn, tracking_cargo_path(conn, :update, cargo), cargo: @update_attrs
    assert redirected_to(conn) == tracking_cargo_path(conn, :show, cargo)

    conn = get conn, tracking_cargo_path(conn, :show, cargo)
    assert html_response(conn, 200) =~ "some updated status"
  end

  test "does not update chosen cargo and renders errors when data is invalid", %{conn: conn} do
    cargo = fixture(:cargo)
    conn = put conn, tracking_cargo_path(conn, :update, cargo), cargo: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit Cargo"
  end

  test "deletes chosen cargo", %{conn: conn} do
    cargo = fixture(:cargo)
    conn = delete conn, tracking_cargo_path(conn, :delete, cargo)
    assert redirected_to(conn) == tracking_cargo_path(conn, :index)
    assert_error_sent 404, fn ->
      get conn, tracking_cargo_path(conn, :show, cargo)
    end
  end
end
