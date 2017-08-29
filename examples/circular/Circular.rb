# Based on https://redblobgames.github.io/circular-obstacle-pathfinding/
require_relative '../../Polygonoid'

def move(x, y, amount, angle)
  Point.new(x + amount * Math.cos(angle), y + amount * Math.sin(angle))
end

def internal_bitangent_lines(a, b, d)
  angle = Math.acos((a.radius + b.radius).fdiv(d))
  ab = Math.atan2(b.cy - a.cy, b.cx - a.cx)
  ba = Math.atan2(a.cy - b.cy, a.cx - b.cx)
  c = move(a.cx, a.cy, a.radius, ab - angle)
  d = move(a.cx, a.cy, a.radius, ab + angle)
  e = move(b.cx, b.cy, b.radius, ba + angle)
  f = move(b.cx, b.cy, b.radius, ba - angle)
  [Line.new(c, f), Line.new(d, e)]
end

def external_bitangent_lines(a, b, d)
  angle = Math.acos((a.radius - b.radius).fdiv(d))
  ab = Math.atan2(b.cy - a.cy, b.cx - a.cx)
  c = move(a.cx, a.cy, a.radius, ab - angle)
  d = move(a.cx, a.cy, a.radius, ab + angle)
  e = move(b.cx, b.cy, b.radius, ab + angle)
  f = move(b.cx, b.cy, b.radius, ab - angle)
  [Line.new(c, f), Line.new(d, e)]
end

def visible?(line, circles, a, b)
  circles.all? {|c| c == a or c == b or line.segment_distance_to_point(Point.new(c.cx, c.cy)) >= c.radius}
end