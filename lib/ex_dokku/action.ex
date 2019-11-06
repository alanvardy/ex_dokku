defmodule ExDokku.Action do
  @moduledoc "Core actions for ExDokku"
  alias ExDokku.{Config, Local, Remote}

  @spec start_ssh :: {:ok, [atom]}
  def start_ssh do
    {:ok, _started} = Application.ensure_all_started(:sshex)
  end

  @spec connect_ssh :: any
  def connect_ssh do
    ip = Remote.server_ip()

    SSHEx.connect(ip: ip, user: "root")
    |> elem(1)
  end

  @spec download_db(String.t()) :: :ok
  def download_db(name) do
    output =
      connect_ssh()
      |> SSHEx.run('dokku postgres:export #{Remote.database_name()}')

    case output do
      {:ok, output, 0} ->
        File.write("#{name}.dump", output, [])
        IO.puts("== Database downloaded as #{name}.dump ==")

      _ ->
        IO.puts("!! Unable to connect to database !!")
    end
  end

  @spec load_db(String.t()) :: :ok
  def load_db(name) do
    System.cmd("pg_restore", [
      "-c",
      "--username=#{Config.postgres_username()}",
      "--dbname=#{Local.database_name()}",
      "#{name}.dump"
    ])

    IO.puts("== Loaded #{name}.dump into development db ==")
  end

  @spec save_db(String.t()) :: :ok
  def save_db(name) do
    System.cmd("pg_dump", [
      "-Fc",
      "--file=#{name}.dump",
      Local.database_name()
    ])

    IO.puts("== Saved development db to #{name}.dump ==")
  end

  @spec upload_db(String.t()) :: {<<>>, 0}
  def upload_db(file) do
    ip = Remote.server_ip()
    directory = Config.backup_directory()
    IO.puts("Uploading #{file} to #{ip}:/home/dokku/restore.dump")
    {"", 0} = System.cmd("scp", [directory <> file, "root@#{ip}:/home/dokku/restore.dump"])
  end

  @spec choose_file :: String.t()
  def choose_file do
    {files, 0} = System.cmd("ls", [Config.backup_directory()])

    IO.gets("Please enter one of the following files from your backup directory:\n#{files}")
    |> String.trim()
  end

  @spec run_remote(any, charlist) :: any
  def run_remote(conn, command) do
    IO.puts("Running '#{command}' on server")
    {:ok, output, 0} = SSHEx.run(conn, command, exec_timeout: 60_000)
    IO.puts(output)
    conn
  end
end
