namespace 'codecantor' do
  desc 'Desploy secrets'
  task :secrets do
    on roles(:app) do
      unless test "[ -f #{shared_path}/config/secrets.yml ]"
        require 'securerandom'
        set :secret_rails, SecureRandom.hex(64) if fetch(:secret_rails, nil).nil?
        template 'secrets.yml.erb', "#{shared_path}/config/secrets.yml"
      end
      unless test "[ -f #{shared_path}/config/initializers/devise_secret.rb ]"
        require 'securerandom'
        set :secret_devise, SecureRandom.hex(100) if fetch(:secret_devise, nil).nil?
        execute "mkdir -p #{shared_path}/config/initializers"
        template 'devise_secret.rb.erb', "#{shared_path}/config/initializers/devise_secret.rb"
      end
    end
    set :linked_files, fetch(:linked_files, []) << 'config/secrets.yml'
    set :linked_files, fetch(:linked_files, []) << 'config/initializers/devise_secret.rb'
  end

  desc 'Move logs to shared'
  task :share_logs do
    on roles(:app) do
      execute "mkdir -p #{shared_path}/log"
      set :linked_dirs, fetch(:linked_dirs, [])<< 'log'
    end
  end

  after "deploy:starting", "codecantor:secrets"
  after "deploy:starting", "codecantor:share_logs"
end