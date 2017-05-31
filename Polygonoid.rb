require_relative 'src/Point'
require_relative 'src/Line'
require_relative 'src/Polyline'
require_relative 'src/Polygon'
require_relative 'src/Circle'

class Numeric
  def approx(other, relative_epsilon = 0.001, epsilon = 0.001)
    # Based on Ruby Cookbook
    (diff = (other - self).abs) <= epsilon || diff.fdiv(self > other ? self : other).abs <= relative_epsilon
  end
end

def svg_grid(width, height, step = 10, style = 'fill:none;stroke:gray;stroke-width:0.5')
"<defs>
<pattern id=\"grid\" width=\"#{step}\" height=\"#{step}\" patternUnits=\"userSpaceOnUse\">
  <path d=\"M 100 0 L 0 0 0 100\" style=\"#{style}\"/>
</pattern>
</defs>
<rect fill=\"url(#grid)\" width=\"#{width}\" height=\"#{height}\"></rect>"
end

def svg_text(x, y, text, style = 'font-family:Helvetica;font-size:8px')
  "<text x=\"#{x}\" y=\"#{y}\" style=\"#{style}\">#{text}</text>"
end

def svg_save(filename, svg, options = nil)
  IO.write(filename, "<svg xmlns=\"http://www.w3.org/2000/svg\" #{options}>\n#{svg}</svg>")
end