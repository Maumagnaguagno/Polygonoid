require 'test/unit'
require './Polygonoid'

class Apeirogon  < Test::Unit::TestCase

  def test_polygon_initialize
    a = Point.new(23,89)
    b = Point.new(155,0.8)
    c = Point.new(400,0)
    ab = Line.new(a,b)
    bc = Line.new(b,c)
    ca = Line.new(c,a)
    abc = Polygon.new(a, b, c)
    assert_equal([a,b,c], abc.vertices)
    assert_equal([ab, bc, ca], abc.edges)
  end

  def test_polygon_perimeter
    a = Point.new(23,89)
    b = Point.new(155,0.8)
    c = Point.new(400,0)
    perimeter = Math.hypot(23 - 155, 89 - 0.8) + Math.hypot(155 - 400, 0.8) + Math.hypot(400 - 23, -89)
    assert_equal(perimeter, Polygon.new(a, b, c).perimeter)
  end

  def test_polygon_area
    a = Point.new(0,0)
    b = Point.new(0,1)
    c = Point.new(1,1)
    d = Point.new(1,0)
    assert_equal(1, Polygon.new(a, b, c, d).area)
    assert_equal(-1, Polygon.new(d, c, b, a).area)
    assert_equal(0.5, Polygon.new(a, b, c).area)
    assert_equal(-0.5, Polygon.new(c, b, a).area)
  end

  def test_polygon_center
    a = Point.new(0,0)
    b = Point.new(0,1)
    c = Point.new(1,1)
    d = Point.new(1,0)
    c1 = Point.new(0.5,0.5)
    c2 = Point.new(1.fdiv(3),2.fdiv(3))
    assert_equal(c1, Polygon.new(a, b, c, d).center)
    assert_equal(c1, Polygon.new(d, c, b, a).center)
    assert_equal(c2, Polygon.new(a, b, c).center)
    assert_equal(c2, Polygon.new(c, b, a).center)
  end

  def test_polygon_contain_point
    a = Point.new(0,0)
    b = Point.new(0,1)
    c = Point.new(1,1)
    d = Point.new(1,0)
    p = Polygon.new(a, b, c, d)
    assert_equal(true, p.contain_point?(Point.new(0.5,0.5)))
    # Corners
    assert_equal(true, p.contain_point?(a))
    assert_equal(true, p.contain_point?(b))
    assert_equal(true, p.contain_point?(c))
    assert_equal(true, p.contain_point?(d))
    # Middle points
    assert_equal(true, p.contain_point?(Point.new(0,0.5)))
    assert_equal(true, p.contain_point?(Point.new(0.5,1)))
    assert_equal(true, p.contain_point?(Point.new(1,0.5)))
    assert_equal(true, p.contain_point?(Point.new(0.5,0)))
    # Outside
    assert_equal(false, p.contain_point?(Point.new(-0.5,0.5)))
    assert_equal(false, p.contain_point?(Point.new(0.5,1.5)))
    assert_equal(false, p.contain_point?(Point.new(1.5,0.5)))
    assert_equal(false, p.contain_point?(Point.new(0.5,-0.5)))
  end

  def test_polygon_to_svg
    poly = Polygon.new(Point.new(1,2), Point.new(3,4), Point.new(5,6))
    assert_equal("<polygon points=\"1,2 3,4 5,6\" style=\"fill:gray;stroke:black\"><title>Polygon 1,2 3,4 5,6</title></polygon>\n", poly.to_svg)
  end
end