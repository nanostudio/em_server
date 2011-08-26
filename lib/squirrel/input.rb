module Squirrel
  module Input
    @@queue = EM::Queue.new
    @@connections = {}

    def self.queue
      @@queue
    end

    def self.connections
      @@connections
    end

    def self.start_strategy(input)
      if input && input['type']
        strategy = input['type'].classify

        if Input.has_strategy? strategy
          Input.module_eval(strategy).start input['host'], input['port']
        else
          raise UnsupportedAdapter
        end
      else
        raise ConfigurationError, 'At least one input is needed.'
      end
    end

    def self.has_strategy? strategy
      constants.include? strategy.to_sym
    end
  end
end