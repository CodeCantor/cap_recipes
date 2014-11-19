set_default(:postgresql_pid, "/var/run/postgresql/9.1-main.pid" )

namespace :monit do
  desc "Setup all Monit configuration"
  task :setup do
    invoke 'monit:unicorn'
    invoke 'monit:syntax'
    invoke 'monit:reload'
  end
  after "deploy:starting", "monit:setup"

  task :unicorn do
    on roles(:app) do
      monit_config "unicorn", "#{fetch(:application)}_unicorn"
    end
  end

  %w[start stop restart syntax reload].each do |command|
    desc "Run Monit #{command} script"
    task command do
      on roles(:app) do
        sudo "service monit #{command}"
      end
    end
  end
end

def monit_config(name, d_name=nil, destination = nil)
  d_name ||= name
  destination ||= "/etc/monit/conf.d/#{d_name}.conf"
  template "monit/#{name}.erb", "/tmp/monit_#{d_name}"
  sudo "mv /tmp/monit_#{d_name} #{destination}"
  sudo "chown root #{destination}"
  sudo "chmod 600 #{destination}"
end
