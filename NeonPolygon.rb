require_relative 'src/Point'
require_relative 'src/Line'
require_relative 'src/Polyline'
require_relative 'src/Polygon'

class Float
  def approx(other, relative_epsilon = EPSILON, epsilon = EPSILON)
    # Based on Ruby Cookbook
    difference = (other - self).abs
    difference <= epsilon || difference / (self > other ? self : other).abs <= relative_epsilon
  end
end