require "rubygems"
require "bundler/setup"
require 'eventmachine'
require 'em-websocket'
require 'em-http'
require 'json'
require 'yaml'
require 'active_support/inflector'
require 'securerandom'
require 'logger'
require 'pry'

require File.expand_path(File.dirname(__FILE__) + '/../lib/squirrel/server')
require File.expand_path(File.dirname(__FILE__) + '/../lib/squirrel/input')
require File.expand_path(File.dirname(__FILE__) + '/../lib/squirrel/output')
require File.expand_path(File.dirname(__FILE__) + '/../lib/squirrel/game_engine')

# TODO carregar todos os arquivos nessas pastar
require File.expand_path(File.dirname(__FILE__) + '/../lib/squirrel/inputs/websocket')
require File.expand_path(File.dirname(__FILE__) + '/../lib/squirrel/inputs/socket')
require File.expand_path(File.dirname(__FILE__) + '/../lib/squirrel/outputs/websocket')
require File.expand_path(File.dirname(__FILE__) + '/../lib/squirrel/game_engines/socket')