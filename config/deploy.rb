set :application, "pivot"
set :domain,      "rog.bidsync.com"

set :scm,         "git"
set :branch,      "master"

set :user,        "pivot"
set :password,    "quD30Tx55Ehu"
set :use_sudo,    false

set :local_repository,  "#{user}@#{domain}:/opt/gitrepo/#{application}.git"
set :repository,  "file:///opt/gitrepo/#{application}.git"
set :deploy_to,   "/var/www/#{application}"

role :app, domain
role :web, domain
role :db,  domain, :primary => true

namespace :deploy do
  
  desc "Start the application server"
  task :start, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  desc "Stop the application server"
  task :stop, :roles => :app do
    # Do nothing.
  end

  desc "Restart the application server"
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end
  
  task :migrate, :roles => :db do
    # Do nothing, hooks will handle this later
  end
  
end

namespace :app do
  
  desc "Create the app-specific folders in shared"
  task :setup, :roles => :app do
    run "cd #{shared_path}; if [ ! -d 'config' ]; then mkdir -p config; fi;"
  end
  
  desc "Copy the example settings.yml to the real thing"
  task :copy_settings, :roles => :app do
    run "cd #{current_release}/config; cp settings.example.yml #{shared_path}/config/settings.yml" # copy the config file to shared
    run "ln -s #{shared_path}/config/settings.yml #{current_release}/config/settings.yml" # create a symlink to current
  end
  
  desc "Upload the settings file"
  task :upload_settings, :roles => :app do
    upload "config/settings.yml", "#{shared_path}/config/settings.yml", :via => :scp
  end
  
  desc "tail production log files" 
  task :tail_logs, :roles => :app do
    begin
      run "tail -f #{shared_path}/log/server.log" do |channel, stream, data|
        puts  # for an extra line break before the host name
        puts "#{channel[:host]}: #{data}" 
        break if stream == :err
      end
    rescue
      # silently ignore the Interrupt
    end
  end

  namespace :apache do

    task :default, :roles => :app do
      processes
    end

    desc "Check Apache processes"
    task :ps, :roles => :app do
      puts "Apache processes:"
      run "ps aux | grep -i apache" do |channel, stream, data|; puts data; end
    end

    desc "Test Apache configuration"
    task :test_config, :roles => :app do
      puts "Testing apache configuration..."
      run "apache2ctl -t" do |channel, stream, data|; puts data; end
    end

    desc "Test Apache configuration"
    task :vhosts, :roles => :app do
      puts "Apache Vhosts:"
      run "apache2ctl -t -D DUMP_VHOSTS" do |channel, stream, data|; puts data; end
    end

  end

  namespace :passenger do

    task :default, :roles => :app do
      processes
      memory
    end

    desc "Check Passenger processes"
    task :ps, :roles => :app do
      puts "Passenger processes:"
      run "ps aux | grep -i passenger" do |channel, stream, data|; puts data; end
    end

    desc "Check Passenger memory stats"
    task :memory, :roles => :app do
      puts "Passenger Stats:"
      run "passenger-memory-stats" do |channel, stream, data|; puts data; end
    end

  end

end

namespace :db do
  
  desc "Setup the shared database"
  task :setup, :roles =>:db do
    run "cd #{shared_path}; if [ ! -d 'db/sqlite/' ]; then mkdir -p db/sqlite; fi;"
  end
  
  desc "Create the db tables"
  task :create, :roles => :db do
    run "cd #{current_release}; thor db:create" # create the db folder if it doesn't exist
  end
  
  desc "Drop the db tables"
  task :drop, :roles => :db do
    run "cd #{current_release}; thor db:drop"
  end
  
  desc "Reload the db tables"
  task :reload, :roles => :db do
    run "cd #{current_release}; thor db:reload"
  end
  
  desc "Seed the db tables"
  task :seed, :roles => :db do
    run "cd #{current_release}; thor db:seed"
  end
  
  desc "Symlink the database from shared to current"
  task :create_symlink, :roles => :db do
    run "cd #{current_release}/db; ln -s #{shared_path}/db/sqlite"
  end
  
end

# HOOKS
after "deploy:setup" do
  app.setup
  db.setup
end

after "deploy:update" do
  app.copy_settings
  db.create_symlink
end

after "deploy:cold" do
  db.create
end
