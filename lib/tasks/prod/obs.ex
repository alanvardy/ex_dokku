defmodule Mix.Tasks.Dokku.Prod.Obs do
  @shortdoc "Run observer_cli on production"
  use Mix.Task
  alias ExDokku.{Action, Config}

  @spec run(any) :: :ok
  def run(_args) do
    Action.start_ssh()
    %{ip_prod: ip_prod} = Config.build()
    IO.puts("==============================================================")
    IO.puts("==================== To run observer_cli: ====================")
    IO.puts("iex --name \"root@#{ip_prod}\" -S mix")
    IO.puts(":observer_cli.start(:'root@#{ip_prod}', :magic_cookie)")
    IO.puts("==============================================================")
  end
end
