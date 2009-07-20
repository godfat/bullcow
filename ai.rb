#!/usr/bin/env ruby
# encoding: utf-8

module NumGame
  class AI
    attr_reader :ans, :set, :size

    def initialize opts = {}
      @ans  = []
      @set  = opts[:set]  || ('0'..'9').to_a
      @size = opts[:size] || 4
    end

    def guess
      if ans.empty?
        set.permutation(size).map(&:join)
      else
        ans.last
      end.sample
    end

    def process row, a, b
      candidates = generate_candidates(row.scan(/./), a, b)
      if ans.empty?
        answers_generate(candidates)
      else
        answers_filter(candidates_to_regexp(candidates))
      end
      guess
    end

    def session_guess
      @session_guess ||= guess
    end

    def session_process a, b
      return nil unless @session_guess
      process(@session_guess, a, b)
      @session_guess = guess
    end

    private
    def answers_generate candidates
      @ans << candidates.map{ |c|
        v = c.group_by{ |a| a.kind_of?(Array) }
        (set - v[true][0] - v[false]).permutation(v[true].size).map{ |b|
          c.map{ |i|
            if i.kind_of?(Array)
              b.shift
            else
              i
            end
          }.join
        }
      }.flatten
    end

    def answers_filter regexp
      @ans << @ans.last.select{ |ans|
        regexp.find{ |r| ans =~ r }
      }
    end

    def candidates_to_regexp candidates
      candidates.map{ |candidate|
        Regexp.new("^#{regexp_string(candidate)}$")
      }
    end

    def regexp_string candidate
      candidate.map{ |c| c.kind_of?(Array) ? "[^#{c.join}]" : c }.join
    end

    def generate_candidates row, a, b
      filter_impo(row, a, expand_all(row, a + b))
    end

    def expand_all row, n
      row.combination(n).map{ |candidate|
        insert_regexp(row, candidate).permutation(row.size).to_a.uniq
      }.flatten(1)
    end

    def insert_regexp row, c#andidate
      c + [(row - c)] * (row.size - c.size)
    end

    def filter_impo row, a, candidates
      candidates.select{ |c|
        count_a(row, c) == a
      }
    end

    def count_a row, candidate
      row.zip(candidate).count{ |x,y| x == y }
    end
  end # of AI
end # of NumGame
