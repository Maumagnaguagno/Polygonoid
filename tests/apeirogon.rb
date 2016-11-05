require 'test/unit'
require './NeonPolygon'

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
    abc = Polygon.new(a, b, c)
    perimeter = Math.hypot(23 - 155, 89 - 0.8) + Math.hypot(155 - 400, 0.8 - 0) + Math.hypot(400 - 23, 0 - 89)
    assert_equal(perimeter, abc.perimeter)
  end

  def test_polygon_to_svg
    poly = Polygon.new(Point.new(1,2), Point.new(3,4), Point.new(5,6))
    assert_equal("<polygon points=\"1,2 3,4 5,6\" style=\"fill:gray;stroke:black\" title=\"Polygon 1,2 3,4 5,6\"/>\n", poly.to_svg)
  end
end