# frozen_string_literal: true

module SoChatty
  class Client
    attr_reader :host, :port

    def initialize(options = {})
      @host = options.fetch(:host, Server.default_host)
      @port = options.fetch(:port, Server.default_port)
    end

    def start(options = {})
      example = options.fetch(:example, :example1)
      puts "example: #{example}"
      raise "Invalid code example: #{example}" unless self.class.private_method_defined?(example)
      send(example)
    end

    private

    def example1
      s = TCPSocket.new(host, port)
      s.each_line do |line|
        puts line
      end
      s.close
    end

    def example2
      example1
    end

    def example3
      s = TCPSocket.new(host, port)

      # server sends exactly 1 welcome message and asks for the user's name... hack
      s.each_line do |line|
        puts line
        break
      end
      name = $stdin.gets.chomp

      s.puts name
      s.each_line do |line|
        puts line
      end
      s.close
    end

    def example4
      example3
    end
  end
end
