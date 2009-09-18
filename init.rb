ROOT_DIR = File.expand_path(File.dirname(__FILE__)) unless defined? ROOT_DIR

require "rubygems"

begin
  require "vendor/dependencies/lib/dependencies"
rescue LoadError
  require "dependencies"
end

require "monk/glue"
require "haml"
require "sass"
require "activerecord"
require "track-r"
require "time"
require "date"

class Main < Monk::Glue
  set :app_file, __FILE__
  set :haml, {:format => :html4}
  use Rack::Session::Cookie
  
  configure :development do
    # ActiveRecord::Base.logger = Logger.new(STDERR)
  end
  
  configure :production do
    server_log = File.new("log/server.log", "a") # This will make a nice sinatra log along side your apache access and error logs
    STDOUT.reopen(server_log)
    STDERR.reopen(server_log)
  end
end

# Connect to ActiveRecord
ActiveRecord::Base.establish_connection settings(:active_record)

# Load all application files.
Dir[root_path("app/**/*.rb")].each do |file|
  require file
end

Main.run! if Main.run?
