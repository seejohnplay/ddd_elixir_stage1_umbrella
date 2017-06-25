use Mix.Config

config :shipping, ecto_repos: [Shipping.Repo]

import_config "#{Mix.env}.exs"
