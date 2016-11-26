# Move robot R to goal G
# Environment is defined by one polygon
#  __________
# |    _     |
# | G | |_ R |
# |   |__/   |
# |__________|

require_relative '../NeonPolygon'

def visible?(position, vertex, environment, edge_collisions = true, svg = nil)
  # Check if line intersects with each polygon edge from environment
  line = Line.new(position, vertex)
  if edge_collisions
    environment.all? {|polygon|
      polygon.edges.none? {|e|
        intersection = line.intersect_line(e)
        collision = intersection && intersection != vertex && e.contain_point?(intersection) && line.contain_point?(intersection)
        svg << line.to_svg('stroke:yellow;stroke-width:0.5') << intersection.to_svg('fill:blue;stroke:blue;stroke-width:0.5') if svg and collision
        collision
      }
    }
  else
    environment.all? {|polygon|
      polygon.edges.none? {|e|
        intersection = line.intersect_line(e)
        collision = intersection && intersection != e.to && intersection != e.from && e.contain_point?(intersection) && line.contain_point?(intersection)
        svg << line.to_svg('stroke:yellow;stroke-width:0.5') << intersection.to_svg('fill:blue;stroke:blue;stroke-width:0.5') if svg and collision
        collision
      }
    }
  end
end

def nearby(point)
  x0 = point.x
  y0 = point.y
  Point.new(x0, y0 - 5)
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
robot = Point.new(80.0,50.0)
goal = Point.new(15.0,50.0)

# SVG
svg = svg_grid(500, 500) << robot.to_svg << goal.to_svg
environment.each {|object| svg << object.to_svg}
svg_save('robot_t0.svg', svg, 500, 500, 0, 0, 100, 100)

reachable_positions = [robot]
visited = []
visible_points = []

index = 0
while pos = reachable_positions.shift
  visited << pos
  pos = nearby(pos)

  index += 1
  new_svg = svg.dup
  puts "#{index}: Point (#{pos.x}, #{pos.y})"
  # Goal visible test
  if visible?(pos, goal, environment)
    new_svg << Line.new(pos, goal).to_svg('stroke:green;stroke-width:0.5')
    svg_save("robot_t#{index}.svg", new_svg, 500, 500, 0, 0, 100, 100)
    puts 'Goal'
    break
  end

  # Visible corners
  environment.each {|polygon|
    polygon.vertices.each {|v|
      if not visited.include?(v) and visible?(pos, v, environment, true, new_svg)
        visible_points << v
        new_svg << Line.new(pos, v).to_svg('stroke:red;stroke-width:0.5')
      end
    }
  }
  svg_save("robot_t#{index}.svg", new_svg, 500, 500, 0, 0, 100, 100)

  # TODO merge visible points with visible polygon
  # Visible points are reachable positions
  reachable_positions.push(*visible_points).sort_by! {|p| p.distance(goal)}
  reachable_positions.each {|p| puts "  Point (#{p.x}, #{p.y}) => Distance #{p.distance(goal)}"}
  
  visible_points.clear
  STDIN.gets
end