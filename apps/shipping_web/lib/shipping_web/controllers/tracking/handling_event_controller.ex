defmodule Shipping.Web.Tracking.HandlingEventController do
  use Shipping.Web, :controller

  alias Shipping.Tracking
  alias Shipping.Web.TrackingChannel

  def index(conn, _params) do
    handling_events = Tracking.list_handling_events()
    render(conn, "index.html", handling_events: handling_events)
  end

  def new(conn, _params) do
    changeset = Tracking.change_handling_event(%Shipping.Tracking.HandlingEvent{})
    render(conn, "new.html", changeset: changeset,
                            location_map: Tracking.location_map(),
                            handling_event_type_map: Tracking.handling_event_type_map())
  end

  def create(conn, %{"handling_event" => handling_event_params}) do
    case Tracking.create_handling_event(handling_event_params) do
      {:ok, handling_event} ->
        # Let everyone who has subscribed  know about the new handling event.
        TrackingChannel.broadcast_new_handling_event(handling_event)
        conn
        |> put_flash(:info, "Handling event created successfully.")
        |> redirect(to: tracking_handling_event_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset,
                                location_map: Tracking.location_map(),
                                handling_event_type_map: Tracking.handling_event_type_map())
    end
  end

  def show(conn, %{"id" => id}) do
    handling_event = Tracking.get_handling_event!(id)
    render(conn, "show.html", handling_event: handling_event)
  end

  def edit(conn, %{"id" => id}) do
    handling_event = Tracking.get_handling_event!(id)
    changeset = Tracking.change_handling_event(handling_event)
    render(conn, "edit.html", handling_event: handling_event, changeset: changeset,
                              location_map: Tracking.location_map(),
                              handling_event_type_map: Tracking.handling_event_type_map())
  end

  def update(conn, %{"id" => id, "handling_event" => handling_event_params}) do
    handling_event = Tracking.get_handling_event!(id)

    case Tracking.update_handling_event(handling_event, handling_event_params) do
      {:ok, handling_event} ->
        conn
        |> put_flash(:info, "Handling event updated successfully.")
        |> redirect(to: tracking_handling_event_path(conn, :show, handling_event))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", handling_event: handling_event, changeset: changeset,
                                  location_map: Tracking.location_map(),
                                  handling_event_type_map: Tracking.handling_event_type_map())
    end
  end

  def delete(conn, %{"id" => id}) do
    handling_event = Tracking.get_handling_event!(id)
    {:ok, _handling_event} = Tracking.delete_handling_event(handling_event)

    conn
    |> put_flash(:info, "Handling event deleted successfully.")
    |> redirect(to: tracking_handling_event_path(conn, :index))
  end
end
