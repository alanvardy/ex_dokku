defmodule Mix.Tasks.Dokku.Local.Save do
  @moduledoc "Save development database to latest.dump"
  @shortdoc "Load latest.dump into development database"

  alias ExDokku.{Action, Config}
  use Mix.Task

  @spec run(any) :: :ok
  def run(_args) do
    Action.start_ssh()
    config = Config.build()
    Action.save_db(config, "latest")
  end
end
