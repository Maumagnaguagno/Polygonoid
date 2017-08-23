# Based on https://redblobgames.github.io/circular-obstacle-pathfinding/
require_relative '../../Polygonoid'

def internal_bitangent_lines(a, b)
  angle = Math.acos((a.radius + b.radius).fdiv(Math.hypot(a.cx - b.cx, a.cy - b.cy)))
  sin = Math.sin(angle)
  cos = Math.cos(angle)
  xa = a.cx + a.radius * cos
  xb = b.cx - b.radius * cos
  ra = a.radius * sin
  rb = b.radius * sin
  [Line.new(Point.new(xa, a.cy + ra), Point.new(xb, b.cy - rb)), Line.new(Point.new(xa, a.cy - ra), Point.new(xb, b.cy + rb))]
end

def external_bitangent_lines(a, b)
  angle = Math.acos((a.radius - b.radius).abs.fdiv(Math.hypot(a.cx - b.cx, a.cy - b.cy)))
  sin = Math.sin(angle)
  cos = Math.cos(angle)
  xa = a.cx + a.radius * cos
  xb = b.cx + b.radius * cos
  ra = a.radius * sin
  rb = b.radius * sin
  [Line.new(Point.new(xa, a.cy + ra), Point.new(xb, b.cy + rb)), Line.new(Point.new(xa, a.cy - ra), Point.new(xb, b.cy - rb))]
end

begin
  a = Circle.new(150, 150, 130)
  b = Circle.new(450, 150, 50)
  l1, l2 = internal_bitangent_lines(a, b)
  l3, l4 = external_bitangent_lines(a, b)
  svg = svg_grid(550, 300) << a.to_svg << b.to_svg << l1.to_svg('stroke:red') << l2.to_svg('stroke:red') << l3.to_svg('stroke:blue') << l4.to_svg('stroke:blue')
  svg_save('bitangent_lines.svg', svg, 'viewbox="0 0 550 300"')
end