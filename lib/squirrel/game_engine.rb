module Squirrel
  module GameEngine
  	def self.config
  		yield Configuration.new
  	end
  	
	  class Configuration
	  	def socket(options)
	  		# Input::Websocket.start(options)
	  	end
	  end
  end
end