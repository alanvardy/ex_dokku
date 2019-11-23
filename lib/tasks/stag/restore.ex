defmodule Mix.Tasks.Dokku.Stag.Restore do
  alias ExDokku.{Action, Config}

  @moduledoc """
  Pulls the production database and loads it into the staging database
  """
  @shortdoc """
  Pulls the production database and loads it into the staging database
  """

  alias ExDokku.{Action}
  use Mix.Task

  @spec run(any) :: :ok
  def run(_args) do
    Action.start_ssh()
    %{ip_stag: ip_stag, app_stag: app_stag, db_stag: db_stag} = config = Config.build()

    Action.download_db(config, "latest")
    Action.upload_db("latest.dump", config, ip_stag, :local)

    Action.connect_ssh(ip_stag)
    |> Action.run_remote('dokku postgres:unlink #{db_stag} #{app_stag}')
    |> Action.run_remote('dokku postgres:destroy #{db_stag} -f')
    |> Action.run_remote('dokku postgres:create #{db_stag}')
    |> Action.run_remote('dokku postgres:link #{db_stag} #{app_stag}')
    |> Action.run_remote('dokku postgres:import #{db_stag} < /home/dokku/restore.dump')

    IO.puts("Restore complete")
  end
end
