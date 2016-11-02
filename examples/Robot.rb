# Move robot R to goal G
# Environment is defined by one polygon
#  __________
# |    _     |
# | G | |_ R |
# |   |__/   |
# |__________|

require_relative '../NeonPolygon'

def visible?(position, vertex, environment)
  # Check if line intersects with anything
  line = Line.new(position, vertex)
  environment.all? {|polygon|
    polygon.edges.none? {|e|
      intersection = line.intersect_line(e)
      intersection && intersection != vertex && e.contain_point?(intersection) && line.contain_point?(intersection)
    }
  }
end

def svg_save(filename, svg, width, height, x_min = 0, y_min = 0, x_max = width, y_max = height)
  IO.write(filename, ""<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"#{width}\" height=\"#{height}\" viewBox=\"#{x_min} #{y_min} #{x_max} #{y_max}\">\n#{svg}</svg>")
end

def svg_grid(width, height)
"<defs>
<pattern id=\"grid\" width=\"10\" height=\"10\" patternUnits=\"userSpaceOnUse\">
   <path d=\"M 100 0 L 0 0 0 100\" fill=\"none\" stroke=\"gray\" stroke-width=\"1\"/>
</pattern>
</defs>
<rect fill=\"url(#grid)\" width=\"#{width}\" height=\"#{height}\"></rect>
<circle r=\"2\"/>\n"
end

# Environment
environment = [
  Polygon.new(
    Point.new(35,30),
    Point.new(50,30),
    Point.new(50,50),
    Point.new(60,50),
    Point.new(55,70),
    Point.new(35,70)
  )
]

# Robot and Goal
robot = Point.new(80,50)
goal = Point.new(15,50)

# SVG
svg = svg_grid(500, 500)
environment.each {|object| svg << object.to_svg}
svg << robot.to_svg << goal.to_svg
svg_save('test.svg', svg, 500, 500, 0, 0, 100, 100)

reachable_positions = [robot]
visited = []

while pos = reachable_positions.shift
  puts "Point (#{pos.x}, #{pos.y})"
  # Try to see goal
  if visible?(pos, goal, environment)
    puts 'Goal'
    break
  end
  visited << pos

  # Robot look at environment, sees polygon
  visible_points = [] # TODO add pos here?
  environment.each {|polygon| polygon.vertices.each {|v| visible_points << v if visible?(pos, v, environment)}}
  #visible_points -= visited
  #visible_points.sort_by! {|p| p.distance(goal)}
  visible_points.each {|p| puts "  Point (#{p.x}, #{p.y}) => Distance #{p.distance(goal)}"}

  # TODO merge visible points with visible polygon
  # Visible points are reachable positions
  reachable_positions.push(*visible_points)
  
  STDIN.gets
end