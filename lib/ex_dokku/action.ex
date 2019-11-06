defmodule ExDokku.Action do
  @moduledoc "Core actions for ExDokku"
  alias ExDokku.{Config, Local, Remote}

  def start_ssh do
    {:ok, _started} = Application.ensure_all_started(:sshex)
  end

  defp connect_ssh() do
    ip = Remote.server_ip()

    SSHEx.connect(ip: ip, user: "root")
    |> elem(1)
  end

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

  def reset_prod_db do
    app = Remote.app_name()
    db = Remote.database_name()

    confirmation =
      IO.gets("""
      WARNING: THIS ACTION WILL ERASE YOUR PRODUCTION DATABASE
      Make sure you have a backup with mix dokku.backup before continuing.
      Type in #{db} to confirm

      """)
      |> String.trim()

    unless confirmation == db do
      raise "Cancelled"
    end

    conn = connect_ssh()
    IO.puts("Unlinking #{db} from #{app}")
    {:ok, output, 0} = SSHEx.run(conn, 'dokku postgres:unlink #{db} #{app}', exec_timeout: 60_000)
    IO.puts(output)
    IO.puts("Destroying #{db}")
    {:ok, output, 0} = SSHEx.run(conn, 'dokku postgres:destroy #{db} -f', exec_timeout: 60_000)
    IO.puts(output)
    IO.puts("Creating #{db}")
    {:ok, output, 0} = SSHEx.run(conn, 'dokku postgres:create #{db}', exec_timeout: 60_000)
    IO.puts(output)
    IO.puts("Linking #{db} to #{app}")
    {:ok, output, 0} = SSHEx.run(conn, 'dokku postgres:link #{db} #{app}', exec_timeout: 60_000)
    IO.puts(output)
  end
end
