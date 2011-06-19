#!/usr/bin/env ruby

require "rubygems"
require "bundler/setup"
require 'eventmachine'
require 'em-websocket'
require 'em-http'

@@clients = Array.new

EM.run do
  EM::WebSocket.start(:host => '0.0.0.0', :port => 8080) do |ws|
    # channel = EM::Channel.new

    ws.onopen do
      puts "Client connected."
      @@clients << ws
      # channel.subscribe{ |msg| p [:got, 'msg'] }
    end

    ws.onmessage do |data|
      puts "Message received: '#{data.strip}'."
      @@clients.each { |c| c.send(data.strip) }
    end

    ws.onclose do
      @@clients.delete(self)
      puts "Client disconnected."
    end
    ws.onerror { |e| puts "err #{e.message}" }
  end

  puts "Server is up! Open 'index.html' on your browser."
end