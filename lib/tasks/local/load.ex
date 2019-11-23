defmodule Mix.Tasks.Dokku.Local.Load do
  @moduledoc "Download production database and load into development database"
  @shortdoc "Load latest.dump into development database"

  alias ExDokku.{Action, Config}
  use Mix.Task

  @spec run(any) :: :ok
  def run(_args) do
    Action.start_ssh()
    config = Config.build()
    Action.load_db(config, "latest")

    IO.puts("Load complete")
  end
end
