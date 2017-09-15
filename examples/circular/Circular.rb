# Based on https://redblobgames.github.io/circular-obstacle-pathfinding/
require_relative '../../Polygonoid'

def move(x, y, amount, angle)
  Point.new(x + amount * Math.cos(angle), y + amount * Math.sin(angle))
end

def internal_bitangent_lines(a, b, d)
  angle = Math.acos((a.radius + b.radius).fdiv(d))
  ab = Math.atan2(b.y - a.y, b.x - a.x)
  ba = Math.atan2(a.y - b.y, a.x - b.x)
  [
    Line.new(move(a.x, a.y, a.radius, ab - angle), move(b.x, b.y, b.radius, ba - angle)), # C to F
    Line.new(move(a.x, a.y, a.radius, ab + angle), move(b.x, b.y, b.radius, ba + angle)) # D to E
  ]
end

def external_bitangent_lines(a, b, d)
  angle = Math.acos((a.radius - b.radius).fdiv(d))
  ab = Math.atan2(b.y - a.y, b.x - a.x)
  [
    Line.new(move(a.x, a.y, a.radius, ab - angle), move(b.x, b.y, b.radius, ab - angle)), # C to F
    Line.new(move(a.x, a.y, a.radius, ab + angle), move(b.x, b.y, b.radius, ab + angle)) # D to E
  ]
end

def visible?(line, circles, a, b)
  circles.all? {|c| c == a or c == b or line.segment_distance_to_point(c) >= c.radius}
end

def center_distance(a, b)
  Math.hypot(a.x - b.x, a.y - b.y)
end