module Squirrel
  module GameEngine
    module Socket
      def self.start(host, port)
        Logger.info "Squirrel game engine available on #{host}:#{port}"

        EM::start_server(host, port) do |socket|
          #binding.pry
          #def post_init
            new_connection(socket)
          #end

          def unbind
            Logger.info "Game engine connection closed"
          end

          def receive_data data
            destroy_connection(socket)
            binding.pry
          end

          check_queue
        end

        # TODO esté código é especifico da aplicação. Tirar daqui!
        # This starts a server to serve the Flash policy xml.
        EM::start_server(host, 843) do |socket|
          def receive_data
            Logger.info("Sending flash domain policy.")
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

      def self.check_queue
        Input.queue.pop do |data|
          Logger.info "Sending data to socket - #{data}"
          GameEngine.connections.keys.each {|c| c.send_data data }
          check_queue
        end
        Logger.info 'Waiting for input...'
      end

      def self.new_connection(socket)
        Logger.info 'Game engine connected on port 9090'
        uuid = SecureRandom.uuid
        GameEngine.connections[socket] = uuid
        #socket.send_data({:uid => uuid}.to_json)
        socket
      end

      def self.destroy_connection(ws)
        GameEngine.connections.delete ws
        ws.send('ack')
      end
    end
  end
end