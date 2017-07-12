require_relative 'Search'

def nearby(from, to, angle, environment)
  point = rotate(from, to, -angle)
  yield point if visible?(from, point, environment)
  point = rotate(from, to, angle)
  yield point if visible?(from, point, environment)
end

def search(name, start, goal, angle, environment)
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
    return build_plan(point, goal, plan, name, new_svg, index) if visible?(point, goal, environment, new_svg)
    # Visible corners
    plan = [point, plan]
    environment.each {|polygon|
      polygon.vertices.each {|v|
        if not visited.include?(v) and visible?(point, v, environment, new_svg)
          nearby(point, v, angle, environment) {|pos|
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
    svg_save("#{name}_t#{index}.svg", new_svg, 'viewbox="0 0 100 100"')
  end
end