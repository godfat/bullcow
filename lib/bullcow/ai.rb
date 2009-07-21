# encoding: utf-8

module BullCow
  class AI
    attr_reader :set, :size, :ans

    def initialize opts = {}
      @set  = opts[:set]  || ('0'..'9').to_a
      @size = opts[:size] || 4
      @ans  = []
    end

    def guess
      if ans.empty?
        set.permutation(size).map(&:join)
      else
        ans.last
      end.sample
    end

    def process row, a, b
      candidates = expand_candidates(row.scan(/./), a, b)
      if ans.empty?
        answers_generate(candidates)
      else
        answers_filter(c2regexp(candidates))
      end.last.sample
    end

    def session_guess
      @session_guess ||= guess
    end

    def session_process a, b
      raise("Please call #{self.class.name}#session_guess first") unless
        @session_guess

      @session_guess = process(session_guess, a, b)
    end

    private
    def expand_candidates row, a, b
      select_match_a(row, a, expand_all(row, a + b))
    end

    def expand_all row, n
      row.combination(n).map{ |candidate|
        expand_placeholder(row, candidate).permutation(row.size).to_a.uniq
      }.flatten(1)
    end

    def expand_placeholder row, candidate
      candidate + [row - candidate] * (row.size - candidate.size)
    end

    def select_match_a row, a, candidates
      candidates.select{ |c| count_a(row, c) == a }
    end

    def count_a row, candidate
      row.zip(candidate).count{ |x,y| x == y }
    end

    def answers_generate candidates
      @ans << candidates.map{ |c|
        h = c.group_by{ |digit| digit.kind_of?(Array) }
        (set - h[true][0] - h[false]).permutation(h[true].size).map{ |b|
          c.map{ |digit| digit.kind_of?(Array) ? b.shift : digit }.join
        }
      }.flatten
    end

    def answers_filter regexp
      @ans << @ans.last.select{ |ans| regexp.find{ |r| ans =~ r } }
    end

    def c2regexp candidates
      candidates.map{ |c| Regexp.new("^#{c2regexp_str(c)}$") }
    end

    def c2regexp_str c
      c.map{ |digit| digit.kind_of?(Array) ? "[^#{digit.join}]" : digit }.join
    end
  end # of AI
end # of BullCow
