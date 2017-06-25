defmodule Shipping.Web.Router do
  use Shipping.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Shipping.Web do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/tracking", Shipping.Web.Tracking, as: :tracking do
    pipe_through :browser

    resources "/cargoes", CargoController
    resources "/handling_events", HandlingEventController
  end

  # Other scopes may use custom stacks.
  # scope "/api", Shipping.Web do
  #   pipe_through :api
  # end
end
