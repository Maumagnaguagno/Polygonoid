require_relative 'Circular'

a = Circle.new(150, 150, 130)
b = Circle.new(450, 150, 50)
d = Circular.center_distance(a, b)
svg = svg_grid << a.to_svg << b.to_svg
if a.radius + b.radius <= d
  l1, l2 = Circular.internal_bitangent_lines(a, b, d)
  svg << l1.to_svg('stroke:red') << l2.to_svg('stroke:red')
  abort('Unexpected internal bitangent lines') unless l1.from == Point.new(228, 46) and l1.to == Point.new(420, 190) and l2.from == Point.new(228, 254) and l2.to == Point.new(420, 110)
end
if (a.radius - b.radius).abs <= d
  l3, l4 = Circular.external_bitangent_lines(a, b, d)
  svg << l3.to_svg('stroke:blue') << l4.to_svg('stroke:blue')
  abort('Unexpected external bitangent lines') unless l3.from == Point.new(184.66, 24.70) and l3.to == Point.new(463.33, 101.81) and l4.from == Point.new(184.66, 275.29) and l4.to == Point.new(463.33, 198.18)
end
svg_save('bitangent_lines.svg', svg)