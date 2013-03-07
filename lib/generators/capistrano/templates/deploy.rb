# Config this
set :repository,      "REPOSITORY_GIT"
set :application, 'APPLICATION_NAME'

#########
set :stages, %w(production staging)
set :default_stage, "staging"
require 'capistrano/ext/multistage'
require 'capistrano/chef'

default_environment["RAILS_ENV"] = "#{rails_env}"
require "capistrano/configuration/actions/file_transfer"
require "bundler/capistrano"


set :scm,             :git
set :sudo_user,	      'deploy'

set :migrate_target,  :current
set :deploy_to,       "/var/www/#{application}"

require "rvm/capistrano"                  # Load RVM's capistrano plugin.
set :rvm_ruby_string, '1.9.3-p327@bundle'        # Or whatever env you want
set :rvm_type, :system  # Copy the exact line. I really mean :user here

def run_rake(cmd)
  run "cd #{current_path}; #{rake} #{cmd}"
end
