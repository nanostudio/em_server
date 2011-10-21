#!/usr/bin/env ruby
# encoding: UTF-8

require "rubygems"
require "eventmachine"
require 'json'
#require 'pry'

module HttpHeaders
  def post_init
    puts 'Connected to Squirrel via socket on port 9090.'
  end

  def receive_data(data)
    #binding.pry
    puts JSON.parse data
  end

  def unbind
    EventMachine::stop_event_loop
  end
end

EventMachine::run do
  EventMachine::connect "0.0.0.0", 9090, HttpHeaders
end