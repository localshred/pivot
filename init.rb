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

class Main < Monk::Glue
  set :app_file, __FILE__
  set :haml, {:format => :html4 }
  use Rack::Session::Cookie
end

# Connect to ActiveRecord
ActiveRecord::Base.establish_connection settings(:active_record)

# Create the tables if they haven't been
# Load all application files.
Dir[root_path("app/**/*.rb")].each do |file|
  require file
end

require "db/create_tables"
class Main < Monk::Glue
  configure :development, :test, :production do
    CreateTables.up if !CreateTables.tables_exist?
  end
end

Main.run! if Main.run?
