require 'minitest/autorun'

require_relative 'calculator'

class TestCalculator < Minitest::Test
  def test_expressions
    assert_equal 3, Expression.new('1 + 2').evaluate
    assert_equal 7, Expression.new('1 + 2 * 3').evaluate
    assert_equal 9, Expression.new('(1 + 2) * 3').evaluate
    assert_equal 9, Expression.new('(  1  +   2)*3').evaluate
  end

  def test_invalid_expressions
    assert_raises RuntimeError do
       Expression.new('( 1 + 2')
    end
    assert_raises RuntimeError do
      Expression.new('( 1 + 2 ) )')
    end
    assert_raises RuntimeError do
      Expression.new('( 1 + 2  * ) )')
    end
  end
end
