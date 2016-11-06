require 'test/unit'
require './NeonPolygon'

class Pointy < Test::Unit::TestCase

  def test_point_initialize
    point = Point.new(10,50)
    assert_in_epsilon(10.0, point.x)
    assert_in_epsilon(50.0, point.y)
  end

  def test_point_equality
    assert_equal(true, Point.new(5,5) == Point.new(5.0,5.0))
    assert_equal(true, Point.new(0.1 + 0.2,2) == Point.new(0.3,2.000000000000000000004))
    assert_equal(false, Point.new(5,6) == Point.new(6,5))
    assert_equal(false, Point.new(5.1,5) == Point.new(5,5))
  end

  def test_point_distance
    a = Point.new(0,0)
    b = Point.new(1,1)
    sqrt2 = Math.sqrt(2)
    assert_in_epsilon(sqrt2, a.distance(b))
    assert_in_epsilon(sqrt2, b.distance(a))
  end

  def test_point_to_svg
    # Integer point
    assert_equal("<circle cx=\"2\" cy=\"3\" r=\"0.5\" style=\"fill:none;stroke:black;stroke-width:0.5\" title=\"Point 2,3\"/>\n", Point.new(2,3).to_svg)
    # Real point
    assert_equal("<circle cx=\"2.0\" cy=\"3.0\" r=\"0.5\" style=\"fill:none;stroke:black;stroke-width:0.5\" title=\"Point 2.0,3.0\"/>\n", Point.new(2.0,3.0).to_svg)
  end
end