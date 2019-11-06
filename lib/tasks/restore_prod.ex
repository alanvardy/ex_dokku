defmodule Mix.Tasks.Dokku.RestoreProd do
  alias ExDokku.Remote

  @moduledoc """
  **This is a dangerous command**

  Unlinks, destroys, recreates, reloads from a backup, and then relinks your production database.
  Confirms beforehand. Make sure you back up your database before issuing this command!
  """
  @shortdoc """
  Resets the production database (without seeding)
  """

  alias ExDokku.{Action}
  use Mix.Task

  def run(_args) do
    Action.start_ssh()
    app = Remote.app_name()
    db = Remote.database_name()

    confirmation =
      IO.gets("""
      WARNING: THIS ACTION WILL ERASE YOUR PRODUCTION DATABASE AND RESTORE FROM A BACKUP
      Make sure you have a backup with mix dokku.backup before continuing.
      Type in #{db} to confirm

      """)
      |> String.trim()

    unless confirmation == db do
      raise "Cancelled"
    end

    Action.choose_file()
    |> Action.upload_db()

    Action.connect_ssh()
    |> Action.run_remote('dokku postgres:unlink #{db} #{app}')
    |> Action.run_remote('dokku postgres:destroy #{db} -f')
    |> Action.run_remote('dokku postgres:create #{db}')
    |> Action.run_remote('dokku postgres:link #{db} #{app}')
    |> Action.run_remote('dokku postgres:import #{db} < /home/dokku/restore.dump')

    IO.puts("Restore complete")
  end
end
