require 'test/unit'
require './NeonPolygon'

class Scribble < Test::Unit::TestCase

  def test_line_initialize
    from = Point.new(0,1)
    to = Point.new(5,5)
    line = Line.new(from, to)
    assert_equal(from, line.from)
    assert_equal(to, line.to)
    assert_equal(0.8, line.slope)
    assert_equal(1, line.y_intercept)
  end

  def test_line_equality
    a = Point.new(23,89)
    b = Point.new(155,0.8)
    c = Point.new(400,0)
    assert_equal(Line.new(a,b), Line.new(a,b))
    assert_not_equal(Line.new(a,b), Line.new(b,a))
    assert_not_equal(Line.new(a,b), Line.new(a,c))
    assert_not_equal(Line.new(a,b), Line.new(c,b))
  end

  def test_line_perimeter
    from = Point.new(23,89)
    to = Point.new(155,0.8)
    line = Line.new(from, to)
    assert_equal(Math.hypot(23 - 155, 89 - 0.8), line.perimeter)
  end

  def test_line_x_intercept
    from = Point.new(0,1)
    to = Point.new(5,5)
    line = Line.new(from, to)
    assert_equal(-1.25, line.x_intercept)
  end

  def test_line_vertical
    assert_equal(true, Line.new(Point.new(0,0), Point.new(0,1)).vertical?)
    assert_equal(false, Line.new(Point.new(0,0), Point.new(1,0)).vertical?)
    assert_equal(false, Line.new(Point.new(0,0), Point.new(1,1)).vertical?)
    # Weird behavior for same from/to point
    assert_equal(true, Line.new(Point.new(0,0), Point.new(0,0)).vertical?)
  end

  def test_line_horizontal
    assert_equal(false, Line.new(Point.new(0,0), Point.new(0,1)).horizontal?)
    assert_equal(true, Line.new(Point.new(0,0), Point.new(1,0)).horizontal?)
    assert_equal(false, Line.new(Point.new(0,0), Point.new(1,1)).horizontal?)
    # Weird behavior for same from/to point
    assert_equal(true, Line.new(Point.new(0,0), Point.new(0,0)).horizontal?)
  end

  def test_line_parallel_to
    #flunk # TODO
  end

  def test_line_contain_point
    #flunk # TODO
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

  def test_line_intersection_line2
    #flunk # TODO
  end

  def test_line_intersect_line_angle
    #flunk # TODO
  end

  def test_line_to_svg
    # Integer points
    l1 = Line.new(Point.new(1,2), Point.new(3,4))
    assert_equal("<line x1=\"1\" y1=\"2\" x2=\"3\" y2=\"4\" style=\"stroke:black\"/>\n", l1.to_svg)
    # Real points
    l1 = Line.new(Point.new(1.0,2.0), Point.new(3.0,4.0))
    assert_equal("<line x1=\"1.0\" y1=\"2.0\" x2=\"3.0\" y2=\"4.0\" style=\"stroke:black\"/>\n", l1.to_svg)
  end
end