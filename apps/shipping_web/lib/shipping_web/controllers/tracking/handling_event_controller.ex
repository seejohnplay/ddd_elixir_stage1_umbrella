defmodule Shipping.Web.Tracking.HandlingEventController do
  use Shipping.Web, :controller

  # The Aggregates
  alias Shipping.{Cargoes, HandlingEvents}
  alias Shipping.Web.TrackingChannel

  def index(conn, _params) do
    handling_events = HandlingEvents.list_handling_events()
    render(conn, "index.html", handling_events: handling_events)
  end

  def new(conn, _params) do
    changeset = HandlingEvents.change_handling_event(%HandlingEvents.HandlingEvent{})
    render(conn, "new.html", changeset: changeset,
                            location_map: Cargoes.location_map(),
                            handling_event_type_map: Cargoes.handling_event_type_map())
  end

  def create(conn, %{"handling_event" => handling_event_params}) do
    case HandlingEvents.create_handling_event(handling_event_params) do
      {:ok, handling_event} ->
        # Let everyone who has subscribed  know about the new handling event.
        # Determine a cargo's new status given this handling event. Update the cargo
        # Let everyone who has subscribed know the change in the cargo's status.
        # The tracking status is ignored for now.
        {tracking_status, updated_cargo} =
          handling_event
          |> TrackingChannel.broadcast_new_handling_event()
          |> Cargoes.update_cargo_status()
          |> TrackingChannel.broadcast_new_cargo_status()
        conn
          |> put_flash(:info, "Handling event created successfully.")
          |> redirect(to: tracking_handling_event_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset,
                                location_map: Cargoes.location_map(),
                                handling_event_type_map: Cargoes.handling_event_type_map())
    end
  end

  def show(conn, %{"id" => id}) do
    handling_event = HandlingEvents.get_handling_event!(id)
    render(conn, "show.html", handling_event: handling_event)
  end

  def edit(conn, %{"id" => id}) do
    handling_event = HandlingEvents.get_handling_event!(id)
    changeset = HandlingEvents.change_handling_event(handling_event)
    render(conn, "edit.html", handling_event: handling_event, changeset: changeset,
                              location_map: Cargoes.location_map(),
                              handling_event_type_map: Cargoes.handling_event_type_map())
  end

  def update(conn, %{"id" => id, "handling_event" => handling_event_params}) do
    handling_event = HandlingEvents.get_handling_event!(id)

    case HandlingEvents.update_handling_event(handling_event, handling_event_params) do
      {:ok, handling_event} ->
        conn
        |> put_flash(:info, "Handling event updated successfully.")
        |> redirect(to: tracking_handling_event_path(conn, :show, handling_event))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", handling_event: handling_event, changeset: changeset,
                                  location_map: Cargoes.location_map(),
                                  handling_event_type_map: Cargoes.handling_event_type_map())
    end
  end

  def delete(conn, %{"id" => id}) do
    handling_event = HandlingEvents.get_handling_event!(id)
    {:ok, _handling_event} = HandlingEvents.delete_handling_event(handling_event)

    conn
    |> put_flash(:info, "Handling event deleted successfully.")
    |> redirect(to: tracking_handling_event_path(conn, :index))
  end
end
