defmodule ExDokku.Config.Struct do
  @moduledoc "Represents all the configuration info"
  @type t :: %__MODULE__{
          app: nil | atom,
          repo: nil | atom,
          backup_directory: String.t() | nil,
          postgres_username: String.t() | nil,
          database_name: String.t() | nil,
          env_info: nil | map,
          git_stag: String.t() | nil,
          git_prod: String.t() | nil,
          ip_stag: String.t() | nil,
          ip_prod: String.t() | nil,
          app_stag: String.t() | nil,
          app_prod: String.t() | nil,
          db_stag: String.t() | nil,
          db_prod: String.t() | nil
        }

  defstruct app: nil,
            repo: nil,
            backup_directory: nil,
            postgres_username: nil,
            database_name: nil,
            env_info: nil,
            git_stag: nil,
            git_prod: nil,
            ip_stag: nil,
            ip_prod: nil,
            app_stag: nil,
            app_prod: nil,
            db_stag: nil,
            db_prod: nil
end
