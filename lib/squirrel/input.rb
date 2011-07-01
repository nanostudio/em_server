module Squirrel
  module Input
  	def self.config
  		yield Configuration.new
  	end
  	
	  class Configuration
	  	def websocket(options)
	  		Input::Websocket.start(options)
	  	end
	  end
  end
end