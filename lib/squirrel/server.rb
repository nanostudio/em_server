module Squirrel
  module Server
    def self.start
      EM.run do
        Squirrel::Input.config do |config|
          config.websocket :host => '0.0.0.0', :port => 8080
        end
        
        GameEngine.config do |config|
          config.socket :host => '0.0.0.0', :port => 8080
        end
        
        puts "Server is up!"
      end
    end
  end
end