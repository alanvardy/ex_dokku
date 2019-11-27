defmodule Mix.Tasks.Dokku.Stag.Deploy do
  @moduledoc "Deploy app to production"
  @shortdoc "Deploy app to production"
  use Mix.Task

  @spec run(any) :: :ok
  def run(_args) do
    IO.puts("== Checking out develop branch ==")
    System.cmd("git", ["checkout", "develop"])
    IO.puts("== Pulling latest updates ==")
    System.cmd("git", ["pull", "origin", "develop"])
    IO.puts("== Pushing to staging ==")
    System.cmd("git", ["push", "dokku-staging", "develop:master"])
    IO.puts("== Deployment Complete ==")
  end
end
