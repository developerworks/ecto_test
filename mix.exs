defmodule EctoTest.Mixfile do
  use Mix.Project

  def project do
    [app: :ecto_test,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     aliases: aliases
   ]
  end

  def application do
    dev_packages = Mix.env == :dev && [:exsync] || []
    [applications: [:logger, :postgrex, :ecto, :ex_machina, :ip2location] ++ dev_packages,
     mod: {EctoTest, []}]
  end

  defp deps do
    [
      {:poison, "~> 2.1"},
      {:postgrex, "~> 0.11.2"},
      {:ecto, "~> 2.0.2"},
      {:apex, "~> 0.5.1"},
      {:ex_machina, "~> 1.0.2"},
      {:exfswatch, "~> 0.1.1"},
      {:exsync, "~> 0.1.2", only: [:dev]},
      {:ex_unit_notifier, "~> 0.1.1"},
      {:ip2location, "~> 0.1.0"},
      {:kitto, "~> 0.0.1"}
    ]
  end

  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate"],
      "ecto.reset": ["ecto.drop", "ecto.setup"]
    ]
  end
end
