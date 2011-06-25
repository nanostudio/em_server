#!/usr/bin/env ruby

require "rubygems"
require "bundler/setup"
require 'eventmachine'
require 'em-websocket'
require 'em-http'
require 'ruby-debug'
require 'json'


class Player
  @@all = Array.new
  @@count = 0

  attr_accessor :name, :uid, :ws

  def initialize(ws)
    @uid = rand(10000)
    @ws = ws
    @@count += 1
    @name = "player#{@@count}"
    @@all << {@id => @ws}
    ws.send({ :action => :player_info, :params => { :id => @uid, :name => @name} }.to_json)
  end

  def self.all
    @@all
  end
end

EM.run do
  EM::WebSocket.start(:host => '0.0.0.0', :port => 8080) do |ws|
    ws.onopen do
      puts "Client connected."
      player = Player.new(ws)
      Player.all.each { |c| player.ws.send({:action => 'new_player_info', :params => {:id => player.uid, :name => player.name}}.to_json) }
    end

    ws.onmessage do |data|
      puts "Message received: '#{JSON.parse(data)}'."
      data = JSON.parse(data)
      Player.all.each { |c| c[:ws].send({:state => data[data.keys.first]}.merge(:name => data.keys.first).to_json) }
    end

    ws.onclose do
      # @@clients.delete(self)
      puts "Client disconnected."
    end

    ws.onerror { |e| puts "err #{e.message}\n#{caller.join("\n")}" }
  end
  puts "Server is up! Open '#{File.expand_path('../../index.html', __FILE__)}' on your browser."
end