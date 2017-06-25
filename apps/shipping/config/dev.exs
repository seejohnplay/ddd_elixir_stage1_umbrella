use Mix.Config

# Configure your database
config :shipping, Shipping.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "shipping_dev",
  hostname: "localhost",
  pool_size: 10
