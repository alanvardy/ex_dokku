defmodule Mix.Tasks.Dokku.Load do
  @moduledoc "Download production database and load into development database"
  @shortdoc "Load latest.dump into development database"

  alias ExDokku.Action
  use Mix.Task

  @spec run(any) :: :ok
  def run(_args) do
    Action.start_ssh()
    Action.load_db("latest")
  end
end
