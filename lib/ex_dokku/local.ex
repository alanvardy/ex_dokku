defmodule ExDokku.Local do
  @moduledoc "Interacts with the development environment"
  alias ExDokku.Config

  def database_name do
    env_info()
    |> Keyword.get(Config.repo())
    |> Keyword.get(:database)
  end

  defp env_info do
    Application.get_all_env(Config.app())
  end
end
