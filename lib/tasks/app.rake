namespace :app  do
  task :setup do
    if Rails.env.production?
      puts "Cannot use this task in production"
    else
      # the ruby version is automatically defined in the .rbenv-version file
      [ 'git submodule update --init --recursive',           # get submodules of this project
        'git submodule foreach git pull origin master',      # update submodules of this project
        'rm log/*.log',                                      # rm log files
        "/bin/bash #{Dir.pwd}/bin/rename_tab.sh Server"      #
      ].each do |command|
        puts command
        system(command)
      end

      # Empty shell
      new_tab('Shell', ["cd #{Dir.pwd}", "clear"])

      # Launch server
      system('foreman start -f Procfile.development')
    end
  end

  task :reset => :environment do
    if Rails.env.production?
      puts "Cannot use this task in production"
    else
      system('rm -rf public/data/Replays')
      system('mkdir public/data/Replays')
      system('rake db:migrate:reset')
      system('rake db:seed')
    end
  end

  task :update_xmoto do
    system('rm ./vendor/assets/javascripts/xmoto.js')
    system('cp ../xmoto/bin/xmoto.js ./vendor/assets/javascripts/xmoto.js')
  end
end

def new_tab(name, commands)
  commands = ["/bin/bash #{Dir.pwd}/bin/rename_tab.sh #{name}"] + commands
  command_line = commands.collect! { |command| '-e \'tell application "Terminal" to do script "' + command + '" in front window\''}.join(' ')
  `osascript -e 'tell application "Terminal" to activate' \
             -e 'tell application "System Events" to tell process "Terminal" to keystroke "t" using command down' \
             #{command_line} > /dev/null`
end
