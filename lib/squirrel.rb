require "rubygems"
require "bundler/setup"
require 'eventmachine'
require 'em-websocket'
require 'em-http'
require 'ruby-debug'
require 'json'
require 'yaml'

require File.expand_path(File.dirname(__FILE__) + '/../lib/squirrel/server')
require File.expand_path(File.dirname(__FILE__) + '/../lib/squirrel/input')
require File.expand_path(File.dirname(__FILE__) + '/../lib/squirrel/game_engine')

require File.expand_path(File.dirname(__FILE__) + '/../lib/squirrel/inputs/websocket')