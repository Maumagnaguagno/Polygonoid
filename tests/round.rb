require 'test/unit'
require './Polygonoid'

class Round < Test::Unit::TestCase

  def test_circle_initialize
    circle = Circle.new(1,2,3)
    assert_equal(1, circle.x)
    assert_equal(2, circle.y)
    assert_equal(3, circle.radius)
  end

  def test_circle_equality
    a = Circle.new(23,89,5)
    b = Circle.new(23,89,5)
    c = Circle.new(400,5,10)
    assert_equal(a, a)
    assert_equal(a, b)
    assert_not_equal(a, c)
  end

  def test_circle_perimeter
    assert_equal(Math::PI * 6, Circle.new(1,2,3).perimeter)
  end

  def test_circle_area
    assert_equal(Math::PI * 3 ** 2, Circle.new(1,2,3).area)
  end

  def test_circle_contain_point
    circle = Circle.new(0,0,3)
    assert_true(circle.contain_point?(Point.new(0,0)))
    assert_true(circle.contain_point?(Point.new(0,3)))
    assert_true(circle.contain_point?(Point.new(3,0)))
    assert_false(circle.contain_point?(Point.new(3,3)))
  end

  def test_circle_distance_to_point
    circle = Circle.new(0,0,3)
    assert_equal(0, circle.distance_to_point(Point.new(0,0)))
    assert_equal(0, circle.distance_to_point(Point.new(0,3)))
    assert_equal(0, circle.distance_to_point(Point.new(3,0)))
    assert_in_epsilon(Math.hypot(3,3) - 3, circle.distance_to_point(Point.new(3,3)))
  end

  def test_circle_to_svg
    circle = Circle.new(1,2,3)
    assert_equal("<circle cx=\"1\" cy=\"2\" r=\"3\" style=\"fill:gray;stroke:black\"><title>Circle 1,2 3</title></circle>\n", circle.to_svg)
  end
end