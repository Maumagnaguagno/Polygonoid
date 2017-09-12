require_relative '../search/Search'
require_relative 'Circular'

def search(svg, start, goal, circles, bitangents_clock, bitangents_counter)
  # Greedy best-first search
  goal_point = center(goal)
  reachable_positions = [[start, center(start), bitangents_clock[start].concat(bitangents_counter[start])]]
  visited = []
  visible_points = []
  until reachable_positions.empty?
    circle, point, in_bitangents, plan = reachable_positions.shift
    visited << point
    # Build plan if goal visible test
    return build_plan(point, goal_point, plan, 'circular_search', svg) if visible?(Line.new(point, goal_point), circles, circle, goal)
    # Bitangents that go from current circle using current direction
    in_bitangents.each {|c,line,out_bitangents|
      visible_points << [c, line.to, out_bitangents, [line.to, [line.from, plan]]] unless visited.include?(line.to)
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

def bitangents(a, b, bitangents_clock, bitangents_counter, circles, bidir)
  d = Math.hypot(a.cx - b.cx, a.cy - b.cy)
  if a.radius + b.radius <= d
    l1, l2 = internal_bitangent_lines(a, b, d)
    if visible?(l1, circles, a, b)
      bitangents_clock[a] << [b, l1, bitangents_counter[b]]
      bitangents_clock[b] << [a, reverse(l1), bitangents_counter[a]] if bidir
    end
    if visible?(l2, circles, a, b)
      bitangents_counter[a] << [b, l2, bitangents_clock[b]]
      bitangents_counter[b] << [a, reverse(l2), bitangents_clock[a]] if bidir
    end
  end
  if (a.radius - b.radius).abs <= d
    l3, l4 = external_bitangent_lines(a, b, d)
    if visible?(l3, circles, a, b)
      bitangents_clock[a] << [b, l3, bitangents_clock[b]]
      bitangents_counter[b] << [a, reverse(l3), bitangents_clock[a]] if bidir
    end
    if visible?(l4, circles, a, b)
      bitangents_counter[a] << [b, l4, bitangents_counter[b]]
      bitangents_clock[b] << [a, reverse(l4), bitangents_clock[a]] if bidir
    end
  end
end

start = Circle.new(0,80,0)
goal = Circle.new(1000,1000,0)
svg = svg_grid(1000,1000) << start.to_svg << goal.to_svg
bitangents_clock = Hash.new {|h,k| h[k] = []}
bitangents_counter = Hash.new {|h,k| h[k] = []}
t = Time.now.to_f
srand(0)
circles = Array.new(100) {Circle.new(50 + rand(1000), 50 + rand(1000), 5 + rand(50))}
circles.each {|c|
  svg << c.to_svg
  # Start to circle
  bitangents(start, c, bitangents_clock, bitangents_counter, circles, false)
  # Circle to goal
  #bitangents(c, goal, bitangents_clock, bitangents_counter, circles, false)
}
# Circle to circle
# Equivalent but faster than circles.each {|a| circles.each {|b| bitangents(a, b, bitangents_clock, bitangents_counter, circles, false)}}
circles_dup = circles.dup
while a = circles_dup.shift
  circles_dup.each {|b| bitangents(a, b, bitangents_clock, bitangents_counter, circles, true)}
end

p Time.now.to_f - t
puts 'search'
search(svg, start, goal, circles, bitangents_clock, bitangents_counter)
p Time.now.to_f - t