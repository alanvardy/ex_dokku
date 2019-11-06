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
  backup_directory: "/home/user/dbbackup/"
```

Make sure that your server is added to your git remote, as this tool pulls the remote info from git.

```bash
git remote add dokku dokku@123.456.789.123:yourapp
```

Add dump files to your .gitignore so you dont push private data to GitHub.

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

### mix dokku.reset_prod

**This is a dangerous command**

Unlinks, destroys, recreates, and then relinks your production database. Confirms beforehand. Make sure you back up your database before issuing this command!

### mix dokku.restore_prod

**This is a dangerous command**

Unlinks, destroys, recreates, relinks and then restores your production database from a selected backup on your local machine. Confirms beforehand. Make sure you back up your database before issuing this command!
