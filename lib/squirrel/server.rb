module Squirrel
  Logger = ::Logger.new(STDOUT)

  module Server
    def self.start
      EM.run do
        yml = YAML.load_file Squirrel::Server.root + '/config/squirrel.yml'

        Input.start_strategy(yml.fetch('input', nil))

        Server.config do |config|
          config.output       yml.fetch('output', nil)
          config.game_engine  yml.fetch('game_engine', nil)
        end
      end
    end

    def self.config
      yield self
    end

    def self.root
      @root ||= File.expand_path(File.dirname(__FILE__) + '/../..')
    end

    def self.output(output)
      Output::WebSocket.start(output['host'], output['port']) if output
    end

    def self.game_engine(game_engine)
      GameEngine::Socket.start(game_engine['host'], game_engine['port']) if game_engine
    end
  end

  class ConfigurationError < StandardError; end
  class UnsupportedAdapter < StandardError; end
end
