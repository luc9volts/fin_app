defmodule Accounts.MixProject do
  use Mix.Project

  def project do
    [
      app: :accounts,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Accounts.Application, []}
    ]
  end

  defp deps do
    [
      {:commands, in_umbrella: true},
      {:events, in_umbrella: true},
      {:commanded, "~> 0.18"},
      {:jason, "~> 1.1"}
    ]
  end
end
