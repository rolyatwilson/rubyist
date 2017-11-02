# frozen_string_literal: true

module SoChatty
  class Client
    attr_reader :host, :port

    def initialize(options = {})
      @host = options.fetch(:host, Server.default_host)
      @port = options.fetch(:port, Server.default_port)
    end

    def start(options = {})
      example = "example#{options.fetch(:example, 1)}"
      puts "example: #{example}"
      raise "Invalid code example: #{example}" unless self.class.private_method_defined?(example)
      send(example)
    end

    private

    def example1
      s = server
      s.each_line do |line|
        puts line
      end
      s.close
    end

    def example2
      example1
    end

    def example3
      s = server

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

    def example5
      s = server
      listener = listen(s)
      talker = talk(s)
      listener.join
      talker.join
    end

    def listen(server)
      Thread.new(server) do |s|
        loop do
          line = s.gets.chomp
          puts line
        end
      end
    end

    def talk(server)
      Thread.new(server) do |s|
        loop do
          line = $stdin.gets.chomp
          s.puts(line.to_s)
        end
      end
    end

    def server
      TCPSocket.new(host, port)
    end
  end
end
