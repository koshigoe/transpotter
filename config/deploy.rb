# config valid only for current version of Capistrano
lock '3.5.0'

set :application, 'app'
set :repo_url, 'https://github.com/koshigoe/transpotter.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: 'log/capistrano.log', color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system')

# Default value for default_env is {}
set :default_env, { path: '/usr/pgsql-9.5/bin:$PATH' }

set :migration_role, :api
set :puma_role, :api

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do
  task :setup_deploy_to do
    on release_roles(:all) do |host|
      sudo "install --owner=#{host.user} --mode=0755 -d #{deploy_to}" if test("[ ! -d #{deploy_to} ]")
    end
  end
  before 'deploy:starting', 'deploy:setup_deploy_to'

  task :restart do
    on release_roles(:api), in: :groups, limit: 1, wait: 15 do
      within current_path do
        invoke 'puma:restart'
      end
    end
  end
  after 'deploy:publishing', 'deploy:restart'

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
