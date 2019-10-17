# ExDokku

Documentation can be found at [https://hexdocs.pm/ex_dokku](https://hexdocs.pm/ex_dokku).

This library is currently being used with Dokku deployments on Digital Ocean

## Installation

ExDokku can be installed by adding `ex_dokku` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_dokku, "~> 0.1.0", only: :dev}
  ]
end
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

### mix dokku.pull

Downloads your production database as `latest.dump` and loads it into your development database. Useful for troubleshooting production issues.
