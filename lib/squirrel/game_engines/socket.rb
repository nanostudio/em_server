module Squirrel
  module GameEngine
    module Socket
      def self.start(host, port)
        Logger.info "Initializing Squirrel game engine on #{host}:#{port}"

        EM::start_server(host, port) do |socket|
          def post_init
            Logger.info "Game engine socket available on port #{port}"
            new_connection(socket)
          end

          def unbind
            Logger.info "Game engine connection closed"
          end

          check_queue(socket)
        end

        EM::start_server(host, 843) do |socket|
          Logger.info("Fuck")
          def receive_data
            xml = %q{
<?xml version="1.0"?>
<!DOCTYPE cross-domain-policy SYSTEM "/xml/dtds/cross-domain-policy.dtd">
<cross-domain-policy>
  <site-control permitted-cross-domain-policies="master-only"/>
  <allow-access-from domain="swf.example.com" to-ports="123,456-458"/>
</cross-domain-policy>
            }
            send_data(xml)
          end
        end
      end

      def self.check_queue(connection)
        Logger.info 'Checking queue'
        Input.queue.pop do |data|
          Logger.info "Sending data to socket - #{data}"
          connection.send_data data

          check_queue(connection)
        end
      end

      def self.new_connection(socket)
        Logger.info 'Game engine connected on port 9090'
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