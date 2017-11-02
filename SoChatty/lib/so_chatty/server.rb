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
      example = "example#{options.fetch(:example, 1)}"
      raise "Invalid code example: #{example}" unless self.class.private_method_defined?(example)
      puts "starting #{example}"
      send(example)
    rescue SystemExit, Interrupt
      puts 'Safely shutting down...'
      @stop = true
    end

    private

    def example1
      s = server
      conn = s.accept
      send_date_and_close(conn)
      s.close
    end

    def example2
      s = server
      until stop
        conn = s.accept
        send_date_and_close(conn)
      end
      s.close
    end

    def example3
      s = server
      until stop
        conn = s.accept
        name = welcome(conn)
        send_date_and_close(conn, name: name)
      end
      s.close
    end

    def example4
      s = server
      while !stop && (conn = s.accept)
        Thread.new(conn) do |c|
          name = welcome(c)
          send_date_and_close(c, name: name)
        end
      end
      s.close
    end

    def example5
      s = server
      chatters = []
      while !stop && (conn = s.accept)
        Thread.new(conn) do |c|
          name = welcome(c)
          broadcast("#{name} has joined", chatters)
          chatters << c
          begin
            puts "about to listen for input"
            loop do
              line = c.gets.chomp
              broadcast("#{name}: #{line}", chatters)
            end
          rescue EOFError
            c.close
            chatters.delete(c)
            broadcast("#{name} has left", chatters)
          end
        end
      end
    end

    def welcome(connection)
      connection.puts 'Hi. What is your name? '
      connection.readline.chomp
    end

    def send_date_and_close(connection, options = {})
      name = options.fetch(:name, '')
      connection.puts "Hi#{name.empty? ? '' : ", #{name}"}. Here's the date."
      connection.puts `date`
      connection.close
    end

    def broadcast(message, chatters)
      puts "broadcast called: #{message}"
      chatters.each do |c|
        c.puts message
      end
    end

    def server
      TCPServer.new(port)
    end
  end
end
