module Squirrel
  module Input
    module Websocket
      def self.start(options)
        EM::WebSocket.start(options) do |ws|
          ws.onopen do
            puts "Client connected."
          #   # player = Player.new(ws)
          #   # Player.all.each { |p| p.ws.send({:action => 'new_player', :params => {:uid => player.uid, :name => player.name}}.to_json) }
          end

          ws.onmessage do |data|
            puts "Message received: '#{JSON.parse(data)}'."
          #   data = JSON.parse(data)
          #   # player = Player.find_by_uid(data['state']['uid'])
          #   # player.top = data['state']['top']
            # player.left = data['state']['left']

          #   state = []
          #   # Player.all.each do |p|
          #   #   state << {
          #   #   :uid => p.uid,
          #   #   :name => p.name,
          #   #   :top => p.top,
          #   #   :left => p.left
          #   # }

          #   # Player.all.each { |p| p.ws.send( { :action => 'send_state', :params => state }.to_json )}
          end

          ws.onclose do
          #   current = []
          #   # Player.all.delete_if {|p| current << p if p.ws == ws}
          #   # Player.all.each { |p| p.ws.send({:action => 'player_exited', :params => {:uid => current.first.uid}}.to_json) }
            puts "Client disconnected."
          end

          # ws.onerror { |e| puts "err #{e.message}\n#{caller.join("\n")}" }
        end
      end
    end
  end
end