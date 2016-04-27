defmodule EctoTest.Mixfile do
  use Mix.Project

  def project do
    [app: :ecto_test,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    dev_packages = Mix.env == :dev && [:exsync] || []
    [applications: [:logger, :mariaex, :ecto] ++ dev_packages,
     mod: {EctoTest, []}]
  end

  defp deps do
    [
      {:mariaex, "~> 0.7.4"},
      {:ecto, "~> 2.0.0-rc.3"},
      {:exsync, "~> 0.1.2", only: [:dev]}
    ]
  end
end
