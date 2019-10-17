defmodule Mix.Tasks.Dokku.Pull do
  @moduledoc """
  Downloads your production database to your app root directory as `latest.dump`
  and loads it into your development database. Useful for troubleshooting
  production issues.
"""
  @shortdoc "Download production database and load into development database"

  alias ExDokku.Action
  use Mix.Task

  @spec run(any) :: :ok
  def run(_args) do
    Action.start_ssh()
    Action.download_db("latest")
    Action.load_db("latest")
  end
end
