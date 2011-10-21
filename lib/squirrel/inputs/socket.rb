module Squirrel
  module Input
    module Socket
      class Handler < EventMachine::Connection
        def post_init
          Logger.info "Input socket connection opened"
          #new_connection(socket)
        end

        def unbind
          Logger.info "Input socket connection closed"
        end

        def receive_data data
          Logger.info "Data received: #{data}"
          Socket.new_message data
        end
      end

      # @param port [String]
      # @param host [String]
      def self.start(host, port)
        Logger.info "Squirrel socket input available on #{host}:#{port}"
        EventMachine::start_server host, port, Handler
      end

      # @param ws [EM::WebSocket]
      # @param data [Hash]
      # @return [Boolean]
      def self.new_message(data)
        Logger.info ("Message Received from socket input (port 8080): #{data}")
        Input.queue.push(JSON.parse(data).to_json)
      end

      # @param socket [EM::Socket]
      # @return [EM::Socket]
      #def self.new_connection(socket)
      #  Logger.info 'Input socket connected on port 8080'
      #
      #  uuid                      = SecureRandom.uuid
      #  Input.connections[socket] = uuid
      #  socket
      #end

      # @param socket [EM::Socket]
      # @return [Boolean]
      def self.destroy_connection(socket)
        Input.connections.delete socket
      end
    end
  end
end