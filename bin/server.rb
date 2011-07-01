#!/usr/bin/env ruby

require File.expand_path(File.dirname(__FILE__) + '/../lib/squirrel')
require "rubygems"
require "bundler/setup"
require 'eventmachine'
require 'em-websocket'
require 'em-http'
require 'ruby-debug'
require 'json'

Squirrel::Server.start

# class Player
#   @@all = []
#   @@count = 0

#   attr_accessor :name, :uid, :ws, :top, :left

#   def initialize(ws)
#     @uid = rand(10000)
#     @ws = ws
#     @top = 10
#     @left = 10 + (@@count * 10) 
#     @@count += 1
#     @name = "player#{@@count}"
#     @@all << self
#     ws.send({ :action => :player_info, :params => { :uid => @uid, :name => @name} }.to_json)
#     Player.all.each {|p| p.ws.send({ :action => :send_state, :params => Player.state}.to_json)}
#   end

#   def self.state
#     Player.all.collect{|p| { :uid => p.uid, :name => p.name, :top => p.top, :left => p.left }}
#   end

#   def self.all
#     @@all
#   end

#   def self.find_by_name(name)
#     @@all.select {|p| p.name == name}.first
#   end

#   def self.find_by_uid(uid)
#     @@all.select {|p| p.uid == uid}.first
#   end
# end
