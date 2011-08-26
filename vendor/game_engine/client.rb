#!/usr/bin/env ruby
# encoding: UTF-8

require "rubygems"
require "eventmachine"

module HttpHeaders 
  def post_init
    puts 'Connected'
  end
  
  def receive_data(data)
    puts data
  end
  
  def unbind
    puts 'Disconected'
    
    EventMachine::stop_event_loop
  end
end

EventMachine::run do
  EventMachine::connect "0.0.0.0", 9090, HttpHeaders
end