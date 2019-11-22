# ExDokku

Documentation can be found at [https://hexdocs.pm/ex_dokku](https://hexdocs.pm/ex_dokku).

This library assumes that you are:

- Deploying with Dokku
- Using Phoenix
- Using Ecto and Postgres
- Using a Digital Ocean style Dokku server setup

I am testing this setup on Manjaro Linux.

## Installation

ExDokku can be installed by adding `ex_dokku` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_dokku, "~> 0.1.1", only: :dev}
  ]
end
```

Add your configuration to `config/dev.exs`

```elixir
config :ex_dokku,
  app: :your_app,
  repo: YourApp.Repo,
  postgres_username: "postgres",
  backup_directory: "/"
```

Make sure that your server is added to your git remote, as this tool pulls the remote info from git. Add your staging app too if applicable. Note that the remote must be named `dokku` for production and `dokku-staging` for staging.

```bash
git remote add dokku dokku@123.456.789.123:yourproductionapp
git remote add dokku-staging dokku@123.456.789.123:yourstagingapp
```

Add dump files to your .gitignore so you dont push private data to GitHub. This is kind of important.

```bash
*.dump
```

## Usage

### mix dokku.save

Saves your development database to your app root directory as `latest.dump`.

### mix dokku.load

Loads the `latest.dump` from the app root directory as your development database.

### mix dokku.pull

Downloads your production database to your app root directory as `latest.dump` and loads it into your development database. Useful for troubleshooting production issues.

### mix dokku.backup

Downloads your production database to the path set in your config with the name of your app and the date. Re-downloading the file again will replace the previously downloaded file.

### mix dokku.deploy_prod

**This is a kinda dangerous command**

This pushes master to production. You can totally do this yourself with `git push dokku master`. That's cool too.

### mix dokku.deploy_stag

This pushes develop to staging.

### mix dokku.reset_prod

**This is a dangerous command**

Unlinks, destroys, recreates, and then relinks your production database. Confirms beforehand. Make sure you back up your database before issuing this command!
