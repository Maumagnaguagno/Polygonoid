# Move from S to G
# Environment is defined by one polygon
#  __________
# |    _     |
# | G | |_ S |
# |   |__/   |
# |__________|

require_relative '../../Polygonoid'

NDEG2RAD = Math::PI / -180

def rotate(from, to, angle)
  # Based on http://math.stackexchange.com/questions/1687901/how-to-rotate-a-line-segment-around-one-of-the-end-points
  angle *= NDEG2RAD
  sin = Math.sin(angle)
  cos = Math.cos(angle)
  x = to.x - from.x
  y = to.y - from.y
  Point.new(
    cos * x - sin * y + from.x,
    sin * x + cos * y + from.y
  )
end

def line_to_arc(from, to, angle, environment)
  point = rotate(from, to, -angle)
  yield point if visible?(from, point, environment)
  point = rotate(from, to, angle)
  yield point if visible?(from, point, environment)
end

def unsafe_line_to_arc(from, to, angle, environment)
  if from
    point = rotate(from, to, -angle)
    yield point if visible?(from, point, environment)
    point = rotate(from, to, angle)
    yield point if visible?(from, point, environment)
  else yield to
  end
end

def build_plan(point, goal, plan, name, svg, index)
  final_plan = [point, goal]
  while plan
    final_plan.unshift(plan.first)
    plan = plan.last
  end
  # Draw path
  svg << (path = Polyline.new(*final_plan)).to_svg('fill:none;stroke:green;stroke-width:0.5')
  svg_save("#{name}_t#{index}.svg", svg)
  puts "  Goal found, path length: #{path.perimeter}"
  final_plan
end

def search(name, start, goal, angle, environment)
  # Remove old files
  File.delete(*Dir.glob("#{name}*.svg"))
  # SVG
  svg = svg_grid(100, 100) << start.to_svg << goal.to_svg
  environment.each {|polygon| svg << polygon.to_svg}
  # Greedy best-first search
  reachable_positions = [start]
  visited = []
  visible_points = []
  index = 0
  until reachable_positions.empty?
    point, plan = reachable_positions.shift
    visited << point
    unsafe_line_to_arc(plan && plan.first, point, angle, environment) {|pos|
      new_svg = svg.dup
      puts "#{index += 1}: Point (#{pos.x}, #{pos.y})"
      # Build plan if goal visible test
      return build_plan(pos, goal, plan, name, new_svg, index) if visible?(pos, goal, environment)
      # Visible corners
      plan = [pos, plan]
      environment.each {|polygon|
        polygon.vertices.each {|v|
          if not visited.include?(v) and visible?(pos, v, environment)
            visible_points << [v, plan]
            new_svg << Line.new(pos, v).to_svg('stroke:red;stroke-width:0.5')
          end
        }
      }
      svg_save("#{name}_t#{index}.svg", new_svg)
    }
    # Visible points are reachable positions
    reachable_positions.concat(visible_points).sort_by! {|p| p.first.distance(goal)}
    reachable_positions.each {|p| puts "  Point (#{p.first.x}, #{p.first.y}) => Distance #{p.first.distance(goal)}"}
    visible_points.clear
  end
end

def search2(name, start, goal, angle, environment)
  # Remove old files
  File.delete(*Dir.glob("#{name}*.svg"))
  # SVG
  svg = svg_grid(100, 100) << start.to_svg << goal.to_svg
  environment.each {|polygon| svg << polygon.to_svg}
  # BFS
  reachable_positions = [start]
  visited = []
  visible_points = []
  index = 0
  until reachable_positions.empty?
    point, plan = reachable_positions.shift
    visited << point
    new_svg = svg.dup
    puts "#{index += 1}: Point (#{point.x}, #{point.y})"
    # Build plan if goal visible test
    return build_plan(point, goal, plan, name, new_svg, index) if visible?(point, goal, environment)
    # Visible corners
    plan = [point, plan]
    environment.each {|polygon|
      polygon.vertices.each {|v|
        if not visited.include?(v) and visible?(point, v, environment)
          line_to_arc(point, v, angle, environment) {|pos|
            visible_points << [pos, plan]
            new_svg << Line.new(point, pos).to_svg('stroke:red;stroke-width:0.5')
          }
        end
      }
    }
    # Visible points are reachable positions
    reachable_positions.concat(visible_points).sort_by! {|p| p.first.distance(goal)}
    reachable_positions.each {|p| puts "  Point (#{p.first.x}, #{p.first.y}) => Distance #{p.first.distance(goal)}"}
    visible_points.clear
    svg_save("#{name}_t#{index}.svg", new_svg)
  end
end