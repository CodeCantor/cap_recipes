namespace :assets do
  desc "Compress assets in a local file"
  task :compress_assets do
    run_locally do
      with rails_env: fetch(:stage) do
        execute 'rm -rf public/assets/*'
        rake 'assets:precompile'
        execute 'touch assets.tgz && rm assets.tgz'
        execute 'tar zcvf assets.tgz public/assets/'
        execute 'mv assets.tgz public/assets/'
      end
    end
  end
  before "deploy:update_code", "assets:compress_assets"

  desc "Upload assets"
  task :upload_assets do
    on roles(:web) do
      upload('public/assets/assets.tgz', release_path + '/assets.tgz', via: :scp)
      execute "cd #{fetch(:release_path)}; tar zxvf assets.tgz; rm assets.tgz"
    end
  end
  after "deploy:finalize_update", "assets:upload_assets"

  desc "Remove assets unpacked"
  task :remove_assets do
    run_locally do
      execute "rm -rf public/assets/*"
    end
  end
  after "assets:upload_assets", "assets:remove_assets"
end
