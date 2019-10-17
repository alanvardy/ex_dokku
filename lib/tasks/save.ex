defmodule Mix.Tasks.Dokku.Save do
  @moduledoc "Save development database to latest.dump"
  @shortdoc "Load latest.dump into development database"

  alias ExDokku.Action
  use Mix.Task

  @spec run(any) :: :ok
  def run(_args) do
    Action.start_ssh()
    Action.save_db("latest")
  end
end
