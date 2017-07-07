defmodule Shipping.Web.PageController do
  use Shipping.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def search(conn, %{"search" => %{"tracking_id" => tracking_id}}) do
    redirect(conn, to: tracking_cargo_path(conn, :show, tracking_id))
  end
end
