require_relative 'pointy'
require_relative 'scribble'
require_relative 'chain'
require_relative 'apeirogon'
require_relative 'round'

class Geometer < Test::Unit::TestCase

  def test_approx
    assert_equal(true, 3.approx(3.0001))
    assert_equal(true, 3.0001.approx(3))
    assert_equal(true, 100000.approx(100001))
    assert_equal(true, 100001.approx(100000))
    assert_equal(false, 5.approx(6))
    assert_equal(false, 6.5.approx(5.5))
  end
end