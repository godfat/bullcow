
module BullCow
  class FilterLog < Filter
    attr_reader :out
    def initialize out = $stdout
      @out = out
    end

    def guess str
      s = super(str)
      out.puts("Guessed: #{s}")
      s
    end

    def ab a, b
      c, d = super(a, b)
      out.puts("Answers: #{c}A#{d}B")
      [c, d]
    end

    def win str
      s = super(str)
      out.puts("You Win: #{s}")
      s
    end
  end
end
