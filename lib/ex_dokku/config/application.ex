defmodule ExDokku.Config.Application do
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

  def add(struct) do
    struct
    |> Map.put(:app, app())
    |> Map.put(:repo, repo())
    |> Map.put(:backup_directory, backup_directory())
    |> Map.put(:postgres_username, postgres_username())
  end

  @spec app :: any
  defp app do
    Application.get_env(:ex_dokku, :app) || raise ":app not set"
  end

  @spec repo :: any
  defp repo do
    Application.get_env(:ex_dokku, :repo) || raise ":repo not set"
  end

  @spec backup_directory :: any
  defp backup_directory do
    Application.get_env(:ex_dokku, :backup_directory) || raise ":backup_directory not set"
  end

  @spec postgres_username :: String.t()
  defp postgres_username do
    Application.get_env(:ex_dokku, :postgres_username) || raise ":postgres_username not set"
  end
end
