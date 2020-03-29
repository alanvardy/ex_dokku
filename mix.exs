defmodule ExDokku.MixProject do
  @moduledoc false
  use Mix.Project

  @version "0.1.8"

  def project do
    [
      app: :ex_dokku,
      version: @version,
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      build_embedded: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      dialyzer: [plt_add_apps: [:mix]],

      # Hex
      description: "Quality of life tools for Phoenix Dokku deployments",
      package: package(),

      # Docs
      name: "ExDokku",
      docs: docs()
    ]
  end

  defp package do
    [
      maintainers: ["Alan Vardy"],
      licenses: ["MIT"],
      links: %{github: "https://github.com/alanvardy/ex_dokku"},
      files: ["lib", "mix.exs", "README.md"]
    ]
  end

  defp docs do
    [
      source_ref: "v#{@version}",
      main: "README",
      canonical: "http://hexdocs.pm/ex_dokku",
      source_url: "https://github.com/alanvardy/ex_dokku",
      extras: [
        "README.md": [filename: "README"],
        "CHANGELOG.md": [filename: "CHANGELOG"]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:sshex, "2.2.1"},
      {:observer_cli, "~> 1.5"},
      # Tooling
      {:ex_check, ">= 0.0.0", only: :dev, runtime: false},
      {:credo, "~> 1.1.0", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0.0-rc.6", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.10", only: :test, runtime: false},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
      {:inch_ex, github: "rrrene/inch_ex", only: [:dev, :test]}
    ]
  end
end
