require "activerecord"
require "db/create_tables"

class Monk < Thor
  namespace :monk

  include Thor::Actions

  desc "test", "Run all tests"
  def test
    verify_config(:test)

    $:.unshift File.join(File.dirname(__FILE__), "test")

    Dir['test/**/*_test.rb'].each do |file|
      load file unless file =~ /^-/
    end
  end

  desc "stories", "Run user stories."
  method_option :pdf, :type => :boolean
  def stories
    $:.unshift(Dir.pwd, "test")

    ARGV << "-r"
    ARGV << (options[:pdf] ? "stories-pdf" : "stories")
    ARGV.delete("--pdf")

    Dir["test/stories/*_test.rb"].each do |file|
      load file
    end
  end

  desc "start ENV", "Start Monk in the supplied environment"
  def start(env = ENV["RACK_ENV"] || "development")
    verify_config(env)

    exec "env RACK_ENV=#{env} ruby init.rb"
  end

  desc "copy_example EXAMPLE, TARGET", "Copies an example file to its destination"
  def copy_example(example, target = target_file_for(example))
    File.exists?(target) ? return : say_status(:missing, target)
    File.exists?(example) ? copy_file(example, target) : say_status(:missing, example)
  end

private

  def self.source_root
    File.dirname(__FILE__)
  end

  def target_file_for(example_file)
    example_file.sub(".example", "")
  end

  def verify_config(env)
    verify "config/settings.example.yml"
  end

  def verify(example)
    copy_example(example) unless File.exists?(target_file_for(example))
  end

end

class DB < Thor
  namespace :db
  
  # def initialize
  #   @db_loaded = false
  # end
  
  desc "create [ENV]", "Create the database tables, optionally passing environment."
  def create(env="development")
    begin
      load_db(env) unless @db_loaded
      if !CreateTables.tables_exist?
        CreateTables.up
      else
        raise Exception, "Database tables already exist!"
      end
    rescue Exception => e
      puts e.message
    end
  end
  
  desc "drop [ENV]", "Drop the database tables, optionally passing environment."
  def drop(env="development")
    begin
      load_db(env) unless @db_loaded
      if CreateTables.tables_exist?
        CreateTables.down
      else
        raise Exception, "Database tables do not exist!"
      end
    rescue Exception => e
      puts e.message
    end
  end
  
  desc "seed [ENV]", "Provide seed data to the database, optionally passing environment."
  def seed(env="development")
    begin
      load_db(env) unless @db_loaded
      Dir[File.join('db', 'seed', '*.rb')].sort.each { |fixture| require fixture }
      Dir[File.join('db', 'seed', env, '*.rb')].sort.each { |fixture| require fixture }
    rescue Exception => e
      puts e.message
    end
  end
  
  desc "reload [ENV]", "Drop and recreate the database tables, providing seed data. Optionally passing environment."
  def reload(env="development")
    begin
      drop(env)
      create(env)
      seed(env)
    rescue Exception => e
      puts e.message
    end
  end
  
  private
  
  def load_db(env)
    unless @db_loaded
      establish_connection(env)
      load_models
      @db_loaded = true
    end
  end
  
  def establish_connection(env)
    config = load_config(env)
    ActiveRecord::Base.establish_connection config[:active_record]
  end
  
  def load_config(env)
    YAML.load_file(File.join("config", "settings.yml"))[env.to_sym]
  end
  
  def load_models
    Dir[File.join('app', 'models', '*.rb')].sort.each { |fixture| require fixture }
  end
  
end