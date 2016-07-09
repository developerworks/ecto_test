use Mix.Config

config :ecto_test, EctoTest.Repo,
  adapter: Ecto.Adapters.MySQL,
  database: "ecto_test",
  username: "root",
  password: "root",
  hostname: "192.168.212.129"

config :ip2location,
  database: [__DIR__, "../resources/IP2LOCATION-LITE-DB11.BIN"] |> Path.join() |> Path.expand(),
  pool: [ size: 5, max_overflow: 10 ]

import_config "#{Mix.env}.exs"
