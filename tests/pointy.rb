require 'test/unit'
require './NeonPolygon'

class Pointy < Test::Unit::TestCase

  def test_point_initialize
    point = Point.new(10,50)
    assert_in_epsilon(10.0, point.x)
    assert_in_epsilon(50.0, point.y)
  end

  def test_point_distance
    origin = Point.new(0,0)
    point = Point.new(1,1)
    sqrt2 = Math.sqrt(2)
    assert_in_epsilon(sqrt2, origin.distance(point))
    assert_in_epsilon(sqrt2, point.distance(origin))
  end

  def test_point_equality
    assert_equal(Point.new(5,5), Point.new(5.0,5.0))
  end
end