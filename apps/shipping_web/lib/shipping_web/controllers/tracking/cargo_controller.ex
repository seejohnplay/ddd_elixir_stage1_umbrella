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

  def show(conn, %{"id" => id}) do
    cargo = Tracking.get_cargo!(id)
    render(conn, "show.html", cargo: cargo)
  end

  def edit(conn, %{"id" => id}) do
    cargo = Tracking.get_cargo!(id)
    changeset = Tracking.change_cargo(cargo)
    render(conn, "edit.html", cargo: cargo, changeset: changeset)
  end

  def update(conn, %{"id" => id, "cargo" => cargo_params}) do
    cargo = Tracking.get_cargo!(id)

    case Tracking.update_cargo(cargo, cargo_params) do
      {:ok, cargo} ->
        conn
        |> put_flash(:info, "Cargo updated successfully.")
        |> redirect(to: tracking_cargo_path(conn, :show, cargo))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", cargo: cargo, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    cargo = Tracking.get_cargo!(id)
    {:ok, _cargo} = Tracking.delete_cargo(cargo)

    conn
    |> put_flash(:info, "Cargo deleted successfully.")
    |> redirect(to: tracking_cargo_path(conn, :index))
  end
end
