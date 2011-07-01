module Squirrel
  module Input
  	def self.config
  		yield Configuration.new
  	end
  	
	  class Configuration
      # TODO gerar metodos para todos os inputs disponiveis
	  	def websocket(options)
	  		Input::Websocket.start(options)
	  	end
	  end
  end
end