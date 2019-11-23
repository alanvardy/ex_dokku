defmodule ExDokku.Config do
  alias ExDokku.Config.{Application, Local, Remote, Struct}

  def build do
    %Struct{}
    |> Application.add()
    |> Local.add()
    |> Remote.add_git_string()
    |> Remote.add_git_info()
    |> Remote.add_database_names()
  end
end
