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

if $0 == __FILE__
  a = Circle.new(150, 150, 130)
  b = Circle.new(450, 150, 50)
  d = Math.hypot(a.cx - b.cx, a.cy - b.cy)
  svg = svg_grid(550, 300) << a.to_svg << b.to_svg
  if a.radius + b.radius <= d
    l1, l2 = internal_bitangent_lines(a, b, d)
    svg << l1.to_svg('stroke:red') << l2.to_svg('stroke:red')
    puts 'Unexpected internal bitangent lines' unless l1.from == Point.new(228, 46) and l1.to == Point.new(420, 190) and l2.from == Point.new(228, 254) and l2.to == Point.new(420, 110)
  end
  if (a.radius - b.radius).abs <= d
    l3, l4 = external_bitangent_lines(a, b, d)
    svg << l3.to_svg('stroke:blue') << l4.to_svg('stroke:blue')
    puts 'Unexpected external bitangent lines' unless l3.from == Point.new(184.66, 24.70) and l3.to == Point.new(463.33, 101.81) and l4.from == Point.new(184.66, 275.29) and l4.to == Point.new(463.33, 198.18)
  end
  svg_save('bitangent_lines.svg', svg, 'viewbox="0 0 550 300"')

  # Forest
  svg = svg_grid(1100, 1100)
  srand(0)
  circles = Array.new(5) {Circle.new(50 + rand(1000), 50 + rand(1000), 5 + rand(50))}
  circles.each {|c| svg << c.to_svg}
  i = 0
  circles.each {|a|
    circles.drop(i += 1).each {|b|
      d = Math.hypot(a.cx - b.cx, a.cy - b.cy)
      if a.radius + b.radius <= d
        l1, l2 = internal_bitangent_lines(a, b, d)
        svg << l1.to_svg('stroke:red') << l2.to_svg('stroke:red')
      end
      if (a.radius - b.radius).abs <= d
        l3, l4 = external_bitangent_lines(a, b, d)
        svg << l3.to_svg('stroke:blue') << l4.to_svg('stroke:blue')
      end
    }
  }
  svg_save('bitangent_forest.svg', svg, 'viewbox="0 0 200 200"')
end