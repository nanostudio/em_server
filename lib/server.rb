#!/usr/bin/env ruby

require "rubygems"
require "bundler/setup"
require 'eventmachine'
require 'em-websocket'
require 'em-http'
require 'ruby-debug'
require 'json'


class Player
  @@all = []
  @@count = 0

  attr_accessor :name, :uid, :ws, :top, :left

  def initialize(ws)
    @uid = rand(10000)
    @ws = ws
    @top = 10
    @left = 10 + (@@count * 10) 
    @@count += 1
    @name = "player#{@@count}"
    @@all << self
    ws.send({ :action => :player_info, :params => { :uid => @uid, :name => @name} }.to_json)
    Player.all.each {|p| p.ws.send({ :action => :send_state, :params => Player.state}.to_json)}
  end

  def self.state
    Player.all.collect{|p| { :uid => p.uid, :name => p.name, :top => p.top, :left => p.left }}
  end

  def self.all
    @@all
  end

  def self.find_by_name(name)
    @@all.select {|p| p.name == name}.first
  end

  def self.find_by_uid(uid)
    @@all.select {|p| p.uid == uid}.first
  end
end

EM.run do
  # NanoWars::Game.start
  #   Connection.start
  EM::WebSocket.start(:host => '0.0.0.0', :port => 8080) do |ws|
    ws.onopen do
      # Game.new_player(ws)
      puts "Client connected."
      player = Player.new(ws)
      Player.all.each { |p| p.ws.send({:action => 'new_player', :params => {:uid => player.uid, :name => player.name}}.to_json) }
    end

    ws.onmessage do |data|
      # Game.on_message(data)
      puts "Message received: '#{JSON.parse(data)}'."
      data = JSON.parse(data)
      player = Player.find_by_uid(data['state']['uid'])
      player.top = data['state']['top']
      player.left = data['state']['left']

      state = []
      Player.all.each do |p|
        state << {
        :uid => p.uid,
        :name => p.name,
        :top => p.top,
        :left => p.left
      }
      end
      
      Player.all.each { |p| p.ws.send( { :action => 'send_state', :params => state }.to_json )}
    end

    ws.onclose do
      # Game.remove_current_player
      current = []
      Player.all.delete_if {|p| current << p if p.ws == ws}
      Player.all.each { |p| p.ws.send({:action => 'player_exited', :params => {:uid => current.first.uid}}.to_json) }
      puts "Client #{current.first.uid} disconnected."
    end

    ws.onerror { |e| puts "err #{e.message}\n#{caller.join("\n")}" }
  end
  puts "Server is up! Open '#{File.expand_path('../../index.html', __FILE__)}' on your browser."
end