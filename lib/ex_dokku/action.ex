defmodule ExDokku.Action do
  @moduledoc "Core actions for ExDokku"
  alias ExDokku.Config.Struct

  @spec start_ssh :: {:ok, [atom]}
  def start_ssh do
    {:ok, _started} = Application.ensure_all_started(:sshex)
  end

  @spec connect_ssh(String.t()) :: any
  def connect_ssh(ip) do
    case SSHEx.connect(ip: ip, user: "root") do
      {:ok, pid} -> pid
      {:error, message} -> "Could not connect to #{ip}, message: #{message}"
    end
  end

  @spec download_db(Struct.t(), String.t()) :: :ok
  def download_db(%{ip_prod: ip_prod, db_prod: db_prod}, name) do
    output =
      connect_ssh(ip_prod)
      |> SSHEx.run('dokku postgres:export #{db_prod}')

    case output do
      {:ok, output, 0} ->
        File.write("#{name}.dump", output, [])
        IO.puts("== Database downloaded as #{name}.dump ==")

      {:error, message} ->
        IO.puts("Unable to download database: #{message}")
    end
  end

  @spec load_db(Struct.t(), String.t()) :: :ok
  def load_db(%{postgres_username: postgres_username, database_name: database_name}, name) do
    IO.puts("== Dropping development db ==")
    {message, _code} = System.cmd("mix", ["ecto.drop"])
    IO.puts(message)
    IO.puts("== Creating development db ==")
    {message, _code} = System.cmd("mix", ["ecto.create"])
    IO.puts(message)

    IO.puts("== Restoring development db ==")

    {message, _code} =
      System.cmd("pg_restore", [
        "--no-acl",
        "--clean",
        "--if-exists",
        "--host=localhost",
        "--username=#{postgres_username}",
        "--dbname=#{database_name}",
        "#{name}.dump"
      ])

    IO.puts(message)

    IO.puts("== Migrating development db ==")
    {message, _code} = System.cmd("mix", ["ecto.migrate"])
    IO.puts(message)

    IO.puts("== Loaded #{name}.dump into development db ==")
  end

  @spec save_db(Struct.t(), String.t()) :: :ok
  def save_db(%{database_name: database_name}, name) do
    System.cmd("pg_dump", [
      "-Fc",
      "--file=#{name}.dump",
      database_name
    ])

    IO.puts("== Saved development db to #{name}.dump ==")
  end

  @spec upload_db(String.t(), Struct.t(), String.t(), :backup | :local) :: {<<>>, 0}
  def upload_db(file, %{backup_directory: backup_directory}, ip, :backup) do
    IO.puts("Uploading #{file} to #{ip}:/home/dokku/restore.dump")
    {"", 0} = System.cmd("scp", [backup_directory <> file, "root@#{ip}:/home/dokku/restore.dump"])
  end

  def upload_db(file, _config, ip, :local) do
    IO.puts("Uploading #{file} to #{ip}:/home/dokku/restore.dump")
    {"", 0} = System.cmd("scp", [file, "root@#{ip}:/home/dokku/restore.dump"])
  end

  @spec choose_file(Struct.t()) :: String.t()
  def choose_file(%{backup_directory: backup_directory}) do
    {files, 0} = System.cmd("ls", [backup_directory])

    IO.gets("Please enter one of the following files from your backup directory:\n#{files}")
    |> String.trim()
  end

  @spec run_remote(any, charlist) :: any
  def run_remote(conn, command) do
    IO.puts("Running '#{command}' on server")

    case SSHEx.run(conn, command, exec_timeout: 60_000) do
      {:ok, output, 0} -> IO.puts(output)
      {:error, message} -> IO.puts("Error running command: #{message}")
    end

    conn
  end
end
