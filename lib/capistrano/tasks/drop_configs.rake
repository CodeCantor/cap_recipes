namespace :drop_configs do
  desc "Delete all configurations and files"
  task :all do
    invoke 'nginx:drop_config'
    invoke 'postgres:drop_database'
    invoke 'unicorn:drop_config'
  end
end