module Squirrel
  module Input
  	def self.config
  		Configuration.new
  	end
  	
	  class Configuration
      # TODO gerar metodos para todos os inputs disponiveis
	  	def websocket(options)
	  		Input::WebSocket.start(options)
	  	end
	  end
  end
end