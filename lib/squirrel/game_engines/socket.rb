module Squirrel
  module GameEngine
    module Socket
      def self.start(host, port)
        Logger.info "Initializing Squirrel game engine on #{host}:#{port}"
        
        EM::start_server(host, port) do |socket|
          def post_init
            Logger.info "Game engine connected"
            new_connection(socket)
          end

          def unbind
            Logger.info "Game engine connection closed"
          end

          check_queue(socket)
        end
      end

      def self.check_queue(connection)
        Logger.info 'Checking queue'
        Input.queue.pop do |data|
          Logger.info 'Sending data'
          connection.send_data data

          check_queue(connection)
        end
      end

      def self.new_connection(socket)
binding.pry
        uuid = SecureRandom.uuid
        GameEngine.connections[socket] = uuid 
        send_data(uuid)
        socket
      end

      def self.destroy_connection(ws)
        GameEngine.connections.delete ws
        ws.send('ack')
      end
    end
  end
end