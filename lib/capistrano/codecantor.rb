module Capistrano
  module DSL
    def template(from, to)
      erb = File.read(File.expand_path("../templates/#{from}", __FILE__))
      upload! StringIO.new(ERB.new(erb).result(binding)), to
    end

    def set_default(name, *args, &block)
      set(name, *args, &block) unless any?(name)
    end

    def with_sudo_user(&block)
      with_user sudo_user do
        yield
      end
    end

    def with_user(new_user, &block)
      old_user = user
      set :user, new_user
      close_sessions
      yield
      set :user, old_user
      close_sessions
    end

    def close_sessions
      sessions.values.each { |session| session.close }
      sessions.clear
    end
  end
end

load File.expand_path("../tasks/unicorn.rake", __FILE__)
load File.expand_path("../tasks/postgresql.rake", __FILE__)
load File.expand_path("../tasks/nginx.rake", __FILE__)
load File.expand_path("../tasks/monit.rake", __FILE__)
load File.expand_path("../tasks/drop_configs.rake", __FILE__)
load File.expand_path("../tasks/base.rake", __FILE__)

