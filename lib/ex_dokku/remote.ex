defmodule ExDokku.Remote do
  @moduledoc "Interacts with the server"
  def database_name do
    {:ok, conn} = SSHEx.connect(ip: server_ip(), user: "root")
    {:ok, output, 0} = SSHEx.run(conn, 'dokku postgres:app-links #{app_name()}')
    String.trim(output)
  end

  def server_ip do
    git_info()
    |> Map.get("ip")
  end

  def app_name do
    git_info()
    |> Map.get("app")
  end

  defp git_info do
    case System.cmd("git", ["remote", "get-url", "dokku"], stderr_to_stdout: true) do
      {result, 0} ->
        ~r/dokku@(?<ip>\d{1,3}.\d{1,3}.\d{1,3}.\d{1,3}):(?<app>\w+)\n/
        |> Regex.named_captures(result)

      _ ->
        raise "Please add your git remote with: git remote add dokku dokku@your.server.ip.address:yourapp"
    end
  end
end
