# encoding: utf-8

module BullCow
  class Game
    attr_reader :set, :size, :player, :ans

    def initialize opts = {}
      @set  = opts[:set]  || ('0'..'9').to_a
      @size = opts[:size] || 4
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
      a, b = process(str)
      start_rec(player.process(str, a, b)) if a != size
    end
  end # of Game
end # of BullCow
