# config valid only for Capistrano 3.1
lock '3.1.0'

set :application, 'xmoto_io'
set :repo_url,    'git@github.com:MichaelHoste/xmoto_io.git'
set :deploy_to,   "/home/#{user}/apps/#{application}"
set :linked_files, %w{config/database.yml config/initializers/pusher.rb config/initializers/facebook.rb}
set :linked_dirs,  %w{bin log tmp vendor/bundle public/system public/data}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

set :rbenv_type, 'user'
set :rbenv_ruby, '2.1.0' # TODO : try  "set :rbenv_ruby, `cat .ruby-version`.strip"

set :foreman_sudo,        'sudo'
set :foreman_concurrency, '-c web=1,worker=1'

set :keep_releases, 10

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
      sudo "unlink /etc/nginx/sites-enabled/#{application};true"
      sudo "ln -s #{deploy_to}/current/config/nginx.conf /etc/nginx/sites-enabled/#{application};true"

      foreman.export
      foreman.restart
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
end
