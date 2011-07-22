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
  end
end