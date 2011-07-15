module Squirrel
  module GameEngine
  	def self.config
  		yield Configuration.new
  	end
  	
	  class Configuration
	  	def socket(options)
	  		# Input::WebSocket.start(options)
	  	end
	  end
  end
end