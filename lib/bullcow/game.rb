# encoding: utf-8

module BullCow
  class Game
    attr_reader :set, :size, :player, :ans
    attr_accessor :filter

    def initialize opts = {}
      @set    = opts[:set]    || ('0'..'9').to_a
      @size   = opts[:size]   || 4
      @filter = opts[:filter] || FilterLog.new
    end

    def create_ai
      AI.new(set: set, size: size)
    end

    def start
      raise 'Please setup player first' unless player

      @ans = set.shuffle.take(size)
      start_rec(player.guess)
    end

    def start_ai
      @player = create_ai
      start
    end

    def process str
      row = str.scan(/./)
      a = row.zip(ans).count{ |x, y| x == y }
      b = row.count{ |x| ans.member?(x) } - a

      [a, b]
    end

    private
    def start_rec str
      a, b = filter.ab(*process(filter.guess(str)))
      if a == size
        filter.win(str)
      else
        start_rec(player.process(str, a, b))
      end
    end
  end # of Game
end # of BullCow
