# frozen_string_literal: true

require_relative 'connection'

module Datadog
  class Statsd
    class UDPConnection < Connection
      DEFAULT_HOST = '127.0.0.1'
      DEFAULT_PORT = 8125

      # StatsD host. Defaults to 127.0.0.1.
      attr_reader :host

      # StatsD port. Defaults to 8125.
      attr_reader :port

      def initialize(host, port, logger, telemetry)
        super(telemetry)
        @host = host || ENV.fetch('DD_AGENT_HOST', DEFAULT_HOST)
        @port = port || ENV.fetch('DD_DOGSTATSD_PORT', DEFAULT_PORT).to_i
        @logger = logger
      end

      private

      def connect
        logger.info("Connecting to UDP socket")
        cpnn = UDPSocket.new.tap do |socket|
          socket.connect(host, port)
        end
        logger.info("Connected to UDP socket")
        conn
      end

      def send_message(message)
        logger.info("Sending message over UDP")
        socket.send(message, 0)
      end
    end
  end
end
