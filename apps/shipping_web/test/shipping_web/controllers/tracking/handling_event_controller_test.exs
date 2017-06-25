defmodule Shipping.Web.Tracking.HandlingEventControllerTest do
  use Shipping.Web.ConnCase

  alias Shipping.Tracking

  @create_attrs %{cargoId: "some cargoId", completionTime: "some completionTime", locationId: "some locationId", registrationTime: "some registrationTime", type: "some type"}
  @update_attrs %{cargoId: "some updated cargoId", completionTime: "some updated completionTime", locationId: "some updated locationId", registrationTime: "some updated registrationTime", type: "some updated type"}
  @invalid_attrs %{cargoId: nil, completionTime: nil, locationId: nil, registrationTime: nil, type: nil}

  def fixture(:handling_event) do
    {:ok, handling_event} = Tracking.create_handling_event(@create_attrs)
    handling_event
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, tracking_handling_event_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing Handling events"
  end

  test "renders form for new handling_events", %{conn: conn} do
    conn = get conn, tracking_handling_event_path(conn, :new)
    assert html_response(conn, 200) =~ "New Handling event"
  end

  test "creates handling_event and redirects to show when data is valid", %{conn: conn} do
    conn = post conn, tracking_handling_event_path(conn, :create), handling_event: @create_attrs

    assert %{id: id} = redirected_params(conn)
    assert redirected_to(conn) == tracking_handling_event_path(conn, :show, id)

    conn = get conn, tracking_handling_event_path(conn, :show, id)
    assert html_response(conn, 200) =~ "Show Handling event"
  end

  test "does not create handling_event and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, tracking_handling_event_path(conn, :create), handling_event: @invalid_attrs
    assert html_response(conn, 200) =~ "New Handling event"
  end

  test "renders form for editing chosen handling_event", %{conn: conn} do
    handling_event = fixture(:handling_event)
    conn = get conn, tracking_handling_event_path(conn, :edit, handling_event)
    assert html_response(conn, 200) =~ "Edit Handling event"
  end

  test "updates chosen handling_event and redirects when data is valid", %{conn: conn} do
    handling_event = fixture(:handling_event)
    conn = put conn, tracking_handling_event_path(conn, :update, handling_event), handling_event: @update_attrs
    assert redirected_to(conn) == tracking_handling_event_path(conn, :show, handling_event)

    conn = get conn, tracking_handling_event_path(conn, :show, handling_event)
    assert html_response(conn, 200) =~ "some updated cargoId"
  end

  test "does not update chosen handling_event and renders errors when data is invalid", %{conn: conn} do
    handling_event = fixture(:handling_event)
    conn = put conn, tracking_handling_event_path(conn, :update, handling_event), handling_event: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit Handling event"
  end

  test "deletes chosen handling_event", %{conn: conn} do
    handling_event = fixture(:handling_event)
    conn = delete conn, tracking_handling_event_path(conn, :delete, handling_event)
    assert redirected_to(conn) == tracking_handling_event_path(conn, :index)
    assert_error_sent 404, fn ->
      get conn, tracking_handling_event_path(conn, :show, handling_event)
    end
  end
end
