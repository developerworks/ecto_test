use Mix.Config

config :ecto_test, EctoTest.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "ecto_test",
  username: "hezhiqiang",
  password: "root",
  hostname: "127.0.0.1",
  pool_size: 1,
  loggers: [
    {Ecto.LogEntry, :log, [:debug]}
  ],
  extensions: [
    {Postgrex.Extensions.JSON, library: Poison}
  ]

config :ip2location,
  database: [__DIR__, "../resources/IP2LOCATION-LITE-DB11.BIN"] |> Path.join() |> Path.expand(),
  pool: [ size: 5, max_overflow: 10 ]
