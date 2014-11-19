set_default(:postgresql_host, "localhost")
set_default(:postgresql_user, fetch(:application) )
set_default(:postgresql_password, ask("PostgreSQL Password: ",nil) )
set_default(:postgresql_database, "#{fetch(:application)}_#{fetch(:stage)}" )

namespace :postgres do
  desc "Create a database for this application."
  task :drop_database do
    on roles(:app) do
      if test "[ -f #{shared_path}/config/database.yml ]"
        on primary(:db) do
          sudo "-u postgres psql -c 'drop database #{fetch(:postgresql_database)};'"
          sudo "-u postgres psql -c 'drop user #{fetch(:postgresql_user)};'"
        end

        on roles(:app) do
          execute "rm #{shared_path}/config/database.yml"
        end
      end
    end
  end

  desc "Create a database for this application."
  task :create_database do
    on primary(:db) do
      sudo %Q{-u postgres psql -c "create user #{fetch(:postgresql_user)} with password '#{fetch(:postgresql_password)}';"}
      sudo %Q{-u postgres psql -c "create database #{fetch(:postgresql_database)} owner #{fetch(:postgresql_user)};"}
    end
  end

  desc "Generate the database.yml configuration file."
  task :setup do
    set :linked_files, fetch(:linked_files, []) << 'config/database.yml'
    on roles(:app) do
      unless test "[ -f #{shared_path}/config/database.yml ]"
        invoke 'postgres:create_database'
        execute "mkdir -p #{shared_path}/config"
        template "postgres.yml.erb", "#{shared_path}/config/database.yml"
      end
    end
  end

  after "deploy:starting", "postgres:setup"
end
