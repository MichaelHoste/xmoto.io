set :application, 'xmoto_io'
set :repo_url,    'git@github.com:MichaelHoste/xmoto.io.git'
set :deploy_to,   "/home/deploy/apps/xmoto_io"
set :linked_files, %w{config/database.yml config/initializers/pusher.rb config/initializers/facebook.rb config/initializers/errbit.rb}
set :linked_dirs,  %w{bin log tmp vendor/bundle public/system public/data/Replays public/data/Previews}

set :rbenv_type, 'user'
set :rbenv_ruby, `cat .ruby-version`.strip

# had to put "deploy ALL=NOPASSWD: ALL" in the "sudo visudo" file to allow
# capistrano to start foreman
set :foreman_concurrency, 'web=1,worker=1'
set :foreman_procfile,    'Procfile.production'
set :foreman_env,         'env.production'
set :foreman_log,         "#{deploy_to}/shared/log"
set :foreman_user,        'deploy'

set :keep_releases, 3

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
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

  after :started, :upload_config_files do
    on roles(:app) do
      upload! "config/initializers/facebook.rb", "#{deploy_to}/shared/config/initializers/facebook.rb"
      upload! "config/initializers/pusher.rb",   "#{deploy_to}/shared/config/initializers/pusher.rb"
      upload! "config/initializers/errbit.rb",   "#{deploy_to}/shared/config/initializers/errbit.rb"
      upload! "config/database.yml",             "#{deploy_to}/shared/config/database.yml"

      execute :sudo, "unlink /etc/nginx/sites-enabled/#{fetch(:application)};true"
      execute :sudo, "ln -s #{deploy_to}/current/config/nginx.conf /etc/nginx/sites-enabled/#{fetch(:application)};true"
    end
  end

  # CLONE PRODUCTION TO DEVELOPMENT : "cap production deploy:clone_to_development"
  task :clone_to_development do
    on roles(:app) do
      dev_config  = YAML::load(File.read('config/database.yml'))['development']
      prod_config = YAML::load(File.read('config/database.yml'))['production']

      execute "mysqldump -u #{prod_config["username"]} -p#{prod_config["password"]} #{prod_config["database"]} > /tmp/dump.sql"

      run_locally do
        execute "scp deploy@xmoto.io:/tmp/dump.sql /tmp/dump.sql"
        passwd_option = dev_config['password'].nil? ? '' : "-p#{dev_config['password']}"
        execute "mysql -u #{dev_config['username']} #{passwd_option} #{dev_config['database']} < /tmp/dump.sql"
      end

      execute "cd #{deploy_to}/shared/public/data && tar -jcf replays.tar.bz2 Replays"
      execute "cd #{deploy_to}/shared/public/data && tar -jcf previews.tar.bz2 Previews"

      run_locally do
        execute "scp deploy@xmoto.io:#{deploy_to}/shared/public/data/replays.tar.bz2 public/data"
        execute "scp deploy@xmoto.io:#{deploy_to}/shared/public/data/previews.tar.bz2 public/data"
      end

      execute "rm #{deploy_to}/shared/public/data/replays.tar.bz2"
      execute "rm #{deploy_to}/shared/public/data/previews.tar.bz2"

      run_locally do
        execute "rm -rf public/data/Replays"
        execute "rm -rf public/data/Previews"
        execute "mkdir public/data/Replays public/data/Previews"
        execute "touch public/data/Replays/.keep public/data/Previews/.keep"
        execute "cd public/data && tar -jxf replays.tar.bz2 && rm replays.tar.bz2"
        execute "cd public/data && tar -jxf previews.tar.bz2 && rm previews.tar.bz2"
      end
    end
  end
end

namespace :reset do
  # Reset the entire application (CAREFUL!)
  task :force_reset do
    on roles(:app) do
      execute "rm -rf #{deploy_to}/current/public/data/Replays"
      execute "mkdir #{deploy_to}/current/public/data/Replays"
      execute "rm -rf #{deploy_to}/current/public/data/Previews"
      execute "mkdir #{deploy_to}/current/public/data/Previews"
      execute "cd #{deploy_to}/current && RAILS_ENV=production #{fetch(:rbenv_prefix)} bundle exec rake db:migrate:reset"
      execute "cd #{deploy_to}/current && RAILS_ENV=production #{fetch(:rbenv_prefix)} bundle exec rake db:seed"
    end
  end
end
