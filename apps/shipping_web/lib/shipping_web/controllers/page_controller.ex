defmodule Shipping.Web.PageController do
  use Shipping.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
