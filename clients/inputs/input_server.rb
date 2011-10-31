#!/usr/bin/env ruby
# encoding: UTF-8

require 'rubygems'
require 'eventmachine'
require 'evma_httpserver'
require 'em-websocket'
require 'json'
require 'erb'
require 'logger'
require 'singleton'
require 'pry'

HOST    = '0.0.0.0'
Logger  = ::Logger.new(STDOUT)
SOCKETS = []

# This is the http server that will serve the static html page with the voting form.
class HtmlServer < EM::Connection
  include EM::HttpServer

  def process_http_request
    resp = EM::DelegatedHttpResponse.new(self)
    case @http_path_info
    when '/voting'
      html = ERB.new(File.open(File.expand_path('clients/inputs/views/voting.html.erb', '.')).read).result
    when '/controller'
      @@player_count = (@@player_count + 1) % 5
      @@player_count = 1 if @@player_count == 0
      html = ERB.new(File.open(File.expand_path('clients/inputs/views/controller.html.erb', '.')).read).result
    when '/action'
      send_to_socket @http_query_string
    when '/favicon.ico'
      # ZzzzZZZzzz
    when '/current_user_id'
      html = (VoteCounter.current_player + 1).to_s
    else
      html = File.open(File.expand_path("clients/inputs/views#{@http_path_info}", '.'), 'rb').read
    end

    case @http_path_info
    when /css/
      resp.content_type 'text/css'
    when /png/
      resp.content_type 'image/png'
    else
      resp.content_type 'text/html'
    end

    resp.status  = 200
    resp.content = html
    resp.send_response
  rescue
    resp.status = 500
    resp.send_response
    raise
  end

  def send_action param
    SOCKETS.first.send_data({
                                type: 'action',
                                data: {
                                    action_name: param
                                }
                            }.to_json)
  end

  def send_to_socket param
    Logger.info "Action received: #{param}"
    param.match(/param=(.*)/)

    if is_action?($1)
      Logger.info "Is action: #{$1}"
      send_action($1)
    else
      Logger.info "Is not action: #{$1}"
      VoteCounter.add_vote($1)
    end
  end

  def is_action?(value)
    ['up', 'down', 'break'].each do |action|
      return true if value.match action
    end
  end
end


class VoteCounter
  include ::Singleton

  # TODO What is the equivalent of the initilize method in a ruby singleton?
  @votes          = Hash.new(0)
  @current_player = 0

  # @param action [String]
  # @return [Boolean]
  def self.add_vote(action)
    @votes[action] += 1
    Logger.info "Counter for action #{action}: #{@votes[action]}"
  end

  # @return [Boolean]
  def self.end_current_voting
    @current_player = (@current_player + 1) % 5
    @votes          = Hash.new(0)
  end

  # @return [String]
  def self.result
    @votes.select { |k, v| v == @votes.values.max }.keys.first
  end

  def self.current_player
    @current_player
  end
end

EM.run do
  @@player_count = 0

  # This is the socket connection with Squirrel.
  # The result of the voting calculations will be sent through here to the Flash game.
  EventMachine::connect HOST, 8080 do |socket|
    Logger.info "Socket connection opened"
    SOCKETS << socket

    def unbind
      Logger.info "Socket connection closed"
      EventMachine::stop_event_loop
    end
  end

  # This is the websocket connection with the html/javascript page tha contains the
  # voting form (which is served by the HttpServer above)
  EM::WebSocket.start(:host => HOST, :port => 5000) do |ws|
    ws.onopen do |a|
      Logger.info "WebSocket connected"
    end

    ws.onmessage do |message|
      message = JSON.parse(message)
      VoteCounter.add_vote(message["data"]["action_name"])
      Logger.info "Message Received: #{message}"
    end

    ws.onclose do
      Logger.info "Conection closed"
    end

    ws.onerror do |e|
      binding.pry
      Logger.info "Error: #{e}"
    end
  end

  EM::start_server HOST, 4000, HtmlServer

  EM.add_periodic_timer 30 do
    result = VoteCounter.result
    Logger.info "Ending voting. Result: #{result}"

    SOCKETS.first.send_data({
                                type: 'voting',
                                data: {
                                    result: 'bomb_player_1'
                                    #result: result || ""
                                }
                            }.to_json)

    VoteCounter.end_current_voting
  end
end