defmodule ExDokku.Config.Local do
  @moduledoc "Interacts with the development environment"
  alias ExDokku.Config

  def add(struct) do
    struct
    |> Map.put(:database_name, database_name(struct))
  end

  def database_name(%{app: app, repo: repo}) do
    app
    |> Application.get_all_env()
    |> Keyword.get(repo)
    |> Keyword.get(:database)
  end
end
