require 'test/unit'
require './Polygonoid'

class Chain  < Test::Unit::TestCase

  def test_polyline_initialize
    a = Point.new(23,89)
    b = Point.new(155,0.8)
    c = Point.new(400,0)
    ab = Line.new(a,b)
    bc = Line.new(b,c)
    abc = Polyline.new(a, b, c)
    assert_equal([a,b,c], abc.vertices)
    assert_equal([ab, bc], abc.edges)
  end

  def test_polyline_perimeter
    a = Point.new(23,89)
    b = Point.new(155,0.8)
    c = Point.new(400,0)
    perimeter = Math.hypot(23 - 155, 89 - 0.8) + Math.hypot(155 - 400, 0.8)
    assert_equal(perimeter, Polyline.new(a, b, c).perimeter)
  end

  def test_polyline_contain_point
    a = Point.new(0,0)
    b = Point.new(0,1)
    c = Point.new(1,1)
    d = Point.new(1,0)
    p = Polyline.new(a, b, c, d)
    assert_equal(false, p.contain_point?(Point.new(0.5,0.5)))
    # Corners
    assert_equal(true, p.contain_point?(a))
    assert_equal(true, p.contain_point?(b))
    assert_equal(true, p.contain_point?(c))
    assert_equal(true, p.contain_point?(d))
    # Middle points
    assert_equal(true, p.contain_point?(Point.new(0,0.5)))
    assert_equal(true, p.contain_point?(Point.new(0.5,1)))
    assert_equal(true, p.contain_point?(Point.new(1,0.5)))
    assert_equal(false, p.contain_point?(Point.new(0.5,0)))
    # Outside
    assert_equal(false, p.contain_point?(Point.new(-0.5,0.5)))
    assert_equal(false, p.contain_point?(Point.new(0.5,1.5)))
    assert_equal(false, p.contain_point?(Point.new(1.5,0.5)))
    assert_equal(false, p.contain_point?(Point.new(0.5,-0.5)))
  end

  def test_polyline_to_svg
    poly = Polyline.new(Point.new(1,2), Point.new(3,4), Point.new(5,6))
    assert_equal("<polyline points=\"1,2 3,4 5,6\" style=\"fill:none;stroke:black\"><title>Polyline 1,2 3,4 5,6</title></polyline>\n", poly.to_svg)
  end
end