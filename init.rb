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
  set :haml, {:format => :html4 }
  use Rack::Session::Cookie
end

# Connect to ActiveRecord
ActiveRecord::Base.establish_connection settings(:active_record)
ActiveRecord::Base.logger = Logger.new(STDERR)

# Load all application files.
Dir[root_path("app/**/*.rb")].each do |file|
  require file
end

Main.run! if Main.run?
