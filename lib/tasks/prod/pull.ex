defmodule Mix.Tasks.Dokku.Prod.Pull do
  @moduledoc """
    Downloads your production database to your app root directory as `latest.dump`
    and loads it into your development database. Useful for troubleshooting
    production issues.
  """
  @shortdoc "Download production database and load into development database"

  alias ExDokku.{Action, Config}
  use Mix.Task

  @spec run(any) :: :ok
  def run(_args) do
    Action.start_ssh()
    config = Config.build()
    Action.download_db(config, "latest")
    Action.load_db(config, "latest")

    IO.puts("Pull complete")
  end
end
