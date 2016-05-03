use Mix.Config

# config :ecto_test, EctoTest.Repo,
#   adapter: Ecto.Adapters.MySQL,
#   database: "ecto_test",
#   username: "root",
#   password: "root",
#   hostname: "192.168.212.129"

# config :ecto_test, EctoTest.Repo,
#   adapter: Ecto.Adapters.Postgres,
#   database: "postgres",
#   username: "postgres",
#   password: "root",
#   hostname: "192.168.212.129",
#   pool_size: 1
# config :ecto_test,
#   ecto_repos: [EctoTest.Repo],
#   adapter: Ecto.Adapters.Postgres,
#   database: "ecto_test",
#   username: "hezhiqiang",
#   password: "root",
#   hostname: "127.0.0.1",
#   pool_size: 1

config :ecto_test, EctoTest.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "ecto_test",
  username: "root",
  password: "root",
  hostname: "127.0.0.1",
  pool_size: 1,
  loggers: [{Ecto.LogEntry, :log, [:debug]}]
