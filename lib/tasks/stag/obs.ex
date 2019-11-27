defmodule Mix.Tasks.Dokku.Stag.Obs do
  @moduledoc "Run observer_cli on staging"
  @shortdoc "Run observer_cli on staging"
  use Mix.Task
  alias ExDokku.{Action, Config}

  @spec run(any) :: :ok
  def run(_args) do
    Action.start_ssh()
    %{ip_stag: ip_stag} = Config.build()
    IO.puts("==============================================================")
    IO.puts("==================== To run observer_cli: ====================")
    IO.puts("iex --name \"root@#{ip_stag}\" -S mix")
    IO.puts(":observer_cli.start(:'root@#{ip_stag}', :magic_cookie)")
    IO.puts("==============================================================")
  end
end
