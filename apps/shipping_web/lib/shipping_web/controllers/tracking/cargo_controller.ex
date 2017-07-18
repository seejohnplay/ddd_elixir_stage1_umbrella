defmodule Shipping.Web.Tracking.CargoController do
  use Shipping.Web, :controller

  alias Shipping.Tracking

  def index(conn, _params) do
    cargoes = Tracking.list_cargoes()
    render(conn, "index.html", cargoes: cargoes)
  end

  def new(conn, _params) do
    changeset = Tracking.change_cargo(%Shipping.Tracking.Cargo{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"cargo" => cargo_params}) do
    case Tracking.create_cargo(cargo_params) do
      {:ok, cargo} ->
        conn
        |> put_flash(:info, "Cargo created successfully.")
        |> redirect(to: tracking_cargo_path(conn, :show, cargo))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"tracking_id" => tracking_id}) do
    case cargo = Tracking.get_cargo_by_tracking_id!(tracking_id) do
      %Shipping.Tracking.Cargo{} ->
        # Retrieve and apply all handling events to date against the cargo so as
        # to determine the cargo's current status.  Apply oldest events first.
        # The cargo is updated. The tracking status (:on_track, :off_track)
        # is ignored for now.
        handling_events = Tracking.get_handling_events_by_tracking_id!(cargo.tracking_id)
        {tracking_status, updated_cargo} =
          handling_events
          |> Enum.reverse()
          |> Tracking.update_cargo_status()
        render(conn, "show.html", cargo: updated_cargo, handling_events: handling_events)
      _ ->
        conn
          |> put_flash(:error, "Invalid tracking number")
          |> redirect(to: page_path(conn, :index))
    end
  end

  def edit(conn, %{"tracking_id" => tracking_id}) do
    cargo = Tracking.get_cargo_by_tracking_id!(tracking_id)
    changeset = Tracking.change_cargo(cargo)
    render(conn, "edit.html", cargo: cargo, changeset: changeset)
  end

  def update(conn, %{"tracking_id" => tracking_id, "cargo" => cargo_params}) do
    cargo = Tracking.get_cargo_by_tracking_id!(tracking_id)

    case Tracking.update_cargo(cargo, cargo_params) do
      {:ok, cargo} ->
        conn
        |> put_flash(:info, "Cargo updated successfully.")
        |> redirect(to: tracking_cargo_path(conn, :show, cargo))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", cargo: cargo, changeset: changeset)
    end
  end

  def delete(conn, %{"tracking_id" => tracking_id}) do
    cargo = Tracking.get_cargo_by_tracking_id!(tracking_id)
    {:ok, _cargo} = Tracking.delete_cargo(cargo)

    conn
    |> put_flash(:info, "Cargo deleted successfully.")
    |> redirect(to: tracking_cargo_path(conn, :index))
  end
end
