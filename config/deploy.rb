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
  desc "Copy the example settings.yml to the real thing"
  task :copy_settings, :roles => :app do
    run "cd #{current_release}/config; cp settings.example.yml settings.yml;"
  end
end

namespace :db do
  desc "Create the db tables"
  task :create, :roles => :db do
    run "cd #{current_release}; thor db:create"
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
after("deploy:cold", ["app:copy_settings","db:create"])
