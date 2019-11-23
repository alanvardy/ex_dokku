defmodule ExDokku.Config.Remote do
  @moduledoc "Interacts with the server"

  def add_git_string(struct) do
    struct
    |> Map.put(:git_stag, git_info(:stag))
    |> Map.put(:git_prod, git_info(:prod))
  end

  def add_git_info(%{git_stag: git_stag, git_prod: git_prod} = struct) do
    struct
    |> Map.put(:ip_prod, Map.get(git_prod, "ip"))
    |> Map.put(:ip_stag, Map.get(git_stag, "ip"))
    |> Map.put(:app_prod, Map.get(git_prod, "app"))
    |> Map.put(:app_stag, Map.get(git_stag, "app"))
  end

  def add_database_names(struct) do
    struct
    |> Map.put(:db_stag, database_name(struct.ip_stag, struct.app_stag))
    |> Map.put(:db_prod, database_name(struct.ip_prod, struct.app_prod))
  end

  def database_name(ip, app) do
    {:ok, conn} = SSHEx.connect(ip: ip, user: "root")
    {:ok, output, 0} = SSHEx.run(conn, 'dokku postgres:app-links #{app}')

    case String.trim(output) do
      "" -> raise "No database found for #{app}"
      result -> result
    end
  end

  defp git_info(env) do
    remote =
      case env do
        :stag -> "dokku-staging"
        :prod -> "dokku"
      end

    case System.cmd("git", ["remote", "get-url", remote], stderr_to_stdout: true) do
      {result, 0} ->
        ~r/dokku@(?<ip>\d{1,3}.\d{1,3}.\d{1,3}.\d{1,3}):(?<app>\w+)\n/
        |> Regex.named_captures(result)

      _ ->
        raise "Please add your git remote for #{env} with: git remote add #{remote} dokku@your.server.ip.address:yourapp"
    end
  end
end
