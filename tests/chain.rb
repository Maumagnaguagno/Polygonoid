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
    abc = Polyline.new(a, b, c)
    perimeter = Math.hypot(23 - 155, 89 - 0.8) + Math.hypot(155 - 400, 0.8)
    assert_equal(perimeter, abc.perimeter)
  end

  def test_polyline_to_svg
    poly = Polyline.new(Point.new(1,2), Point.new(3,4), Point.new(5,6))
    assert_equal("<polyline points=\"1,2 3,4 5,6\" style=\"fill:none;stroke:black\"><title>Polyline 1,2 3,4 5,6</title></polyline>\n", poly.to_svg)
  end
end