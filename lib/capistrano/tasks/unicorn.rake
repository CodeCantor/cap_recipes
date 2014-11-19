set_default(:unicorn_user, fetch(:user) )
set_default(:unicorn_pid, "#{shared_path}/tmp/pids/unicorn.pid")
set_default(:unicorn_config, "#{shared_path}/config/unicorn.rb" )
set_default(:unicorn_log, "#{shared_path}/log/unicorn.log")
set_default(:unicorn_workers, 2)
set_default(:unicorn_timeout, 15)

namespace :unicorn do
  desc "Setup Unicorn initializer and app configuration"
  task :setup do
      on roles(:app) do
        unless test "[ -f /etc/init.d/unicorn_#{fetch(:application)} ]"
          info "Setting up unicorn"
          execute "mkdir -p #{shared_path}/config"
          template "unicorn.rb.erb", fetch(:unicorn_config)
          template "unicorn_init.erb", "/tmp/unicorn_init"
          execute "chmod +x /tmp/unicorn_init"
          sudo "mv /tmp/unicorn_init /etc/init.d/unicorn_#{fetch(:application)}"
          sudo "update-rc.d -f unicorn_#{fetch(:application)} defaults"
          execute "mkdir -p #{shared_path}/tmp/pids"
        end
      end
      set :linked_dirs, fetch(:linked_dirs, [])<< 'tmp'
  end
  after "deploy:starting", "unicorn:setup"

  desc "Dropping unicorn configuration"
  task :drop_config do
    on roles(:app) do
      sudo "update-rc.d -f unicorn_#{fetch(:application)} remove"
      sudo "rm /etc/init.d/unicorn_#{fetch(:application)}" if test("[ -f /etc/init.d/unicorn_#{fetch(:application)} ]")
      sudo "rm #{fetch(:unicorn_config)}" if test("[ -f #{fetch(:unicorn_config)} ]")
    end
  end

  %w[restart].each do |command|
    desc "#{command} unicorn"
    task command do
      on roles(:app) do
        sudo "service unicorn_#{fetch(:application)} #{command}"
      end
    end
    after "deploy:#{command}", "unicorn:#{command}"
  end
end
