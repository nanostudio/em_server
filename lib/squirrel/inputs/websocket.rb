module Squirrel
  module Input
    module WebSocket
      # @param host [String]
      # @param port [String]
      # @return [NilClass]
      def self.start(host, port)
        Logger.info "Squirrel websocket input available on #{host}:#{port}"

        EM::WebSocket.start(:host => host, :port => port) do |ws|
          ws.onopen do |a|
            Logger.info "WebSocket v#{ws.request["sec-websocket-version"]} input connection established."
            new_connection(ws)
            ws.send('[Squirrel] Connection established')
          end

          ws.onmessage do |data|
            Logger.info "Data received: #{data}"
            new_message ws, data
            ws.send("[Squirrel] Message received from websocket - #{data}")
          end

          ws.onclose do
            ws.send('[Squirrel] Connection closed')
          end

          ws.onerror do |error|
            Logger.error error
          end
        end
      end

      # @param ws [EM::WebSocket]
      # @return [EM::WebSocket]
      def self.new_connection(ws)
        uuid = SecureRandom.uuid
        Input.connections[ws] = uuid
        Input.queue.push({id: uuid, type: 'new_connection', data: {}}.to_json)
        ws.send(uuid)

        ws
      end

      # @param ws [EM::WebSocket]
      # @param data [Hash]
      # @return [Boolean]
      def self.new_message(ws, data)
        Input.queue.push( JSON.parse(data).merge( id: Input.connections[ws] ).to_json)
      end

      # @param ws [EM::WebSocket]
      # @return [NilClass]
      def self.destroy_connection(ws)
        Input.connections.delete ws
      end
    end
  end
end