defmodule ExDokku.Action do
  @moduledoc "Core actions for ExDokku"
  alias ExDokku.{Config, Local, Remote}

  def start_ssh do
    {:ok, _started} = Application.ensure_all_started(:sshex)
  end

  def download_db(name) do
    output =
      SSHEx.connect(ip: Remote.server_ip(), user: "root")
      |> elem(1)
      |> SSHEx.run('dokku postgres:export #{Remote.database_name()}')

    case output do
      {:ok, output, 0} ->
        File.write("#{name}.dump", output, [])
        IO.puts("== Database downloaded as #{name}.dump ==")

      _ ->
        IO.puts("!! Unable to connect to database !!")
    end
  end

  def load_db(name) do
    System.cmd("pg_restore", [
      "-c",
      "--username=#{Config.postgres_username()}",
      "--dbname=#{Local.database_name()}",
      "#{name}.dump"
    ])

    IO.puts("== Loaded #{name}.dump into development db ==")
  end

  def save_db(name) do
    System.cmd("pg_dump", [
      "-Fc",
      "--file=#{name}.dump",
      Local.database_name()
    ])

    IO.puts("== Saved development db to #{name}.dump ==")
  end
end
