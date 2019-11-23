defmodule ExDokku.Config.Struct do
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
