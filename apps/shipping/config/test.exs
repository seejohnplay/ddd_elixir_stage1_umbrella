use Mix.Config

# Configure your database
config :shipping, Shipping.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "shipping_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
