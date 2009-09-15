$:.unshift(File.dirname(__FILE__))
require File.join(File.dirname(__FILE__), '/../config/environment.rb')
require 'track-r/project'
require 'track-r/iteration'
require 'track-r/story'
require 'track-r/token'
require 'track-r/tracker'
require 'cgi'
require 'net/http'
require 'timeout'

# Load configuration globals
CONFIG = YAML.load_file(File.join(File.dirname(__FILE__), '/../config/config.yml'))
