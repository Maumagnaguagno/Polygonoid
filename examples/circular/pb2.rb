require_relative 'Circular'

svg = svg_grid(1100, 1100)
srand(0)
t = Time.now.to_f
circles = Array.new(10) {Circle.new(50 + rand(1000), 50 + rand(1000), 5 + rand(50))}
circles.each {|c| svg << c.to_svg}
i = 0
circles.each {|a|
  circles.drop(i += 1).each {|b|
    d = Math.hypot(a.cx - b.cx, a.cy - b.cy)
    if a.radius + b.radius <= d
      l1, l2 = internal_bitangent_lines(a, b, d)
      svg << l1.to_svg('stroke:red') if visible?(l1, circles, a, b, svg)
      svg << l2.to_svg('stroke:red') if visible?(l2, circles, a, b, svg)
    end
    if (a.radius - b.radius).abs <= d
      l3, l4 = external_bitangent_lines(a, b, d)
      svg << l3.to_svg('stroke:blue') if visible?(l3, circles, a, b, svg)
      svg << l4.to_svg('stroke:blue') if visible?(l4, circles, a, b, svg)
    end
  }
}
p Time.now.to_f - t
svg_save('bitangent_forest.svg', svg, 'viewbox="0 0 200 200"')