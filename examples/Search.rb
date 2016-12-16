# Move from S to G
# Environment is defined by one polygon
#  __________
# |    _     |
# | G | |_ S |
# |   |__/   |
# |__________|

require_relative '../NeonPolygon'

NDEG2RAD = Math::PI / -180

def visible?(a, b, environment, svg = nil)
  # Check if line intersects with each polygon edge from environment
  line = Line.new(a, b)
  environment.all? {|polygon|
    polygon.edges.none? {|e|
      intersection = line.intersect_line(e)
      # Collide with lines
      collision = intersection && intersection != b && e.contain_point?(intersection) && line.contain_point?(intersection)
      # Collide with lines, ignore vertices
      #collision = intersection && intersection != e.to && intersection != e.from && e.contain_point?(intersection) && line.contain_point?(intersection)
      svg << line.to_svg('stroke:yellow;stroke-width:0.5') << intersection.to_svg('fill:blue;stroke:blue;stroke-width:0.5') if svg and collision
      collision
    }
  }
end

def rotate(a, b, angle)
  # Based on http://math.stackexchange.com/questions/1687901/how-to-rotate-a-line-segment-around-one-of-the-end-points
  angle *= NDEG2RAD
  sin = Math.sin(angle)
  cos = Math.cos(angle)
  bax = b.x - a.x
  bay = b.y - a.y
  Point.new(
    cos * bax - sin * bay + a.x,
    sin * bax + cos * bay + a.y
  )
end

def nearby(a, b, environment)
  if a
    point = rotate(a, b, -10)
    yield point if visible?(a, point, environment)
    point = rotate(a, b, 10)
    yield point if visible?(a, point, environment)
  else
    yield b
  end
end

def search(start, goal, environment)
  # SVG
  svg = svg_grid(500, 500) << start.to_svg << goal.to_svg
  environment.each {|polygon| svg << polygon.to_svg}
  # BFS
  reachable_positions = [start]
  visited = []
  visible_points = []
  index = 0
  until reachable_positions.empty?
    point, plan = reachable_positions.shift
    visited << point
    nearby(plan && plan.first, point, environment) {|pos|
      index += 1
      new_svg = svg.dup
      puts "#{index}: Point (#{pos.x}, #{pos.y})"
      # Goal visible test
      if visible?(pos, goal, environment, new_svg)
        puts '  Goal found'
        # Build plan
        final_plan = [pos, goal]
        while plan
          final_plan.unshift(plan.first)
          plan = plan.last
        end
        # Draw path
        new_svg << Polyline.new(*final_plan).to_svg('fill:none;stroke:green;stroke-width:0.5')
        svg_save("search_t#{index}.svg", new_svg, 500, 500, 0, 0, 100, 100)
        return final_plan
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
    }
    # Visible points are reachable positions
    reachable_positions.push(*visible_points).sort_by! {|p| p.first.distance(goal)}
    reachable_positions.each {|p| puts "  Point (#{p.first.x}, #{p.first.y}) => Distance #{p.first.distance(goal)}"}
    visible_points.clear
  end
end

search(
  # Start
  Point.new(80.0,50.0),
  # Goal
  Point.new(15.0,50.0),
  # Environment
  [
    Polygon.new(
      Point.new(35,30),
      Point.new(50,30),
      Point.new(50,50),
      Point.new(60,50),
      Point.new(55,70),
      Point.new(35,70)
    )
  ]
)