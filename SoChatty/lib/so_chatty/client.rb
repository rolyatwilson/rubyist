# frozen_string_literal: true

module SoChatty
  class Client
    attr_reader :host, :port

    def initialize(options = {})
      @host = options.fetch(:host, Server.default_host)
      @port = options.fetch(:port, Server.default_port)

      puts "client host: #{host}"
      puts "client port: #{port}"
    end
  end
end
