require_relative '../../Polygonoid'

# https://en.wikipedia.org/wiki/Ramer%E2%80%93Douglas%E2%80%93Peucker_algorithm
def simplify(points, epsilon = 0.001)
  first = points[0]
  last = points[-1]
  line = Line.new(first, last)
  # Find the point with the maximum distance
  max = index = 0
  1.upto(points.size - 1) {|i|
    d = line.segment_distance_to_point(points[i])
    if d > max
      index = i
      max = d
    end
  }
  # If max distance is greater than epsilon, recursively simplify
  if max > epsilon
    (s1 = simplify(points[0..index], epsilon)).pop
    s1.concat(simplify(points.drop(index), epsilon))
  else [first, last]
  end
end

simplify(
  [
    Point.new(0,0),
    Point.new(1,1),
    Point.new(2,1),
    Point.new(3,2.5),
    Point.new(4,4)
  ]
).each {|point| puts "(#{point.x},#{point.y})"}