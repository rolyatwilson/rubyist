# frozen_string_literal: true

module RockPaperScissors
  class RPS
    include Comparable

    class << self
      def wins
        @wins ||= [%w[rock scissors],
                   %w[scissors paper],
                   %w[paper rock]]
      end
    end

    attr_reader :move

    def initialize(move)
      @move = move.to_s
    end

    def <=>(other)
      if move == other.move
        0
      elsif RPS.wins.include?([move, other.move])
        1  # this wins
      elsif RPS.wins.include?([other.move, move])
        -1 # this loses
      else
        raise ArgumentError, 'What did _you_ do?!'
      end
    end

    def play(other)
      if self > other
        self
      elsif other > self
        other
      else
        false
      end
    end
  end
end
