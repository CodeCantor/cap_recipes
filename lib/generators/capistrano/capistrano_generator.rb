class CapistranoGenerator < Rails::Generators::Base
  source_root File.expand_path("../templates", __FILE__)

  desc "Create files used by deploy and add to submodule the cantor tasks"
  def create_capistrano_files
    copy_file "Capfile", "Capfile" 
    copy_file "deploy.rb","config/deploy.rb"
    empty_directory "config/deploy"
    copy_file "staging.rb","config/deploy/staging.rb"
    copy_file "production.rb", "config/deploy/production.rb"
    
    gem_group :development do
      gem 'capistrano'
      gem 'capistrano-chef'
      gem 'rvm-capistrano'
      gem 'capistrano-ext'
    end
    
    git add: "Capfile config/deploy.rb config/deploy/staging.rb config/deploy/production.rb" 

    inside('.') do
      run 'bundle install'
    end
    puts 'You have to commit the chagnes with your data'
  end
end
