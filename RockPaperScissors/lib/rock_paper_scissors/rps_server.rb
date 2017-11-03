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
      start2
    end

    def start
      s = TCPServer.new(port)

      queue = []
      game_threads = []

      # start a thread to handling incoming connections
      lobby = Thread.new do
        while (conn = s.accept)
          Thread.new(conn) do |c|
            puts "server: connection accepted"

            # push connections into a queue
            name = welcome(c)
            queue << { conn: c, name: name }
          end
        end
      end

      # on another thread, poll the queue and start games
      matchmaking = Thread.new do
        loop do
          sleep 1 # poll waiting
          next unless queue.length >= 2

          # start a game
          game_threads << Thread.new do
            player1 = queue.shift
            player2 = queue.shift
            play(player1, player2)
          end
        end
      end

      # cleanup old threads...

      # block the main thread so we don't kill all the things
      lobby.join
      matchmaking.join
    end

    def play(player1, player2)
      threads = []
      2.times do |i|
        player   = i.zero? ? player1 : player2
        opponent = i.zero? ? player2 : player1

        puts "server: i: #{i}"
        puts "server: thread loop for player: #{player}, opponent: #{opponent}"

        threads << Thread.new(player, opponent) do |p, o|
          p[:conn].puts("Your opponent is #{o[:name]}. Your move? (rock, paper, scissors) ")
          move = p[:conn].gets.chomp
          puts("server: received move #{move} from #{p[:name]}")
          p[:move] = move
          puts "server: next thing to do is send final waiting..."
          p[:conn].puts("Waiting for #{o[:name]}...")
          puts "server: sent final waiting..."
        end
      end

      # the battle begins, after both players made a move
      a, b = threads
      a.join
      b.join

      puts "server: players made their moves"
      puts "server: p1.move: #{player1[:move]}"
      puts "server: p2.move: #{player2[:move]}"

      puts "server: let's build the game objects"
      rps1 = RPS.new(player1[:move])
      rps2 = RPS.new(player2[:move])

      puts "server: who won?"
      winner = rps1.play(rps2)
      if rps1 == winner
        puts "server: p1 is the winner"
        player1[:conn].puts("You win! You beat #{player2[:name]} with #{rps1.move} vs #{rps2.move}")
        player2[:conn].puts("You lost! #{player1[:name]} destroyed you with #{rps1.move} vs #{rps2.move}")
      elsif rps2 == winner
        puts "server: p2 is the winner"
        player2[:conn].puts("You win! You beat #{player1[:name]} with #{rps2.move} vs #{rps1.move}")
        player1[:conn].puts("You lost! #{player2[:name]} destroyed you with with #{rps2.move} vs #{rps1.move}")
      else
        puts "server: it is a tie"
        player1[:conn].puts("You tied with #{player2[:name]}! #{rps1.move} vs #{rps2.move}")
        player2[:conn].puts("You tied with #{player1[:name]}! #{rps2.move} vs #{rps1.move}")
      end
    end


    def start3
      s = TCPServer.new(port)
      while true
        threads = []
        2.times do |n|
          conn = s.accept
          threads << Thread.new(conn) do |c|
            Thread.current[:number] = n + 1
            Thread.current[:conn] = c
            Thread.current[:name] = welcome(c)
            # c.puts "Welcome, #{Thread.current[:name]}! Waiting for opponent..."
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
          a[:conn].puts("You win! You beat #{b[:name]} with #{rps1.move} vs #{rps2.move}")
          b[:conn].puts("You lost! #{a[:name]} destroyed you with #{rps1.move} vs #{rps2.move}")
        elsif rps2 == winner
          b[:conn].puts("You win! You beat #{a[:name]} with #{rps2.move} vs #{rps1.move}")
          a[:conn].puts("You lost! #{b[:name]} destroyed you with with #{rps2.move} vs #{rps1.move}")
        else
          a[:conn].puts("You tied with #{b[:name]}! #{rps1.move} vs #{rps2.move}")
          b[:conn].puts("You tied with #{a[:name]}! #{rps2.move} vs #{rps1.move}")
        end
      end
    end

    def start2
      s = TCPServer.new(port)
      threads = []

      2.times do |n|
        conn = s.accept
        threads << Thread.new(conn) do |c|
          Thread.current[:number] = n + 1
          Thread.current[:conn] = c
          Thread.current[:player] = welcome(c)
          # c.puts "Welcome, #{Thread.current[:player]}! Waiting for opponent..."
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
      name = connection.readline.chomp
      connection.puts 'Waiting for opponent...'
      name.empty? ? 'Anonymous Coward' : name
    end
  end
end
