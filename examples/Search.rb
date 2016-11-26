# Move from S to goal G
# Environment is defined by one polygon
#  __________
# |    _     |
# | G | |_ S |
# |   |__/   |
# |__________|

require_relative '../NeonPolygon'

def visible?(position, vertex, environment, svg = nil)
  # Check if line intersects with each polygon edge from environment
  line = Line.new(position, vertex)
  environment.all? {|polygon|
    polygon.edges.none? {|e|
      intersection = line.intersect_line(e)
      collision = intersection && intersection != vertex && e.contain_point?(intersection) && line.contain_point?(intersection)
      svg << line.to_svg('stroke:yellow;stroke-width:0.5') << intersection.to_svg('fill:blue;stroke:blue;stroke-width:0.5') if svg and collision
      collision
    }
  }
end

def visible_with_edges?(position, vertex, environment, svg = nil)
  # Check if line intersects with each polygon edge from environment
  line = Line.new(position, vertex)
  environment.all? {|polygon|
    polygon.edges.none? {|e|
      intersection = line.intersect_line(e)
      collision = intersection && intersection != e.to && intersection != e.from && e.contain_point?(intersection) && line.contain_point?(intersection)
      svg << line.to_svg('stroke:yellow;stroke-width:0.5') << intersection.to_svg('fill:blue;stroke:blue;stroke-width:0.5') if svg and collision
      collision
    }
  }
end

def nearby(point)
  # TODO generate several visible points
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

# Start and Goal
start = Point.new(80.0,50.0)
goal = Point.new(15.0,50.0)

# SVG
svg = svg_grid(500, 500) << start.to_svg << goal.to_svg
environment.each {|object| svg << object.to_svg}

reachable_positions = [start]
visited = [start]
visible_points = []

index = 0
until reachable_positions.empty?
  pos, plan = reachable_positions.shift
  visited << pos
  pos = nearby(pos)

  index += 1
  new_svg = svg.dup
  puts "#{index}: Point (#{pos.x}, #{pos.y})"
  # Goal visible test
  if visible?(pos, goal, environment, new_svg)
    puts 'Goal'
    # Build plan
    final_plan = [pos, goal]
    while plan
      final_plan.unshift(plan.first)
      plan = plan.last
    end
    final_plan.unshift(start)
    # Draw path
    final_plan.each_cons(2) {|from,to|
      new_svg << Line.new(from, to).to_svg('stroke:green;stroke-width:0.5')
    }
    svg_save("search_t#{index}.svg", new_svg, 500, 500, 0, 0, 100, 100)
    break
  end

  # Visible corners
  plan = [pos, plan]
  environment.each {|polygon|
    polygon.vertices.each {|v|
      if not visited.include?(v) and visible?(pos, v, environment, new_svg)
        visible_points << [v, plan]
        new_svg << Line.new(pos, v).to_svg('stroke:red;stroke-width:0.5')
      end
    }
  }
  svg_save("search_t#{index}.svg", new_svg, 500, 500, 0, 0, 100, 100)

  # Visible points are reachable positions
  reachable_positions.push(*visible_points).sort_by! {|p| p.first.distance(goal)}
  reachable_positions.each {|p| puts "  Point (#{p.first.x}, #{p.first.y}) => Distance #{p.first.distance(goal)}"}
  
  visible_points.clear
  STDIN.gets
end