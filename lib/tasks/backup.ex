defmodule Mix.Tasks.Dokku.Backup do
  @moduledoc """
    Downloads your production database to the path set in your config with the
    name of your app and the date. Re-downloading the file again will replace
    the previously downloaded file.
  """
  @shortdoc """
  Load latest.dump into development database
  """

  alias ExDokku.{Action, Config}
  use Mix.Task

  @spec run(any) :: :ok
  def run(_args) do
    date =
      Date.utc_today()
      |> Date.to_iso8601()

    Action.start_ssh()
    Action.download_db("#{Config.backup_directory()}#{Config.app()}-#{date}")

    IO.puts("Backup complete")
  end
end
