require_relative 'Circular'

svg = svg_grid
srand(0)
t = Time.now.to_f
circles = Array.new(100) {Circle.new(50 + rand(1000), 50 + rand(1000), 5 + rand(50))}.each {|c| svg << c.to_svg}
circles_dup = circles.dup
while a = circles_dup.shift
  circles_dup.each {|b|
    d = center_distance(a, b)
    if a.radius + b.radius <= d
      l1, l2 = internal_bitangent_lines(a, b, d)
      svg << l1.to_svg('stroke:red') if visible?(l1, circles, a, b)
      svg << l2.to_svg('stroke:red') if visible?(l2, circles, a, b)
    end
    if (a.radius - b.radius).abs <= d
      l3, l4 = external_bitangent_lines(a, b, d)
      svg << l3.to_svg('stroke:blue') if visible?(l3, circles, a, b)
      svg << l4.to_svg('stroke:blue') if visible?(l4, circles, a, b)
    end
  }
end
p Time.now.to_f - t
svg_save('bitangent_forest.svg', svg)