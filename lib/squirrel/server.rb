module Squirrel
  Logger = ::Logger.new(STDOUT)

  module Server
    def self.start
      EM.run do
        yml = YAML.load_file Squirrel::Server.root + '/config/squirrel.yml'

        Input.start_strategy(yml.fetch('input', nil))
        GameEngine.start_strategy(yml.fetch('game_engine', nil))

        Server.config do |config|
          config.output       yml.fetch('output', nil)
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
  end

  class ConfigurationError < StandardError; end
  class UnsupportedAdapter < StandardError; end
end
