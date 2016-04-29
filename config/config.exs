use Mix.Config

config :ecto_test, EctoTest.Repo2,
  adapter: Ecto.Adapters.Postgres,
  database: "ecto_test_repo2",
  username: "user",
  password: "pass",
  hostname: "localhost"


config :ecto_test, EctoTest1.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "ecto_test_repo",
  username: "user",
  password: "pass",
  hostname: "localhost"


# config :ecto_test, EctoTest.Repo,
#   adapter: Ecto.Adapters.MySQL,
#   database: "ecto_test",
#   username: "root",
#   password: "root",
#   hostname: "192.168.212.129"

config :ecto_test,
  ecto_repos: [EctoTest.Repo],
  adapter: Ecto.Adapters.Postgres,
  database: "postgres",
  username: "postgres",
  password: "root",
  hostname: "192.168.212.129"

config :ecto_test,
  ecto_repos: [EctoTest.Repo],
  adapter: Ecto.Adapters.Postgres,
  database: "hezhiqiang",
  username: "hezhiqiang",
  password: "root",
  hostname: "127.0.0.1"

import_config "#{Mix.env}.exs"
