defmodule Mix.Tasks.Dokku.Prod.Deploy do
  @moduledoc "Deploy app to production"
  @shortdoc "Deploy app to production"
  use Mix.Task

  @spec run(any) :: :ok
  def run(_args) do
    IO.puts("== Checking out master branch ==")
    System.cmd("git", ["checkout", "master"])
    IO.puts("== Pulling latest updates ==")
    System.cmd("git", ["pull", "origin", "master"])
    IO.puts("== Pushing to production ==")
    System.cmd("git", ["push", "dokku", "master"])
    IO.puts("== Deployment Complete ==")
  end
end
