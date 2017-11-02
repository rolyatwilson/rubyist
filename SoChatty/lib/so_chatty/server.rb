# frozen_string_literal: true

module SoChatty
  class Server
    class << self
      def default_host
        @default_host = 'localhost'
      end

      def default_port
        @default_port = 8888
      end
    end

    attr_reader :host, :port

    def initialize(options = {})
      @host = options.fetch(:host, default_host)
      @port = options.fetch(:port, default_port)

      puts "server host: #{host}"
      puts "server port: #{port}"
    end
  end
end
