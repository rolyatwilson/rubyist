# frozen_string_literal: true

module RockPaperScissors
  class RPSServer
    class << self
      def default_host
        @default_host ||= 'localhost'
      end

      def default_port
        @default_port ||= 8888
      end
    end

    attr_reader :host, :port

    def initialize(options = {})
      @host = RPSServer.default_host
      @port = options.fetch(:port, RPSServer.default_port)
      start
    end

    def start
      s = TCPServer.new(port)
      threads = []

      2.times do |n|
        conn = s.accept
        threads << Thread.new(conn) do |c|
          Thread.current[:number] = n + 1
          Thread.current[:conn] = c
          Thread.current[:player] = welcome(c)
          c.puts "Welcome, #{Thread.current[:player]}! Waiting for opponent..."
          c.puts 'Your move? (rock, paper, scissors)'
          Thread.current[:move] = c.gets.chomp
          c.puts 'Waiting for opponent...'
        end
      end
      a, b = threads
      a.join
      b.join

      rps1 = RPS.new(a[:move])
      rps2 = RPS.new(b[:move])
      winner = rps1.play(rps2)
      if rps1 == winner
        a[:conn].puts("You win! #{rps1.move} vs #{rps2.move}")
        b[:conn].puts("You lose! #{rps2.move} vs #{rps1.move}")
      elsif rps2 == winner
        b[:conn].puts("You win! #{rps2.move} vs #{rps1.move}")
        a[:conn].puts("You lose! #{rps1.move} vs #{rps2.move}")
      else
        a[:conn].puts("It's a tie! #{rps1.move} vs #{rps2.move}")
        b[:conn].puts("It's a tie! #{rps2.move} vs #{rps1.move}")
      end
    end

    def welcome(connection)
      connection.puts 'Hi. What is your name? '
      connection.readline.chomp
    end
  end
end
