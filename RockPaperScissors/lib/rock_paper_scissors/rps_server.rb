# frozen_string_literal: true

module RockPaperScissors
  class RPSServer
    include Logging

    class << self
      def default_host
        @default_host ||= 'localhost'
      end

      def default_port
        @default_port ||= 8888
      end
    end

    attr_reader :host, :port, :queue, :lock

    def initialize(options = {})
      @host = RPSServer.default_host
      @port = options.fetch(:port, RPSServer.default_port)

      # queue and lock used only in example3
      @queue = []
      @lock = Mutex.new

      start(options)
    end

    def start(options)
      example = "example#{options.fetch(:example, 1)}"
      raise "Invalid code example: #{example}" unless self.class.private_method_defined?(example)
      logger.info("Server: starting #{example}")
      send(example)
    end

    private

    # server allows 2 people to play 1 game, and then it shuts down, because "why not?"
    # notice that saves player data directly to thread keys
    # who wants to play?
    def example1
      s = TCPServer.new(port)
      threads = []

      # spin up a thread for each connection to keep the server from blocking on each user's input
      2.times do
        conn = s.accept
        logger.info('Server: connection accepted')
        threads << Thread.new(conn) do |c|
          Thread.current[:conn] = c
          Thread.current[:name] = welcome(c)
          c.puts 'Your move? (rock, paper, scissors)'
          Thread.current[:move] = c.gets.chomp
          c.puts 'Waiting for opponent...'
        end
      end

      a, b = threads
      a.join
      b.join

      # compare each player's move and broadcast a winner
      rps1 = RPS.new(a[:move])
      rps2 = RPS.new(b[:move])
      winner = rps1.play(rps2)
      unless winner
        logger.info("server: #{a[:name]} tied with #{b[:name]}: #{rps1.move} vs #{rps2.move}")
        a[:conn].puts("You tied with #{b[:name]}! #{rps1.move} vs #{rps2.move}")
        b[:conn].puts("You tied with #{a[:name]}! #{rps2.move} vs #{rps1.move}")
      end
      if rps1 == winner
        logger.info("server: #{a[:name]} beat #{b[:name]}: #{rps1.move} vs #{rps2.move}")
        a[:conn].puts("You win! You beat #{b[:name]} with #{rps1.move} vs #{rps2.move}")
        b[:conn].puts("You lost! #{a[:name]} destroyed you with #{rps1.move} vs #{rps2.move}")
      elsif rps2 == winner
        logger.info("server: #{b[:name]} beat #{a[:name]}: #{rps2.move} vs #{rps1.move}")
        b[:conn].puts("You win! You beat #{a[:name]} with #{rps2.move} vs #{rps1.move}")
        a[:conn].puts("You lost! #{b[:name]} destroyed you with with #{rps2.move} vs #{rps1.move}")
      end
    end

    # server does not shutdown after a game is played
    # server only allows 2 connections at a time, so people gonna wait
    # who wants to play? who wants to wait?
    def example2
      s = TCPServer.new(port)

      # that's right, copy/pasta wrapped in an infinite loop
      loop do
        # spin up a thread for each connection to keep the server from blocking on each user's input
        threads = []
        2.times do
          conn = s.accept
          logger.info('Server: connection accepted')
          threads << Thread.new(conn) do |c|
            Thread.current[:conn] = c
            Thread.current[:name] = welcome(c)
            c.puts 'Your move? (rock, paper, scissors)'
            Thread.current[:move] = c.gets.chomp
            c.puts 'Waiting for opponent...'
          end
        end
        a, b = threads
        a.join
        b.join

        # compare each player's move and broadcast a winner
        rps1 = RPS.new(a[:move])
        rps2 = RPS.new(b[:move])
        winner = rps1.play(rps2)
        unless winner
          logger.info("Server: #{a[:name]} tied with #{b[:name]}: #{rps1.move} vs #{rps2.move}")
          a[:conn].puts("You tied with #{b[:name]}! #{rps1.move} vs #{rps2.move}")
          b[:conn].puts("You tied with #{a[:name]}! #{rps2.move} vs #{rps1.move}")
        end
        if rps1 == winner
          logger.info("Server: #{a[:name]} beat #{b[:name]}: #{rps1.move} vs #{rps2.move}")
          a[:conn].puts("You win! You beat #{b[:name]} with #{rps1.move} vs #{rps2.move}")
          b[:conn].puts("You lost! #{a[:name]} destroyed you with #{rps1.move} vs #{rps2.move}")
        elsif rps2 == winner
          logger.info("Server: #{b[:name]} beat #{a[:name]}: #{rps2.move} vs #{rps1.move}")
          b[:conn].puts("You win! You beat #{a[:name]} with #{rps2.move} vs #{rps1.move}")
          a[:conn].puts("You lost! #{b[:name]} destroyed you with with #{rps2.move} vs #{rps1.move}")
        end
      end
    end

    # server allows multiple connection to queue
    # server allows multiple games to run concurrently
    # server only shuts down when it receives an interrupt (ctrl+c) or if i messed up and it crashes
    # who all wants to play?
    def example3
      s = TCPServer.new(port)
      l = lobby(s)
      m = matchmaking

      # block the main thread so we don't kill all the things
      l.join
      m.join
    end

    # queue up connections
    def lobby(server)
      Thread.new do
        while (conn = server.accept)
          Thread.new(conn) do |c|
            logger.info('Server: connection accepted')

            # push connections into a queue
            name = welcome(c)
            lock.synchronize do
              queue << { conn: c, name: name }
            end
          end
        end
      end
    end

    # pair up players and start games
    def matchmaking
      Thread.new do
        loop do
          sleep 0.3 # poll waiting
          next unless queue.length >= 2

          # start a game
          Thread.new do
            player1 = player2 = nil
            lock.synchronize do
              player1 = queue.shift
              player2 = queue.shift
            end
            play(player1, player2)
          end
        end
      end
    end

    # this is mostly copy/pasta with some hackery to handle each
    # connection on individual threads.
    # i ditched thread keys here, and should have gone a step
    # further and just created a player class.
    def play(player1, player2)
      threads = []
      2.times do |i|
        player   = i.zero? ? player1 : player2
        opponent = i.zero? ? player2 : player1

        threads << Thread.new(player, opponent) do |p, o|
          p[:conn].puts("Your opponent is #{o[:name]}. Your move? (rock, paper, scissors) ")
          p[:move] = p[:conn].gets.chomp
          p[:conn].puts("Waiting for #{o[:name]}...")
        end
      end

      # the battle begins, after both players made a move
      a, b = threads
      a.join
      b.join

      rps1 = RPS.new(player1[:move])
      rps2 = RPS.new(player2[:move])

      winner = rps1.play(rps2)
      unless winner
        logger.info("Server: #{player1[:name]} tied with #{player2[:name]}: #{rps1.move} vs #{rps2.move}")
        player1[:conn].puts("You tied with #{player2[:name]}! #{rps1.move} vs #{rps2.move}")
        player2[:conn].puts("You tied with #{player1[:name]}! #{rps2.move} vs #{rps1.move}")
      end
      if rps1 == winner
        logger.info("Server: #{player1[:name]} beat #{player2[:name]}: #{rps1.move} vs #{rps2.move}")
        player1[:conn].puts("You win! You beat #{player2[:name]} with #{rps1.move} vs #{rps2.move}")
        player2[:conn].puts("You lost! #{player1[:name]} destroyed you with #{rps1.move} vs #{rps2.move}")
      elsif rps2 == winner
        logger.info("Server: #{player2[:name]} beat #{player1[:name]}: #{rps2.move} vs #{rps1.move}")
        player2[:conn].puts("You win! You beat #{player1[:name]} with #{rps2.move} vs #{rps1.move}")
        player1[:conn].puts("You lost! #{player2[:name]} destroyed you with with #{rps2.move} vs #{rps1.move}")
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
