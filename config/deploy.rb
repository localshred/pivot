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
end

namespace :db do
  desc "Setup the shared database"
  task :setup, :roles =>:db do
    run "cd #{shared_path}; if [ ! -d 'db/sqlite/' ]; then mkdir -p db/sqlite; fi;"
  end
  
  desc "Create the db tables"
  task :create, :roles => :db do
    run "thor db:create" # create the db folder if it doesn't exist
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
end

# HOOKS
after "deploy:setup" do
  app.setup
  db.setup
end

after "deploy:cold" do
  db.create
end

after "deploy:update" do
  app.copy_settings
end
