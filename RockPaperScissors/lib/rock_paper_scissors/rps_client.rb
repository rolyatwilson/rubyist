# frozen_string_literal: true

module RockPaperScissors
  class RPSClient
    attr_reader :host, :port

    def initialize(options = {})
      @host = options.fetch(:host, RPSServer.default_host)
      @port = options.fetch(:port, RPSServer.default_port)
      start
    end

    def start
      s = TCPSocket.new(host, port)

      # server asks for player name
      puts s.gets.chomp
      name = $stdin.gets.chomp
      s.puts(name)

      # waiting for opponent AND
      # server asks for move (rock paper scissors)
      line = nil
      2.times do
        line = s.gets.chomp
        puts line
      end

      # make sure the user inputs a valid move
      move = nil
      loop do
        move = $stdin.gets.chomp.downcase
        break if %w[rock paper scissors].include?(move)
        puts line
      end

      # play the move
      s.puts(move)

      # did you win?
      puts s.gets.chomp # waiting for opponent
      puts s.gets.chomp # game results
    end
  end
end
