module Squirrel
  module Server
    def self.start
      EM.run do
        yml = YAML.load_file Squirrel::Server.root + '/config/squirrel.yml'
        input, output, game_engine = yml[:input], yml[:output], yml[:game_engine]

        config.input input['type'], input['host'], input['port'] if input
        config.output output['type'], output['host'], output['port'] if output
        config.game_engine game_engine['type'], game_engine['host'], game_engine['port'] if game_engine
      end
    end

    def self.config
      Configuration.new
    end

    def self.root
      @root ||= File.expand_path(File.dirname(__FILE__) + '/../..')
    end
  end

  class Configuration
    def input(type, options)
      Input::Websocket.start(options)
    end
  end
end

# Squirrel::Input.config do |config|
#   config.websocket :host => '0.0.0.0', :port => 8080
# end

# Squirrel::GameEngine.config do |config|
#   config.socket :host => '0.0.0.0', :port => 8080
# end

# Squirrel::IO.config do |config|
#   config.websocket :host => '0.0.0.0', :port => 8080
# end

# Squirel::Output.config do |config|
#   config.websocket :host => '0.0.0.0', :port => 8080
# end