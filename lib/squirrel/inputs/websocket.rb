module Squirrel
  module Input
    module WebSocket
      def self.start(host, port)
        Logger.info "Initializing Squirrel on #{host}:#{port}"

        EM::WebSocket.start(:host => host, :port => port) do |ws|
          ws.onopen do
            Logger.info "WebSocket connection established: #{ws}"
            new_connection(ws)
            ws.send('ack')
          end

          ws.onmessage do |data|
            Logger.info "Data received: #{data}"
            new_message ws, data
            ws.send('ack')
          end

          ws.onclose do
            ws.send('ack')
          end

          ws.onerror do |error|
            Logger.error error
          end
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