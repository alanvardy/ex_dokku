defmodule Mix.Tasks.Dokku.ResetProd do
  @moduledoc """
    Downloads your production database to the path set in your config with the
    name of your app and the date. Re-downloading the file again will replace
    the previously downloaded file.
  """
  @shortdoc """
  Load latest.dump into development database
  """

  alias ExDokku.{Action}
  use Mix.Task

  def run(_args) do
    Action.start_ssh()
    Action.reset_prod_db()
  end
end
