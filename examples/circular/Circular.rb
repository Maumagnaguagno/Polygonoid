# Based on https://redblobgames.github.io/circular-obstacle-pathfinding/
require_relative '../../Polygonoid'

def get_point(cx, cy, radius, angle)
  Point.new(cx + radius * Math.cos(angle), cy + radius * Math.sin(angle))
end

def internal_bitangent_lines(a, b, d)
  angle = Math.acos((a.radius + b.radius).fdiv(d))
  ab = Math.atan2(b.cy - a.cy, b.cx - a.cx)
  ba = Math.atan2(a.cy - b.cy, a.cx - b.cx)
  c = get_point(a.cx, a.cy, a.radius, ab - angle)
  d = get_point(a.cx, a.cy, a.radius, ab + angle)
  e = get_point(b.cx, b.cy, b.radius, ba + angle)
  f = get_point(b.cx, b.cy, b.radius, ba - angle)
  [Line.new(c, f), Line.new(d, e)]
end

def external_bitangent_lines(a, b, d)
  angle = Math.acos((a.radius - b.radius).fdiv(d))
  ab = Math.atan2(b.cy - a.cy, b.cx - a.cx)
  c = get_point(a.cx, a.cy, a.radius, ab - angle)
  d = get_point(a.cx, a.cy, a.radius, ab + angle)
  e = get_point(b.cx, b.cy, b.radius, ab + angle)
  f = get_point(b.cx, b.cy, b.radius, ab - angle)
  [Line.new(c, f), Line.new(d, e)]
end

def visible?(line, circles, a, b)
  circles.all? {|c| c == a or c == b or line.segment_distance_to_point(Point.new(c.cx, c.cy)) >= c.radius}
end