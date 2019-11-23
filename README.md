# ExDokku

Quality of life tools for working with Dokku. One liners for working with databases in development, staging, and production. 

Documentation can be found at [https://hexdocs.pm/ex_dokku](https://hexdocs.pm/ex_dokku).

This library assumes that you are:

- Deploying with Dokku
- Using Phoenix
- Using Ecto and Postgres
- Using a Digital Ocean style Dokku server setup

I am testing this setup on Manjaro Linux. I am neither a member of, nor affiliated with the Dokku team. Use this library at your own risk.

## Installation

ExDokku can be installed by adding `ex_dokku` and `observer_cli` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_dokku, "~> 0.1.2", only: :dev},
    {:observer_cli, "~> 1.5"}
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

### Local

####  mix dokku.local.save

Saves your development database to your app root directory as `latest.dump`.

#### mix dokku.local.load

Loads the `latest.dump` from the app root directory as your development database.

### Staging

#### mix dokku.stag.obs

Pulls up instructions for running observer_cli in staging (sorry, I am unable to just boot it myself)

#### mix dokku.stag.deploy

This pushes develop to staging.

#### mix dokku.stag.restore

This pulls the production database as latest.dump, uploads it to the staging server and loads it into the staging database.

### Production

#### mix dokku.prod.obs

Pulls up instructions for running observer_cli in staging

#### mix dokku.prod.pull

Downloads your production database to your app root directory as `latest.dump` and loads it into your development database. Useful for troubleshooting production issues.

#### mix dokku.prod.backup

Downloads your production database to the path set in your config with the name of your app and the date. Re-downloading the file again will replace the previously downloaded file.

#### mix dokku.prod.deploy

**This is a _kinda_ dangerous command**

This pushes master to production. You can totally do this yourself with `git push dokku master`. That's cool too.

#### mix dokku.prod.reset

**This is a dangerous command**

Unlinks, destroys, recreates, and then relinks your production database. Confirms beforehand. Make sure you back up your database before issuing this command!

#### mix dokku.prod.restore

**This is a dangerous command**

Unlinks, destroys, recreates, relinks and then restores your production database from a selected backup on your local machine. Confirms beforehand. Make sure you back up your database before issuing this command!
