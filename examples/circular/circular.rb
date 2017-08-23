# Based on https://redblobgames.github.io/circular-obstacle-pathfinding/
require_relative '../../Polygonoid'

def internal_bitangent_lines(a, b, d)
  angle = Math.acos((a.radius + b.radius).fdiv(d))
  sin = Math.sin(angle)
  cos = Math.cos(angle)
  xa = a.cx + a.radius * cos
  xb = b.cx - b.radius * cos
  ra = a.radius * sin
  rb = b.radius * sin
  [Line.new(Point.new(xa, a.cy + ra), Point.new(xb, b.cy - rb)), Line.new(Point.new(xa, a.cy - ra), Point.new(xb, b.cy + rb))]
end

def external_bitangent_lines(a, b, d)
  angle = Math.acos((a.radius - b.radius).abs.fdiv(d))
  sin = Math.sin(angle)
  cos = Math.cos(angle)
  xa = a.cx + a.radius * cos
  xb = b.cx + b.radius * cos
  ra = a.radius * sin
  rb = b.radius * sin
  [Line.new(Point.new(xa, a.cy + ra), Point.new(xb, b.cy + rb)), Line.new(Point.new(xa, a.cy - ra), Point.new(xb, b.cy - rb))]
end

if $0 == __FILE__
  a = Circle.new(150, 150, 130)
  b = Circle.new(450, 150, 50)
  d = Math.hypot(a.cx - b.cx, a.cy - b.cy)
  svg = svg_grid(550, 300) << a.to_svg << b.to_svg
  if a.radius + b.radius <= d
    l1, l2 = internal_bitangent_lines(a, b, d)
    svg << l1.to_svg('stroke:red') << l2.to_svg('stroke:red')
    puts 'Unexpected internal bitangent lines' unless l1.from == Point.new(228, 254) and l1.to == Point.new(420, 110) and l2.from == Point.new(228, 46) and l2.to == Point.new(420, 190)
  end
  if (a.radius - b.radius).abs <= d
    l3, l4 = external_bitangent_lines(a, b, d)
    svg << l3.to_svg('stroke:blue') << l4.to_svg('stroke:blue')
    puts 'Unexpected external bitangent lines' unless l3.from == Point.new(184.66, 275.29) and l3.to == Point.new(463.33, 198.18) and l4.from == Point.new(184.66, 24.70) and l4.to == Point.new(463.33, 101.81)
  end
  svg_save('bitangent_lines.svg', svg, 'viewbox="0 0 550 300"')
end