# encoding: utf-8

module BullCow
  class Game
    attr_reader :set, :size

    def initialize opts = {}
      @set  = opts[:set]  || ('0'..'9').to_a
      @size = opts[:size] || 4
    end

    def create_ai
      AI.new(set: set, size: size)
    end
  end # of Game
end # of BullCow
