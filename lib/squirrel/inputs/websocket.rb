module Squirrel
  module Input
    module WebSocket
      def self.start(host, port)
        EM::WebSocket.start(:host => host, :port => port) do |ws|
          ws.onopen do
            new_connection(ws)
          end

          ws.onmessage do |data|
            new_message ws, data
          end

          ws.onclose do
          end

          # ws.onerror
        end
      end

      def self.new_connection(ws)
        uuid = SecureRandom.uuid
        Input.connections[ws] = uuid 
        Input.queue.push :id => uuid, :message => 'connected'
        ws.send(uuid)

        ws
      end

      def self.new_message(ws, data)
        Input.queue.push :id => Input.connections[ws], :message => data
        ws.send('ack')
      end

      def self.destroy_connection(ws)
        Input.connections.delete ws
        ws.send('ack')
      end
    end
  end
end