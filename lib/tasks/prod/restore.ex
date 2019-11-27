defmodule Mix.Tasks.Dokku.Prod.Restore do
  @moduledoc """
  **This is a dangerous command**

  Unlinks, destroys, recreates, reloads from a backup, and then relinks your production database.
  Confirms beforehand. Make sure you back up your database before issuing this command!
  """
  @shortdoc """
  Resets the production database (without seeding)
  """

  alias ExDokku.{Action, Config}
  use Mix.Task

  @spec run(any) :: :ok
  def run(_args) do
    Action.start_ssh()
    %{ip_prod: ip_prod, app_prod: app_prod, db_prod: db_prod} = config = Config.build()

    confirmation =
      IO.gets("""
      WARNING: THIS ACTION WILL ERASE YOUR PRODUCTION DATABASE AND RESTORE FROM A BACKUP
      Make sure you have a backup with mix dokku.prod.backup before continuing.
      Type in #{db_prod} to confirm

      """)
      |> String.trim()

    unless confirmation == db_prod do
      raise "Cancelled"
    end

    config
    |> Action.choose_file()
    |> Action.upload_db(config, ip_prod, :backup)

    Action.connect_ssh(ip_prod)
    |> Action.run_remote('dokku postgres:unlink #{db_prod} #{app_prod}')
    |> Action.run_remote('dokku postgres:destroy #{db_prod} -f')
    |> Action.run_remote('dokku postgres:create #{db_prod}')
    |> Action.run_remote('dokku postgres:link #{db_prod} #{app_prod}')
    |> Action.run_remote('dokku postgres:import #{db_prod} < /home/dokku/restore.dump')

    IO.puts("Restore complete")
  end
end
