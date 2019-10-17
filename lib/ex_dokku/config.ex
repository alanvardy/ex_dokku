defmodule ExDokku.Config do
  @moduledoc """
  # Configuration setup

  Add to your dev.exs:

  ```elixir
  config :ex_dokku,
  app: MyApp,
  repo: MyApp.Repo,
  postgres_username: "postgres"
  ```
  """

  def app do
    Application.get_env(:ex_dokku, :app) || raise ":app not set"
  end

  def repo do
    Application.get_env(:ex_dokku, :repo) || raise ":repo not set"
  end

  def backup_directory do
    Application.get_env(:ex_dokku, :backup_directory) || raise ":backup_directory not set"
  end

  @spec postgres_username :: String.t()
  def postgres_username do
    Application.get_env(:ex_dokku, :postgres_username) || raise ":postgres_username not set"
  end
end
