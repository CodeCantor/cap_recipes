namespace :nginx do
  desc "Setup nginx configuration for this application"
  task :create_config do
    on roles(:web) do
      unless test "[ -f /etc/nginx/sites-enabled/#{fetch(:application)} ]"
        info "Setting up nginx configuration"
        template "nginx_unicorn.erb", "/tmp/nginx_conf"
        sudo "mv /tmp/nginx_conf /etc/nginx/sites-enabled/#{fetch(:application)}"
        sudo "rm -f /etc/nginx/sites-enabled/default"
        sudo "rm -f /etc/nginx/sites-enabled/000-default"
        invoke 'nginx:restart'
      end
    end
  end

  desc "Remove configuration for this application in nginx"
  task :drop_config do
    on roles(:web) do
      if test "[ -f /etc/nginx/sites-enabled/#{fetch(:application)} ]"
        info "Dropping nginx configuration"
        sudo "rm /etc/nginx/sites-enabled/#{fetch(:application)}"
        invoke 'nginx:restart'
      end
    end
  end

  after "deploy:starting", "nginx:create_config"

  %w[start stop restart].each do |command|
    desc "#{command} nginx"
    task command do
      on roles(:web) do
        sudo "service nginx #{command}"
      end
    end
  end
end
