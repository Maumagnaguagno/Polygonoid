require 'test/unit'
require './Polygonoid'

class Scribble < Test::Unit::TestCase

  def test_line_initialize
    a = Point.new(0,1)
    b = Point.new(5,5)
    c = Point.new(5,0)
    # Different points
    line = Line.new(a,b)
    assert_same(a, line.from)
    assert_same(b, line.to)
    assert_equal(0.8, line.slope)
    assert_equal(1, line.y_intercept)
    # Same point
    line = Line.new(a,a)
    assert_same(a, line.from)
    assert_same(a, line.to)
    assert_true(line.slope.nan?)
    assert_nil(line.y_intercept)
    # Vertical lines have undefined slope
    line = Line.new(b,c)
    assert_same(b, line.from)
    assert_same(c, line.to)
    assert_equal(-Float::INFINITY, line.slope)
    assert_nil(line.y_intercept)
  end

  def test_line_equality
    a = Point.new(23,89)
    b = Point.new(155,0.8)
    c = Point.new(400,0)
    l = Line.new(a,b)
    assert_equal(l, l)
    assert_equal(l, Line.new(a,b))
    assert_not_equal(Line.new(a,b), Line.new(b,a))
    assert_not_equal(Line.new(a,b), Line.new(a,c))
    assert_not_equal(Line.new(a,b), Line.new(c,b))
  end

  def test_line_perimeter
    line = Line.new(Point.new(23,89), Point.new(155,0.8))
    assert_equal(Math.hypot(23 - 155, 89 - 0.8), line.perimeter)
  end

  def test_line_x_intercept
    l1 = Line.new(Point.new(0,1), Point.new(5,5))
    assert_equal(-1.25, l1.x_intercept)
    l2 = Line.new(Point.new(0,1), Point.new(1,1))
    assert_nil(l2.x_intercept)
    l3 = Line.new(Point.new(0,0), Point.new(0,0))
    assert_nil(l3.x_intercept)
  end

  def test_line_vertical
    a = Point.new(0,0)
    assert_true( Line.new(a, Point.new(0,1)).vertical?)
    assert_false(Line.new(a, Point.new(1,0)).vertical?)
    assert_false(Line.new(a, Point.new(1,1)).vertical?)
    # Weird behavior for same from/to point
    assert_true(Line.new(a,a).vertical?)
  end

  def test_line_horizontal
    a = Point.new(0,0)
    assert_false(Line.new(a, Point.new(0,1)).horizontal?)
    assert_true( Line.new(a, Point.new(1,0)).horizontal?)
    assert_false(Line.new(a, Point.new(1,1)).horizontal?)
    # Weird behavior for same from/to point
    assert_true(Line.new(a,a).horizontal?)
  end

  def test_line_parallel_to
    a = Point.new(1,1)
    b = Point.new(1,0)
    c = Point.new(5,0)
    d = Point.new(5,5)
    assert_true( Line.new(a,b).parallel_to?(Line.new(a,b)))
    assert_false(Line.new(a,a).parallel_to?(Line.new(a,a)))
    assert_true( Line.new(a,b).parallel_to?(Line.new(c,d)))
  end

  def test_line_point_side
    a = Point.new(0,0)
    b = Point.new(1,1)
    line = Line.new(a,b)
    assert_equal(-1, line.point_side(Point.new(0,1)))
    assert_equal(0, line.point_side(Point.new(0.5,0.5)))
    assert_equal(1, line.point_side(Point.new(1,0)))
  end

  def test_line_contain_point
    a = Point.new(0,0)
    b = Point.new(1,1)
    c = Point.new(60,40)
    d = Point.new(55,70)
    l1 = Line.new(a,b)
    l2 = Line.new(c,d)
    assert_true( l1.contain_point?(Point.new(0.5,0.5)))
    assert_true( l1.contain_point?(Point.new(-1,-1)))
    assert_true( l1.contain_point?(Point.new(2,2)))
    assert_false(l1.contain_point?(Point.new(1,0)))
    assert_false(l1.contain_point?(Point.new(0,1)))
    assert_true( l2.contain_point?(c))
    assert_true( l2.contain_point?(d))
    assert_false(l2.contain_point?(Point.new(58,50)))
    assert_false(l2.contain_point?(Point.new(0,0)))
    assert_true( l2.contain_point?(Point.new(0,400)))
    # Vertical
    line = Line.new(a,Point.new(0,1))
    assert_true(line.contain_point?(Point.new(0,0.5)))
    # Horizontal
    line = Line.new(a,Point.new(1,0))
    assert_true(line.contain_point?(Point.new(0.5,0)))
  end

  def test_line_segment_contain_point
    a = Point.new(60,40)
    b = Point.new(55,70)
    line = Line.new(a,b)
    assert_true(line.segment_contain_point?(a))
    assert_true(line.segment_contain_point?(b))
    assert_false(line.segment_contain_point?(Point.new(58,50)))
    assert_false(line.segment_contain_point?(Point.new(0,0)))
    assert_false(line.segment_contain_point?(Point.new(0,400)))
  end

  def test_line_distance_to_point
    a = Point.new(0,0)
    b = Point.new(1,1)
    line = Line.new(a,b)
    assert_equal(0, line.distance_to_point(a))
    assert_equal(0, line.distance_to_point(b))
    assert_equal(0, line.distance_to_point(Point.new(0.5,0.5)))
    assert_in_epsilon(Math.sqrt(2) / 2, line.distance_to_point(Point.new(0.5,-0.5)))
    assert_equal(0, line.distance_to_point(Point.new(2,2)))
  end

  def test_line_segment_distance_to_point
    a = Point.new(0,0)
    b = Point.new(1,1)
    line = Line.new(a,b)
    assert_equal(0, line.segment_distance_to_point(a))
    assert_equal(0, line.segment_distance_to_point(b))
    assert_equal(0, line.segment_distance_to_point(Point.new(0.5,0.5)))
    assert_in_epsilon(Math.sqrt(2) / 2, line.segment_distance_to_point(Point.new(0.5,-0.5)))
    assert_equal(Math.sqrt(2), line.segment_distance_to_point(Point.new(2,2)))
  end

  def test_line_intersect_line_middle
    l1 = Line.new(Point.new(0,1), Point.new(5,5))
    l2 = Line.new(Point.new(2,5), Point.new(2,0))
    assert_equal(Point.new(2.0,2.6), l1.intersect_line(l2))
  end

  def test_line_intersect_line_vertex
    a = Point.new(0,0)
    l1 = Line.new(a, Point.new(0,5))
    l2 = Line.new(a, Point.new(5,0))
    assert_equal(a, l1.intersect_line(l2))
    # Intersect other lines beyond segment limits
    l3 = Line.new(Point.new(0,1), Point.new(0,2))
    l4 = Line.new(Point.new(1,0), Point.new(2,0))
    assert_equal(a, l3.intersect_line(l4))
  end

  def test_line_intersect_line_coincident
    a = Point.new(80,50)
    l1 = Line.new(a, Point.new(50,50))
    l2 = Line.new(a, Point.new(60,50))
    assert_equal(a, l1.intersect_line(l2))
  end

  def test_line_intersect_line_non_vertical_middle
    l1 = Line.new(Point.new(0,0), Point.new(1,1))
    l2 = Line.new(Point.new(0,1), Point.new(1,0))
    assert_equal(Point.new(0.5,0.5), l1.intersect_line_non_vertical(l2))
  end

  def test_line_intersect_line_non_vertical_vertex
    a = Point.new(0,0)
    b = Point.new(1,1)
    l1 = Line.new(a, b)
    l2 = Line.new(Point.new(2,0), b)
    assert_equal(b, l1.intersect_line_non_vertical(l2))
    # Intersect other lines beyond segment limits
    l3 = Line.new(Point.new(2,1), Point.new(3,0))
    assert_equal(Point.new(1.5,1.5), l1.intersect_line_non_vertical(l3))
  end

  def test_line_intersect_line_non_vertical_coincident
    a = Point.new(80,50)
    l1 = Line.new(a, Point.new(50,50))
    l2 = Line.new(a, Point.new(60,50))
    assert_equal(a, l1.intersect_line_non_vertical(l2))
  end

  def test_line_intersect_line_angle
    l1 = Line.new(Point.new(0,0), Point.new(1,0))
    l2 = Line.new(Point.new(0,0), Point.new(1,1))
    l3 = Line.new(Point.new(1,0), Point.new(0,0))
    l4 = Line.new(Point.new(0,0), Point.new(2,1))
    assert_equal(0, l1.intersect_line_angle(l1))
    assert_equal(0, l2.intersect_line_angle(l2))
    assert_equal(0, l1.intersect_line_angle(l3))
    assert_equal(Math::PI / 4, l1.intersect_line_angle(l2))
    assert_equal(Math::PI / 4, l2.intersect_line_angle(l1))
    assert_equal(Math::PI / 4, l2.intersect_line_angle(l3))
    assert_equal(Math::PI / 4, l3.intersect_line_angle(l2))
    assert_equal(Math.atan(1.fdiv(3)), l2.intersect_line_angle(l4))
  end

  def test_line_to_svg
    # Integer points
    l1 = Line.new(Point.new(1,2), Point.new(3,4))
    assert_equal("<line x1=\"1\" y1=\"2\" x2=\"3\" y2=\"4\" style=\"stroke:black\"><title>Line 1,2 3,4</title></line>\n", l1.to_svg)
    # Real points
    l1 = Line.new(Point.new(1.0,2.0), Point.new(3.0,4.0))
    assert_equal("<line x1=\"1.0\" y1=\"2.0\" x2=\"3.0\" y2=\"4.0\" style=\"stroke:black\"><title>Line 1.0,2.0 3.0,4.0</title></line>\n", l1.to_svg)
  end
end