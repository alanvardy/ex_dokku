defmodule ExDokku.Config do
  @moduledoc "Builds the configuration struct"
  alias ExDokku.Config.{Application, Local, Remote, Struct}

  def build do
    IO.puts("== Loading Config ==")

    %Struct{}
    |> Application.add()
    |> Local.add()
    |> Remote.add_git_string()
    |> Remote.add_git_info()
    |> Remote.add_database_names()
  end
end
