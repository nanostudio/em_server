#!/usr/bin/env ruby

# gem install eventmachine --pre
# gem install em-http-request --pre
# gem install em-websocket
# gem install nokogiri
# gem install json

require 'rubygems'
require 'eventmachine'
require 'em-websocket'
require 'em-http'
require 'nokogiri'
require 'json'
require 'pp'

EM.run do
  EM::WebSocket.start(:host => '0.0.0.0', :port => 8080) do |ws|
    ws.onopen { puts 'Client Connected' }

    ws.onmessage do |msg|
      ws.send msg
    end

    ws.onclose { puts 'closed'}
    ws.onerror { |e| puts "err #{e.message}" }
  end
end