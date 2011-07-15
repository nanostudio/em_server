module Squirrel
  module Server
    def self.start
      EM.run do
        yml = YAML.load_file Squirrel::Server.root + '/config/squirrel.yml'

        config.input yml.fetch('input', nil)
        config.output yml.fetch('output', nil)
        config.game_engine yml.fetch('game_engine', nil)
      end
    end

    def self.config
      Configuration
    end

    def self.root
      @root ||= File.expand_path(File.dirname(__FILE__) + '/../..')
    end
  end

  class Configuration
    def self.input(input)
      if input && input['type']
        klass = input['type'].classify

        if Input.constants.include? klass.to_sym
          Input.module_eval(klass).start input['host'], input['port']
        else
          raise UnsupportedAdapter
        end
      else
        raise ConfigurationError, 'At least one input is needed.'
      end
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
