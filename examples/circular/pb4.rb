require_relative '../search/Search'
require_relative 'Circular'

CLOCK = true
COUNTER = false

def search(svg, start, goal, circles, bitangents_clock, bitangents_counter)
  # Greedy best-first search
  goal_point = center(goal)
  reachable_positions = [[start, center(start), CLOCK], [start, center(start), COUNTER]]
  visited = []
  visible_points = []
  until reachable_positions.empty?
    circle, point, in_dir, plan = reachable_positions.shift
    visited << point
    # Build plan if goal visible test
    return build_plan(point, goal_point, plan, 'circular_search', svg) if visible?(Line.new(point, goal_point), circles, circle, goal)
    # Bitangents that go from current circle using current direction
    each_bitangent(circle, in_dir, circles) {|c,line,out_dir|
      visible_points << [c, line.to, out_dir, [line.to, [line.from, plan]]] unless visited.include?(line.to)
    }
    # Visible points are reachable positions
    # TODO consider current circle and goal radius
    reachable_positions.concat(visible_points).sort_by! {|c| center(c.first).distance(goal_point)}
    visible_points.clear
  end
end

def center(circle)
  Point.new(circle.cx, circle.cy)
end

def reverse(line)
  Line.new(line.to, line.from)
end

def each_bitangent(a, in_dir, circles)
  circles.each {|b|
    d = Math.hypot(a.cx - b.cx, a.cy - b.cy)
    if a.radius + b.radius <= d
      l1, l2 = internal_bitangent_lines(a, b, d)
      yield [b, l1, COUNTER] if in_dir == CLOCK and visible?(l1, circles, a, b)
      yield [b, l2, CLOCK] if in_dir == COUNTER and visible?(l2, circles, a, b)
    end
    if (a.radius - b.radius).abs <= d
      l3, l4 = external_bitangent_lines(a, b, d)
      yield [b, l3, CLOCK] if in_dir == CLOCK and visible?(l3, circles, a, b)
      yield [b, l4, COUNTER] if in_dir == COUNTER and visible?(l4, circles, a, b)
    end
  }
end

start = Circle.new(0,80,0)
goal = Circle.new(1000,1000,0)
svg = svg_grid(1000,1000) << start.to_svg << goal.to_svg
bitangents_clock = Hash.new {|h,k| h[k] = []}
bitangents_counter = Hash.new {|h,k| h[k] = []}
t = Time.now.to_f
srand(0)
circles = Array.new(100) {Circle.new(50 + rand(1000), 50 + rand(1000), 5 + rand(50))}.each {|c| svg << c.to_svg}
puts 'search'
search(svg, start, goal, circles, bitangents_clock, bitangents_counter)
p Time.now.to_f - t