require 'test/unit'
require './NeonPolygon'

class Broken < Test::Unit::TestCase

  def test_line_initialize
    from = Point.new(0,1)
    to = Point.new(5,5)
    l1 = Line.new(from, to)
    assert_same(from, l1.from)
    assert_same(to, l1.to)
  end

  def test_line_intersect_line_middle
    # Integer points
    l1 = Line.new(Point.new(0,1), Point.new(5,5))
    l2 = Line.new(Point.new(2,5), Point.new(2,0))
    assert_equal(Point.new(2,2), l1.intersect_line(l2))
    # Real points
    l1 = Line.new(Point.new(0.0,1.0), Point.new(5.0,5.0))
    l2 = Line.new(Point.new(2.0,5.0), Point.new(2.0,0.0))
    assert_equal(Point.new(2.0,2.6), l1.intersect_line(l2))
  end

  def test_line_intersect_line_vertex
    origin = Point.new(0,0)
    l1 = Line.new(origin, Point.new(0,5))
    l2 = Line.new(origin, Point.new(5,0))
    assert_equal(origin, l1.intersect_line(l2))
    # Intersect other lines beyond segment limits
    l2 = Line.new(Point.new(0,1), Point.new(0,2))
    l3 = Line.new(Point.new(1,0), Point.new(2,0))
    assert_equal(origin, l2.intersect_line(l3))
  end

  def test_line_intersect_line_coincident
    l1 = Line.new(Point.new(80,50), Point.new(50,50))
    l2 = Line.new(Point.new(80,50), Point.new(60,50))
    assert_equal(Point.new(80,50), l1.intersect_line(l2))
  end

  def test_line_distance_to_point
    origin = Point.new(0,0)
    x1y1 = Point.new(1,1)
    l1 = Line.new(origin, x1y1)
    assert_equal(0, l1.distance_to_point(origin))
    assert_equal(0, l1.distance_to_point(x1y1))
    assert_equal(0, l1.distance_to_point(Point.new(0.5,0.5)))
    assert_in_epsilon(Math.sqrt(2) / 2, l1.distance_to_point(Point.new(0.5,-0.5)))
  end
end