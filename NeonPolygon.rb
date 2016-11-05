require_relative 'src/Point'
require_relative 'src/Line'
require_relative 'src/Polyline'
require_relative 'src/Polygon'
require_relative 'src/Circle'

class Numeric
  def approx(other, relative_epsilon = nil, epsilon = nil)
    self == other
  end
end

class Float
  def approx(other, relative_epsilon = EPSILON, epsilon = EPSILON)
    # Based on Ruby Cookbook
    (diff = (other - self).abs) <= epsilon || diff / (self > other ? self : other).abs <= relative_epsilon
  end
end

def svg_save(filename, svg, width, height, x_min = 0, y_min = 0, x_max = width, y_max = height)
  IO.write(filename, "<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"#{width}\" height=\"#{height}\" viewBox=\"#{x_min} #{y_min} #{x_max} #{y_max}\">\n#{svg}</svg>")
end

def svg_grid(width, height, step = 10)
"<defs>
<pattern id=\"grid\" width=\"#{step}\" height=\"#{step}\" patternUnits=\"userSpaceOnUse\">
  <path d=\"M 100 0 L 0 0 0 100\" style=\"fill:none;stroke:gray;stroke-width:0.5\"/>
</pattern>
</defs>
<rect fill=\"url(#grid)\" width=\"#{width}\" height=\"#{height}\"></rect>
<circle r=\"0.5\" style=\"fill:none;stroke:black;stroke-width:0.5\" title=\"Origin\"/>\n"
end