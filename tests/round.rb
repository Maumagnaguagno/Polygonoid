require 'test/unit'
require './NeonPolygon'

class Round < Test::Unit::TestCase

  def test_circle_initialize
    circle = Circle.new(1,2,3)
    assert_equal(1, circle.cx)
    assert_equal(2, circle.cy)
    assert_equal(3, circle.radius)
  end

  def test_circle_perimeter
    circle = Circle.new(1,2,3)
    assert_equal(Math::PI * 6, circle.perimeter)
  end

  def test_circle_area
    circle = Circle.new(1,2,3)
    assert_equal(Math::PI * 3 ** 2, circle.area)
  end

  def test_circle_to_svg
    circle = Circle.new(1,2,3)
    assert_equal("<circle cx=\"1\" cy=\"2\" r=\"3\" style=\"fill:gray;stroke:black\" title=\"Circle 1,2 3\"/>\n", circle.to_svg)
  end
end