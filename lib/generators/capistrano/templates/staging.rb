set :rails_env,       "staging"
set :branch,          "origin/master"
default_environment["RAILS_ENV"] = "#{rails_env}"
set :server_name, 'SERVER_NAME'

chef_role :web, 'roles:app_APPLICATION'
chef_role :app, 'roles:app_APPLICATION'
chef_role :db, 'roles:app_APPLICATION', primary: true
