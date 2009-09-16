set :user, "deployer"
set :password, "deployerpassword"
set :ssh_options, { :forward_agent => true }
set :application, "pivot"
set :domain,      "rog.bidsync.com"
set :repository,  "/opt/gitrepo/#{application}.git"
set :use_sudo,    false
set :deploy_to,   "/var/www/#{application}"
set :scm,         "git"
set :branch,      "master"

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
end

namespace :db do
  desc "Create the db tables"
  task :create, :roles => :db do
    run "thor db:create"
  end
  
  desc "Drop the db tables"
  task :drop, :roles => :db do
    run "thor db:drop"
  end
  
  desc "Reload the db tables"
  task :reload, :roles => :db do
    run "thor db:reload"
  end
  
  desc "Seed the db tables"
  task :seed, :roles => :db do
    run "thor db:seed"
  end
end