require_relative '../../Polygonoid'

# https://en.wikipedia.org/wiki/Ramer%E2%80%93Douglas%E2%80%93Peucker_algorithm
def simplify(points, epsilon = 0.001, f = 0, l = points.size - 1)
  first = points[f]
  last = points[l]
  line = Line.new(first, last)
  # Find the point with the maximum distance
  max = index = 0
  (f + 1).upto(l - 1) {|i|
    d = line.segment_distance_to_point(points[i])
    if d > max
      index = i
      max = d
    end
  }
  # If max distance is greater than epsilon, recursively simplify
  if max > epsilon
    (s1 = simplify(points, epsilon, f, index)).pop
    s1.concat(simplify(points, epsilon, index, l))
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