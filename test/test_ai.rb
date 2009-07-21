# encoding: utf-8

require 'minitest/unit'
MiniTest::Unit.autorun

require 'bullcow/ai'

class TestAI < MiniTest::Unit::TestCase
  def test_default_args
    ai = BullCow::AI.new
    assert_equal(4, ai.size)
    assert_equal(('0'..'9').to_a, ai.set)
  end
end
