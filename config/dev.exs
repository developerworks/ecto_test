use Mix.Config

# config :ecto_test, EctoTest.Repo,
#   adapter: Ecto.Adapters.MySQL,
#   database: "ecto_test",
#   username: "root",
#   password: "root",
#   hostname: "192.168.212.129"

config :ecto_test, EctoTest.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "postgres",
  username: "postgres",
  password: "root",
  hostname: "192.168.212.129"

