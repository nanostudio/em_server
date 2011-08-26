module Squirrel
  module GameEngine
    @@queue = EM::Queue.new
    @@connections = {}

    def self.queue
      @@queue
    end

    def self.connections
      @@connections
    end

    def self.start_strategy(game_engine)
      if game_engine && game_engine['type']
        strategy = game_engine['type'].classify

        if GameEngine.has_strategy? strategy
          GameEngine.module_eval(strategy).start game_engine['host'], game_engine['port']
        else
          raise UnsupportedAdapter
        end
      else
        raise ConfigurationError, 'At least one game_engine is needed (Please, review your squirrel.yml).'
      end
    end

    def self.has_strategy? strategy
      constants.include? strategy.to_sym
    end
  end
end