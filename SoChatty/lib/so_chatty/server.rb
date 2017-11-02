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

    attr_reader :host, :port, :stop

    def initialize(options = {})
      @host = Server.default_host
      @port = options.fetch(:port, Server.default_port)
    end

    def start(options = {})
      example = options.fetch(:example, :example1)
      raise "Invalid code example: #{example}" unless self.class.private_method_defined?(example)
      send(example)
    rescue SystemExit, Interrupt
      puts 'Safely shutting down...'
      @stop = true
    end

    private

    def example1
      puts 'starting example1...'
      s = TCPServer.new(port)
      conn = s.accept
      send_date_and_close(conn)
      s.close
    end

    def example2
      puts 'starting example2...'
      s = TCPServer.new(port)
      until stop
        conn = s.accept
        send_date_and_close(conn)
      end
      s.close
    end

    def example3
      puts 'starting example3...'
      s = TCPServer.new(port)
      until stop
        conn = s.accept
        name = user_name(conn)
        send_date_and_close(conn, name: name)
      end
      s.close
    end

    def example4
      puts 'starting example4...'
      s = TCPServer.new(port)
      while !stop && (conn = s.accept)
        puts 'server: connection accepted'
        Thread.new(conn) do |c|
          name = user_name(c)
          send_date_and_close(c, name: name)
        end
      end
      s.close
    end

    def user_name(connection)
      connection.puts 'Hi. What is your name? '
      connection.gets.chomp
    end

    def send_date_and_close(connection, options = {})
      name = options.fetch(:name, '')
      connection.puts "Hi#{name.empty? ? '' : ", #{name}"}. Here's the date."
      connection.puts `date`
      connection.close
    end
  end
end
