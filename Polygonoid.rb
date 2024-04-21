#-----------------------------------------------
# Polygonoid
#-----------------------------------------------
# Mau Magnaguagno
#-----------------------------------------------
# Geometric library for Ruby
#-----------------------------------------------

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

def svg_grid(step = 10, style = 'fill:none;stroke:gray;stroke-width:0.5')
"<defs>
<pattern id=\"grid\" width=\"#{step}\" height=\"#{step}\" patternUnits=\"userSpaceOnUse\">
  <path d=\"M#{step} 0H0V#{step}\" style=\"#{style}\"/>
</pattern>
</defs>
<rect fill=\"url(#grid)\" width=\"100%\" height=\"100%\"/>\n"
end

def svg_text(x, y, text, style = 'font-family:Helvetica;font-size:8px')
  "<text x=\"#{x}\" y=\"#{y}\" style=\"#{style}\">#{text}</text>\n"
end

def svg_save(filename, svg, options = nil)
  File.binwrite(filename, "<svg xmlns=\"http://www.w3.org/2000/svg\" #{options}>\n#{svg}</svg>")
end

def visible?(from, to, environment)
  # Check if a line betweem from and to points intersects with each polygon edge from environment
  line = Line.new(from, to)
  environment.all? {|polygon|
    polygon.edges.none? {|e|
      # Collide with lines
      (intersection = line.intersect_line(e)) && intersection != to && e.segment_contain_point?(intersection) && line.segment_contain_point?(intersection)
      # Collide with lines, ignore vertices
      #(intersection = line.intersect_line(e)) && intersection != e.to && intersection != e.from && e.segment_contain_point?(intersection) && line.segment_contain_point?(intersection)
    }
  }
end