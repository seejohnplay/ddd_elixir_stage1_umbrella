# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :shipping_web,
  namespace: Shipping.Web,
  ecto_repos: [Shipping.Repo]

# Configures the endpoint
config :shipping_web, Shipping.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "bcx8N8/LG/XZ9mcNLpU6eIeUn6zHIr//I2w6rJPu8mwxE5KtJWu4D+I5sStGLX9V",
  render_errors: [view: Shipping.Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Shipping.Web.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :shipping_web, :generators,
  context_app: :shipping

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
